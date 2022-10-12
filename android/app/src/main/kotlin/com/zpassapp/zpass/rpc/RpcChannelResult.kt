package com.zpassapp.zpass.rpc

import com.zpassapp.zpass.BuildConfig
import com.zpassapp.zpass.utils.LogUtil
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.channels.Channel
import java.lang.Exception

class RpcChannelResult(
    private val channel: Channel<String?>,
    private val method: String,
    private val request: Map<String, Any>
) : MethodChannel.Result {

    private fun dumpInfo(): String {
        val kv = request.map { "${it.key} -> ${it.value}"  }.joinToString(";\n")
        return "\n-----------\n$method(kv)\nkv = $kv\n------------------\n"
    }

    override fun success(result: Any?) {
        result ?: return error(
            ERR_INVALID_RESPONSE.toString(),
            MSG_INVALID_RESPONSE,
            Exception().stackTrace.toString()
        )
        if (result is Map<*, *>) {
            val data = result[RpcManager.RPC_PARAM_DATA] ?: ""
            val json = if (data is String) { data } else { data.toString() }
            channel.trySend(json).isSuccess.let {
                LogUtil.d("RpcChannelResult", "method $method, success trySend: $it")
            }
        }  else {
            error(
                ERR_INVALID_RESPONSE.toString(),
                MSG_INVALID_RESPONSE,
                Exception().stackTrace.toString()
            )
        }
    }

    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
        if (BuildConfig.DEBUG) {
            Exception("${dumpInfo()} $errorMessage($errorCode) $errorDetails").printStackTrace()
        }
        channel.trySend(null).isSuccess.let {
            LogUtil.d("RpcChannelResult", "method $method, error trySend: $it")
        }
    }

    override fun notImplemented() {
        if (BuildConfig.DEBUG) {
            Exception("${dumpInfo()} $MSG_NOT_IMPLEMENTED(-1)").printStackTrace()
        }
        channel.trySend(null).isSuccess.let {
            LogUtil.d("RpcChannelResult", "method $method, notImplemented trySend: $it")
        }
    }

    companion object {
        const val ERR_INVALID_RESPONSE = -1000
        const val ERR_INVALID_DATA = -1001

        const val MSG_INVALID_RESPONSE = "result was null"
        const val MSG_INVALID_DATA = "data was null"
        const val MSG_NOT_IMPLEMENTED = "Calling Method Has Not Implemented In Dart Side"
    }
}