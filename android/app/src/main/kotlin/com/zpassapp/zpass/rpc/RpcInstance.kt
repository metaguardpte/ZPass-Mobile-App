package com.zpassapp.zpass.rpc

import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock

abstract class RpcInstance {
    private var instanceId: Long? = null
    private val mutex: Mutex by lazy {
        Mutex()
    }

    suspend fun create(clazz: String, initData: Any? = null) {
        mutex.withLock {
            instanceId = RpcManager.instance.createInstance(clazz, initData)
        }
    }

    suspend fun release() {
        mutex.withLock {
            val id = instanceId ?: return
            instanceId = null
            RpcManager.instance.releaseInstance(id)
        }
    }

    suspend fun invoke(method: String, args: Any? = null): String? {
        val id = mutex.withLock {
            instanceId
        } ?: return null
        return RpcManager.instance.invoke(id, method, args)
    }

    @DelicateCoroutinesApi
    fun finalize() {
        GlobalScope.launch {
            release()
        }
    }
}