package com.zpassapp.zpass.rpc

import android.app.Activity
import com.zpassapp.zpass.utils.LogUtil
import java.lang.ref.WeakReference

object SystemNavigatorProxy: RpcProxy {
    const val CLASS = "SystemNavigatorProxy"
    private const val METHOD_POP = "SystemNavigator.pop"
    private const val METHOD_EXIT = "SystemNavigator.exit"

    private var topActivityRef: WeakReference<Activity>? = null

    private fun pop(): Boolean {
        val activity = synchronized(this) {
            topActivityRef?.get()
        } ?: return false
        activity.onBackPressed()
        return true
    }

    private fun exit(): Boolean {
        android.os.Process.killProcess(android.os.Process.myPid())
        return true
    }

    fun attachActivity(activity: Activity) {
        synchronized(this) {
            topActivityRef = WeakReference(activity)
        }
    }

    override fun onMethodCall(method: String, data: Any?): Any? {
        LogUtil.d("SystemNavigatorProxy", "onMethodCall: $method")
        when(method) {
            METHOD_POP -> { return pop() }
            METHOD_EXIT -> { return exit() }
        }
        return null
    }
}