package com.zpassapp.mobile.rpc

interface RpcProxy {
    fun onMethodCall(method: String, data: Any?): Any?
}