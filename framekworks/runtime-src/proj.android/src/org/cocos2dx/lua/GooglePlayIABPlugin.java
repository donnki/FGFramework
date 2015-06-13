package org.cocos2dx.lua;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import com.android.iab.util.IabHelper;
import com.android.iab.util.IabResult;
import com.android.iab.util.Inventory;
import com.android.iab.util.Purchase;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

public class GooglePlayIABPlugin {
	public static final String TAG = "GAME";
	public static int luaSuccessCallback = -1;
	public static int luaFailedCallback = -1;
	
	private static final int RC_REQUEST = 10001;
	private static GooglePlayIABPlugin sInstance;
	
	public IabHelper mHelper;
	private String base64EncodedPublicKey = "w0BAQEFAAOCAQ8AMIIBCgKCAQEAwj6mHuvvQELiuZHWJrLXGfiFo9eQu//DnsO91jaMg/oChJ9JnCo2aMjliti/EKTDxU42MHx3P4hJiu7Duei7U6m7ocyv+156iKFUCqr/SOc4ZdE2HGLkqw1m/bHVsHSAJM9sbD41aWwSSZAx4H4P8tKyV5lqSP3mWcfq+UMUqg1MRlM4OzyZcnZ2fjM+SHBPItyND8WrqFmUNMaHbklLt6imzJDXOg8w+JXFuVf25flOJNR7NzdH6iNL+LJzFkii0fOidCwyUwkyeEyboSJPMiKmdYMW/fSBHmcpxrdr1kfS3/9YX8HqzKd2r/II3rB87UssQnJ+8FueWEjDQh/PRQIDAQAB";
	
	
	private Cocos2dxActivity context;
	
	public GooglePlayIABPlugin(Cocos2dxActivity activity) {
		this.context = activity;
		sInstance = this;
		init();
	}


	private void init() {
		mHelper = new IabHelper(context, base64EncodedPublicKey);
		mHelper.enableDebugLogging(true);
		mHelper.startSetup(new IabHelper.OnIabSetupFinishedListener() {
			public void onIabSetupFinished(IabResult result) {
				Log.d(TAG, "Setup finished.");
				if (!result.isSuccess()) {
					complain("Problem setting up in-app billing: " + result);
					return;
				}

				if (mHelper == null)
					return;

				Log.d(TAG, "Setup successful. ");
				mHelper.queryInventoryAsync(mGotInventoryListener);
			}
		});
	}
	
	
	public void onDestroy(){
		Log.d(TAG, "Destroying helper.");
        if (mHelper != null) {
            mHelper.dispose();
            mHelper = null;
        }
	}


	public void onActivityResult(int requestCode, int resultCode, Intent intent) {
		if (!mHelper.handleActivityResult(requestCode, resultCode, intent)) {
            // not handled, so handle it ourselves (here's where you'd
            // perform any handling of activity results not related to in-app
            // billing...
        }
        else {
            Log.d(TAG, "onActivityResult handled by IABUtil. ");
        }
	}
	
	public void doPuchase(String SKU) {
		mHelper.launchPurchaseFlow(context, SKU, RC_REQUEST,
				mPurchaseFinishedListener, "");
	}
	


	boolean verifyDeveloperPayload(Purchase p) {
		String payload = p.getDeveloperPayload();

		return true;
	}


	IabHelper.QueryInventoryFinishedListener mGotInventoryListener = new IabHelper.QueryInventoryFinishedListener() {
		public void onQueryInventoryFinished(IabResult result,
				Inventory inventory) {
			Log.d(TAG, "Query inventory finished.");
			if (result.isFailure()) {
				complain("Failed to query inventory: " + result);
				return;
			}
			Log.d(TAG, "Query inventory was successful.");

			Purchase gasPurchase = inventory
					.getPurchase("android.test.purchased");
			if (gasPurchase != null && verifyDeveloperPayload(gasPurchase)) {
				Log.d(TAG, "We have gas. Consuming it.");
				mHelper.consumeAsync(
						inventory.getPurchase("android.test.purchased"),
						mConsumeFinishedListener);
				return;
			}
		}
	};
	
	IabHelper.OnIabPurchaseFinishedListener mPurchaseFinishedListener = new IabHelper.OnIabPurchaseFinishedListener() {
		public void onIabPurchaseFinished(IabResult result, Purchase purchase) {
			Log.d(TAG, "Purchase finished: " + result + ", purchase: "
					+ purchase);

			if (mHelper == null)
				return;
			if (result.isFailure()) {
				complain("Error purchasing: " + result);
				final String response = result.toString();
				context.runOnGLThread(new Runnable() {
		            @Override
		            public void run() {
		            	if(luaFailedCallback != -1){
							Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFailedCallback, response);
							clearLuaCallback();
						}
		            }
		          });
				
				return;
			}
			if (!verifyDeveloperPayload(purchase)) {
				complain("Error purchasing. Authenticity verification failed.");
				return;
			}

			Log.d(TAG, "Purchase successful.");
			mHelper.consumeAsync(purchase, mConsumeFinishedListener);
			
		}
	};

	IabHelper.OnConsumeFinishedListener mConsumeFinishedListener = new IabHelper.OnConsumeFinishedListener() {
		public void onConsumeFinished(Purchase purchase, IabResult result) {
			Log.d(TAG, "Consumption finished. Purchase: " + purchase
					+ ", result: " + result);

			if (mHelper == null)
				return;

			if (result.isSuccess()) {
				Log.d(TAG, " Consumption successful. Provisioning.");
			} else {
				complain("Error while consuming: " + result);
			}
			Log.d(TAG, "End consumption flow.");
		}
	};

	void complain(String message) {
		Log.e(TAG, "**** Error: " + message);
		//alert("Error: " + message);
	}

	void alert(String message) {
		AlertDialog.Builder bld = new AlertDialog.Builder(context);
		bld.setMessage(message);
		bld.setNeutralButton("OK", null);
		Log.d(TAG, "Showing alert dialog: " + message);
		bld.create().show();
	}
	
	private static void clearLuaCallback(){
		Cocos2dxLuaJavaBridge.releaseLuaFunction(luaFailedCallback);
		Cocos2dxLuaJavaBridge.releaseLuaFunction(luaSuccessCallback);
		luaFailedCallback = -1;
		luaSuccessCallback = -1;
	}
	
	/**
	 * 对Lua接口
	 * */
	public static void payForProduct(String productID, final int successCallback, final int failedCallback){
		luaSuccessCallback = successCallback;
		luaFailedCallback = failedCallback;
		sInstance.doPuchase(productID);
	}
}
