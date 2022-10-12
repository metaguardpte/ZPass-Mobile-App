package com.zpassapp.zpass.rpc

interface RpcProxy {
    fun onMethodCall(method: String, data: Any?): Any?
}