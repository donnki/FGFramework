package org.cocos2dx.lua;

import org.cocos2dx.lib.Cocos2dxActivity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import com.banabala.RunPuppyRun.google.R;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.games.Games;
import com.google.android.gms.games.Player;
import com.google.android.gms.plus.Plus;
import com.google.example.games.basegameutils.BaseGameUtils;

public class GooglePlayGameServicePlugin implements
	GoogleApiClient.ConnectionCallbacks,
	GoogleApiClient.OnConnectionFailedListener{
	private static final String TAG = "GAME";
	
	private GoogleApiClient mGoogleApiClient;
	private boolean mResolvingConnectionFailure = false;
	private boolean mSignInClicked = false;
	private boolean mAutoStartSignInFlow = true;
    private static final int RC_RESOLVE = 5000;
    private static final int RC_UNUSED = 5001;
    private static final int RC_SIGN_IN = 9001;
    private Cocos2dxActivity context;
    
    private static GooglePlayGameServicePlugin sInstance;
    
    public GooglePlayGameServicePlugin(Cocos2dxActivity activity) {
		this.context = activity;
		sInstance = this;
		initGameService();
	}

	private void initGameService() {
		mGoogleApiClient = new GoogleApiClient.Builder(context)
				.addConnectionCallbacks(this)
				.addOnConnectionFailedListener(this).addApi(Plus.API)
				.addScope(Plus.SCOPE_PLUS_LOGIN).addApi(Games.API)
				.addScope(Games.SCOPE_GAMES).build();
	}
	
	public void onStart(){
        if(mGoogleApiClient != null){
        	Log.d(TAG, "onStart(): connecting");
        	mGoogleApiClient.connect();
        }
	}
	
	public void onStop(){
		if (mGoogleApiClient != null && mGoogleApiClient.isConnected()) {
        	Log.d(TAG, "onStop(): disconnecting");
            mGoogleApiClient.disconnect();
        }
	}
	
	public void onActivityResult(int requestCode, int resultCode, Intent intent) {
		if (requestCode == RC_SIGN_IN) {
            mResolvingConnectionFailure = false;
            if (resultCode == Activity.RESULT_OK) {
                mGoogleApiClient.connect();
            } else {
                BaseGameUtils.showActivityResultError(context, requestCode, resultCode, R.string.signin_other_error);
            }
        }
	}
	private boolean isSignedIn() {
        return (mGoogleApiClient != null && mGoogleApiClient.isConnected());
    }

    @Override
    public void onConnected(Bundle bundle) {
        Log.d(TAG, "onConnected(): connected to Google APIs");
        
        Player p = Games.Players.getCurrentPlayer(mGoogleApiClient);
        String displayName;
        if (p == null) {
            Log.w(TAG, "mGamesClient.getCurrentPlayer() is NULL!");
            displayName = "???";
        } else {
            displayName = p.getDisplayName();
        }
        //TODO: say hello
        Log.d(TAG, "Hello, " + displayName);
    }

    @Override
    public void onConnectionSuspended(int i) {
        Log.d(TAG, "onConnectionSuspended(): attempting to connect");
        mGoogleApiClient.connect();
    }

    @Override
    public void onConnectionFailed(ConnectionResult connectionResult) {
        Log.d(TAG, "onConnectionFailed(): attempting to resolve");
        if (mResolvingConnectionFailure) {
            Log.d(TAG, "onConnectionFailed(): already resolving");
            return;
        }
        //TODO: Sign-in failed, so show sign-in button on main menu
        if (mSignInClicked || mAutoStartSignInFlow) {
            mAutoStartSignInFlow = false;
            mSignInClicked = false;
            mResolvingConnectionFailure = true;
            if (!BaseGameUtils.resolveConnectionFailure(context, mGoogleApiClient, connectionResult,
                    RC_SIGN_IN, context.getString(R.string.signin_other_error))) {
                mResolvingConnectionFailure = false;
            }
        }
    }
    
    public void onShowAchievementsRequested() {
        if (isSignedIn()) {
        	context.startActivityForResult(Games.Achievements.getAchievementsIntent(mGoogleApiClient),
                    RC_UNUSED);
        } else {
            BaseGameUtils.makeSimpleDialog(context, context.getString(R.string.achievements_not_available)).show();
        }
    }
    
    public void onShowLeaderboardsRequested() {
        if (isSignedIn()) {
        	context.startActivityForResult(Games.Leaderboards.getAllLeaderboardsIntent(mGoogleApiClient),
                    RC_UNUSED);
        } else {
            BaseGameUtils.makeSimpleDialog(context, context.getString(R.string.leaderboards_not_available)).show();
        }
    }
    
    void unlockAchievement(String achievementId, String fallbackString) {
        if (isSignedIn()) {
            Games.Achievements.unlock(mGoogleApiClient, achievementId);
        } else {
            Toast.makeText(context, context.getString(R.string.achievement) + ": " + fallbackString,
                    Toast.LENGTH_LONG).show();
        }
    }
}
