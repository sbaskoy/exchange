package com.example.kurtakip;

import android.annotation.SuppressLint;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;

import java.util.ArrayList;
import java.util.Random;
import java.util.Timer;
import java.util.TimerTask;

public class ForegroundService extends Service {
    public static final String START = "START";
    public static final String STOP = "STOP";
    public static final String CHANNEL_ID = "ForegroundServiceChannel";
    private  Timer _timer;
    private Currency lastUSD;
    private Currency lastEURO;
    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
    @Override
    public void onCreate() {
        super.onCreate();
    }

        void startService(){
            Log.e("INFO","start foreground service");
        createNotificationChannel();
            createNotification();

            if(_timer == null){
                TimerTask timerTask=new TimerTask() {
                    @RequiresApi(api = Build.VERSION_CODES.O)
                    @Override
                    public void run() {
                        Log.e("INFO","running timer");
                        ArrayList<Currency> currencies= ExchangeService.getExchange();

                        if(currencies!=null){
                            Currency currentUSD=null;
                            Currency currentEURO = null;
                            for(Currency _cur : currencies) {
                                if(_cur.kod.equals("USD")) {
                                    currentUSD=_cur;
                                }
                                if(_cur.kod.equals("EUR")){
                                    currentEURO=_cur;
                                }
                            }
                            if(lastUSD==null && lastEURO == null){
                                lastEURO=currentEURO;
                                lastUSD=currentUSD;
                            }else{
                                if(!lastUSD.buy.equals( currentUSD.buy)){
                                    createInfoNotification("USD changed","Old val: "+lastUSD.buy+" new val: "+currentUSD.buy);
                                    lastUSD=currentUSD;
                                }
                                if(!lastEURO.buy.equals(currentEURO.buy)){
                                    createInfoNotification("EURO changed","Old val: "+lastEURO.buy+" new val: "+currentEURO.buy );
                                    lastEURO=currentEURO;
                                }
                            }
                        }else{
                            Log.e("INFO","currency is null");
                        }
                    }
                };
                _timer = new Timer("HttpTimer");
                _timer.scheduleAtFixedRate(timerTask,0,5000);
            }



        }


        @RequiresApi(api = Build.VERSION_CODES.O)
        void createInfoNotification(String title, String body){
            Random rand = new Random();
            int upperbound = 100000;

            int int_random = rand.nextInt(upperbound);

            Notification notification = new NotificationCompat.Builder(this, String.valueOf(int_random))
                    .setContentTitle(title)
                    .setContentText(body)
                    .setSmallIcon(R.mipmap.ic_launcher)
                    .setAutoCancel(true).build();

            NotificationChannel serviceChannel = new NotificationChannel(
                    String.valueOf(int_random),
                    "Exchange",
                    NotificationManager.IMPORTANCE_HIGH
            );
            NotificationManager mNotificationManager =
                    (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
            mNotificationManager.createNotificationChannel(serviceChannel);
            mNotificationManager.notify(0, notification);
        }

        void stopService(){
            if(_timer != null){
                _timer.cancel();
            }
            stopForeground(true);
            stopSelf();
        }

    void createNotification() {
        Intent closeIntent = new Intent(this, ForegroundService.class);
        closeIntent.setAction(ForegroundService.STOP);
        PendingIntent pendingCloseIntent = PendingIntent.getService(this, 0, closeIntent, 0);
        Notification notification = new NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("Working background process.")
                .setContentText("Exchange info is updating in background.")
                .setSmallIcon(R.mipmap.ic_launcher)

                .addAction(android.R.drawable.ic_delete,"Kapat",pendingCloseIntent)
                .build();
        startForeground(1,notification);
    }
    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel serviceChannel = new NotificationChannel(
                    CHANNEL_ID,
                    " Exchange",
                    NotificationManager.IMPORTANCE_LOW
            );
            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(serviceChannel);
        }
    }


    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent != null){
            String action=intent.getAction();
            switch (action){
                case  START:
                    startService();
                    break;
                case STOP:
                    stopService();
                    break;
            }
        }
        return super.onStartCommand(intent, flags, startId);
    }
}
