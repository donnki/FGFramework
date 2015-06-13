/****************************************************************************
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2011      Zynga Inc.
Copyright (c) 2013-2014 Chukong Technologies Inc.
 
http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 ****************************************************************************/
package org.cocos2dx.lua;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Enumeration;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxActivity;

import com.android.iab.util.IabHelper;
import com.android.iab.util.IabResult;
import com.android.iab.util.Inventory;
import com.android.iab.util.Purchase;
import com.banabala.RunPuppyRun.google.R;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.games.Games;
import com.google.android.gms.games.Player;
import com.google.android.gms.plus.Plus;
import com.google.example.games.basegameutils.BaseGameUtils;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.ActivityInfo;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.text.format.Formatter;
import android.util.Log;
import android.view.WindowManager;
import android.widget.Toast;

public class AppActivity extends Cocos2dxActivity  {
	private static String TAG = "GAME";
	private static AppActivity context;
	
	protected GooglePlayIABPlugin mIABPlugin = null;
	protected GooglePlayGameServicePlugin mGameServicePlugin = null;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		context = this;
		mIABPlugin = new GooglePlayIABPlugin(this);
		mGameServicePlugin = new GooglePlayGameServicePlugin(this);
		
	}

    @Override
    protected void onStart() {
        super.onStart();
        mGameServicePlugin.onStart();

    }

    @Override
    protected void onStop() {
        super.onStop();
        
        mGameServicePlugin.onStop();
    }
    
    @Override
    public void onDestroy() {
        super.onDestroy();
        mIABPlugin.onDestroy();
    }
    
    
	@Override
    protected void onActivityResult(int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);
        mGameServicePlugin.onActivityResult(requestCode, resultCode, intent);
        mIABPlugin.onActivityResult(requestCode, resultCode, intent);
    }

	

	/**
	 * 取本机唯一标识UDID 返回String
	 * */
	public static String getUDID(int i) {
		final TelephonyManager tm = (TelephonyManager) context.getBaseContext()
				.getSystemService(Context.TELEPHONY_SERVICE);
		final String tmDevice, tmSerial, tmPhone, androidId;
		tmDevice = "" + tm.getDeviceId();
		tmSerial = "" + tm.getSimSerialNumber();
		androidId = ""
				+ android.provider.Settings.Secure.getString(
						context.getContentResolver(),
						android.provider.Settings.Secure.ANDROID_ID);
		UUID deviceUuid = new UUID(androidId.hashCode(),
				((long) tmDevice.hashCode() << 32) | tmSerial.hashCode());
		String uniqueId = deviceUuid.toString();
		Log.d(TAG, "uuid=" + uniqueId);
		return uniqueId;
	}
	
	/**
	 * 显示排行榜列表
	 * */
	public static void showLeaderboards(){
		Log.d(TAG, "showLeaderboards");
		context.mGameServicePlugin.onShowLeaderboardsRequested();
	}
	
	/**
	 * 显示成就列表
	 * */
	public static void showAchievements(){
		Log.d(TAG, "showAchievements");
		context.mGameServicePlugin.onShowAchievementsRequested();
	}
	
	/**
	 * 解锁成就
	 * */
	public static void unlockAchievement(String achievementID){
		Log.d("TAG", "unlockAchievement" + achievementID);
		context.mGameServicePlugin.unlockAchievement(achievementID, "");
		
	}
	
	/**
	 * 游戏内购买指定物品
	 * android.test.purchased
	 * android.test.canceled
	 * android.test.refunded
	 * android.test.item_unavailable
	 * */
	public static void payForProduct(String productID){
		Log.d(TAG, "payForProduct: " + productID);
		context.mIABPlugin.doPuchase(productID);
	}
}
