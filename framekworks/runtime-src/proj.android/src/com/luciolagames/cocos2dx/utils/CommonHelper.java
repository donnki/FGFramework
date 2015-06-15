package com.luciolagames.cocos2dx.utils;

import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxActivity;

import android.content.Context;
import android.telephony.TelephonyManager;
import android.util.Log;

public class CommonHelper {
	private static final String TAG = "GAME";
	private static CommonHelper sInstance;
	
	private Cocos2dxActivity context;
	
	public CommonHelper(Cocos2dxActivity activity) {
		this.context = activity;
		sInstance = this;
	}
	

	/**
	 * 取本机唯一标识UDID 返回String
	 * */
	public static String getUDID(int i) {
		final TelephonyManager tm = (TelephonyManager) sInstance.context.getBaseContext()
				.getSystemService(Context.TELEPHONY_SERVICE);
		final String tmDevice, tmSerial, tmPhone, androidId;
		tmDevice = "" + tm.getDeviceId();
		tmSerial = "" + tm.getSimSerialNumber();
		androidId = ""
				+ android.provider.Settings.Secure.getString(
						sInstance.context.getContentResolver(),
						android.provider.Settings.Secure.ANDROID_ID);
		UUID deviceUuid = new UUID(androidId.hashCode(),
				((long) tmDevice.hashCode() << 32) | tmSerial.hashCode());
		String uniqueId = deviceUuid.toString();
		Log.d(TAG, "uuid=" + uniqueId);
		return uniqueId;
	}
	
	
}
