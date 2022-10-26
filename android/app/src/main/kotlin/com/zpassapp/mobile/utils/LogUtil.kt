package com.zpassapp.mobile.utils

import android.util.Log

class LogUtil {
    companion object {
        private var TAG = "[ZPass]"
        private var isDebug = true

        fun setDebugLog(debug: Boolean)
        {
            isDebug = debug;
        }

        fun d(tag: String, msg: String)
        {
            if (isDebug) {
                Log.d(TAG, "[$tag] $msg")
            }
        }

        fun v(tag: String, msg: String)
        {
            if (isDebug) {
                Log.v(TAG, "[$tag] $msg")
            }
        }

        fun w(tag: String, msg: String)
        {
            Log.w(TAG, "[$tag] $msg")
        }

        fun e(tag: String, msg: String)
        {
            Log.e(TAG, "[$tag] $msg")
        }
    }
}