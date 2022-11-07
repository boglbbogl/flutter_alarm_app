package com.example.flutter_alarm_app
import io.flutter.embedding.engine.FlutterEngine
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterFragmentActivity(){
     private val eventChannel = "samples.flutter.dev/counter"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannel).setStreamHandler(
            CounterHandler
        )
    }
}

object CounterHandler : EventChannel.StreamHandler {
    private val handler = Handler(Looper.getMainLooper())
    private var eventSink: EventChannel.EventSink? = null
    private var counter: Int = 0

    private val runnable: Runnable = object : Runnable {
        override fun run() {
            countUp()
        }
    }

    fun countUp() {
        eventSink?.success(counter++)
        handler.postDelayed(runnable, 1000)
    }

    override fun onListen(arguments: Any?, sink: EventChannel.EventSink) {
        eventSink = sink
        handler.post(runnable)
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        handler.removeCallbacks(runnable)
    }
}