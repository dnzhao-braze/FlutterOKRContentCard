package com.example.flutter2

import com.braze.Braze
import com.braze.support.BrazeLogger
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        //BrazeLogger.setLogLevel(Log.VERBOSE)
    }
}
