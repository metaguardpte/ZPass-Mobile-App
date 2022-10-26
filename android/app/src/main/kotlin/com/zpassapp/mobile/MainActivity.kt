package com.zpassapp.mobile

import android.os.Bundle
import com.zpassapp.mobile.rpc.RpcManager
import com.zpassapp.mobile.rpc.SystemNavigatorProxy
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        SystemNavigatorProxy.attachActivity(this)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        RpcManager.init(flutterEngine)
    }
}
