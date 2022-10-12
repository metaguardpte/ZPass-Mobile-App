package com.zpassapp.zpass.rpc

import com.google.gson.Gson
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import kotlinx.coroutines.channels.Channel
import java.util.concurrent.Executors
import java.util.concurrent.atomic.AtomicBoolean
import kotlin.collections.ArrayDeque

class RpcManager : MethodChannel.MethodCallHandler {

    private val blockingCallTasks: ArrayDeque<CallTask> by lazy {
        ArrayDeque(1024)
    }

    private val safetySingleThreadScope: CoroutineScope by lazy {
        CoroutineScope(Executors.newSingleThreadExecutor().asCoroutineDispatcher())
    }

    private var methodChannelReady: AtomicBoolean = AtomicBoolean(false)
    private var channel: MethodChannel? = null

    fun init(engine: FlutterEngine) {
        channel = MethodChannel(engine.dartExecutor.binaryMessenger, RPC_CHANNEL_ID).apply {
            setMethodCallHandler(this@RpcManager)
        }
    }

    suspend fun createInstance(clazz: String, args: Any? = null): Long? {
        val params = mapOf<String, Any>(
            Pair(RPC_PARAM_CLAZZ, clazz)
        )

        val data = if (args != null) {
            val map = params.toMutableMap()
            map[RPC_PARAM_DATA] = args
            map
        } else {
            params
        }
        val json = call(RPC_FUN_NEW, data) ?: return null
        return try {
            Gson().fromJson(json, Long::class.java)
        } catch (e: Exception) {
            null
        }
    }

    suspend fun releaseInstance(instanceId: Long): Boolean? {
        val params = mapOf<String, Any>(
            Pair(RPC_PARAM_INSTANCE, instanceId)
        )
        call(RPC_FUN_RELEASE, params)
        return true
    }

    suspend fun invoke(instanceId: Long, method: String, args: Any? = null): String? {
        val params = mapOf<String, Any>(
            Pair(RPC_PARAM_INSTANCE, instanceId),
            Pair(RPC_PARAM_METHOD, method)
        )
        val data = if (args != null) {
            val map = params.toMutableMap()
            map[RPC_PARAM_DATA] = args
            map
        } else {
            params
        }
        return call(RPC_FUN_INVOKE, data)
    }

    suspend fun invoke(clazz: String, method: String, args: Any? = null): String? {
        val params = mapOf<String, Any>(
            Pair(RPC_PARAM_CLAZZ, clazz),
            Pair(RPC_PARAM_METHOD, method),
        )
        val data = if (args != null) {
            val map = params.toMutableMap()
            map[RPC_PARAM_DATA] = args
            map
        } else {
            params
        }
        return call(RPC_FUN_INVOKE, data)
    }

    private suspend fun call(
        method: String,
        request: Map<String, Any>,
    ): String? {
        val ch: Channel<String?> = Channel()
        val task = CallTask(method, request, ch)
        safetySingleThreadScope.launch {
            enqueue(task)
        }
        return ch.receive()
    }

    inner class CallTask(
        private val method: String,
        private val request: Map<String, Any>,
        private val ch: Channel<String?>
    ) {
        fun execute() {
            MainScope().launch {
                val result = RpcChannelResult(ch, method, request)
                channel?.invokeMethod(method, request, result)
            }
        }
    }

    private fun enqueue(task: CallTask) {
        if (methodChannelReady.get()) {
            return task.execute()
        }
        blockingCallTasks.addFirst(task)
    }

    private fun onChannelReady() {
        methodChannelReady.set(true)
        if (blockingCallTasks.isEmpty()) {
            return
        }
        val it = blockingCallTasks.iterator()
        while (it.hasNext()) {
            val task = it.next()
            task.execute()
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            RPC_ON_CHANNEL_READY -> {
                safetySingleThreadScope.launch {
                    onChannelReady()
                }
                return
            }
            RPC_RCV_CALLBACK -> {
                //暂时不需要异步callback, 参考RpcChannelResult返回
            }
            RPC_FUN_INVOKE -> {
                val failed = { reason: String ->
                    result.success(reason)
                }
                val notImplement = {
                    result.notImplemented()
                }
                val arguments = call.arguments ?: return failed("rpc invoked without args")
                if (arguments !is Map<*, *>) {
                    return failed("rpc invoked with non-map args")
                }
                val clazz = arguments[RPC_PARAM_CLAZZ] as? String
                    ?: return failed("rpc invoked without specified class")
                val method = arguments[RPC_PARAM_METHOD] as? String
                    ?: return failed("rpc invoked without specified method")
                val data = arguments[RPC_PARAM_DATA]
                val function = CLASS_MAPPING[clazz] ?: return notImplement()
                return result.success(function(method, data))
            }
        }
        result.notImplemented()
    }

    companion object {
        const val RPC_CHANNEL_ID = "com.zpassapp.channels.RpcManager"

        const val RPC_FUN_INVOKE = "invoke"
        const val RPC_FUN_NEW = "new_instance"
        const val RPC_FUN_RELEASE = "release_instance"

        const val RPC_PARAM_INSTANCE = "instance"
        const val RPC_PARAM_CLAZZ = "clazz"
        const val RPC_PARAM_METHOD = "method"
        const val RPC_PARAM_DATA = "data"

        const val RPC_ON_CHANNEL_READY = "onChannelReady"
        const val RPC_RCV_CALLBACK = "onInvoked"


        val instance: RpcManager by lazy(LazyThreadSafetyMode.SYNCHRONIZED) {
            RpcManager()
        }

        fun init(engine: FlutterEngine) {
            instance.init(engine)
        }

        val CLASS_MAPPING = mapOf<String, (String, Any?) -> Any?>(
            SystemNavigatorProxy.CLASS to { method, data ->
                SystemNavigatorProxy.onMethodCall(
                    method,
                    data
                )
            },
        )
    }
}