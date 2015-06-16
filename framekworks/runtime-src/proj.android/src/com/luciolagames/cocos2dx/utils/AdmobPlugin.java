package com.luciolagames.cocos2dx.utils;

import org.cocos2dx.lib.Cocos2dxActivity;

import android.util.Log;

import com.banabala.RunPuppyRun.google.R;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.InterstitialAd;

public class AdmobPlugin {
	public static final String TAG = "GAME";
	protected static AdmobPlugin sInstance;
	
	
	protected Cocos2dxActivity context;
	protected InterstitialAd mInterstitialAd;
	
	
	public AdmobPlugin(Cocos2dxActivity activity) {
		this.context = activity;
		sInstance = this;
		init();
	}
	
	private void init(){
		mInterstitialAd = new InterstitialAd(context);
        mInterstitialAd.setAdUnitId(context.getString(R.string.admob_interstitial));
        mInterstitialAd.setAdListener(new AdListener(){
        	@Override 
        	public void onAdClosed(){
        		Log.d(TAG, "on InterstitialAd Closed");
        		requestNewInterstitial();
        	}
        	
        	@Override
        	public void onAdOpened(){
        		Log.d(TAG, "on InterstitialAd opened");
        	}
        	
        	@Override
        	public void onAdLoaded(){
        		Log.d(TAG, "on InterstitialAd Loaded");
        	}
        	
        	@Override
        	public void onAdFailedToLoad(int result){
        		Log.d(TAG, "on InterstitialAd FailedToLoad");
        	}
        });
        requestNewInterstitial();
	}
	
	private void requestNewInterstitial() {
        AdRequest adRequest = new AdRequest.Builder().build();
        mInterstitialAd.loadAd(adRequest);
    }
	
	protected void onShowInterstiticalAD(){
		context.runOnUiThread(new Runnable(){
			@Override
			public void run() {
				Log.d(TAG, "Show InterstitialAD, isLoaded: " + mInterstitialAd.isLoaded());
				if (mInterstitialAd.isLoaded()) {
		            mInterstitialAd.show();
		        } else {
		        	Log.d(TAG, "InterstiticalAD not loaded yet");
		        }
			}
		});
		
	}
	
	public static void showInterstitialAD(){
		sInstance.onShowInterstiticalAD();
		Log.d(TAG, "Show InterstitialAD, end");
	}
}
