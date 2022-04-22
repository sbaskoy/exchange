package com.example.kurtakip;

import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private  static final String CHANNEL="com.sbaskoy.exchange/exchange";

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {


        super.onCreate(savedInstanceState);

        BinaryMessenger messenger=getFlutterEngine().getDartExecutor().getBinaryMessenger();
        new MethodChannel(messenger,CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                if(call.method.equals("startService")){
                    startAction(ForegroundService.START);
                }
                if(call.method.equals("stopService")){
                    startAction(ForegroundService.START);
                }
            }
        });
    }
    private  void startAction(String action){
        Log.e("INFO","star foreground service");
        Intent intent = new Intent(this, ForegroundService.class);
        intent.setAction(action);
        startService(intent);
    }
}
