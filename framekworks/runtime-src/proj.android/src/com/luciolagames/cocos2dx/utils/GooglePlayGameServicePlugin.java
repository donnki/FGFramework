package com.luciolagames.cocos2dx.utils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.json.JSONArray;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.util.SparseArray;
import android.widget.Toast;

import com.banabala.RunPuppyRun.google.R;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.games.Games;
import com.google.android.gms.games.GamesStatusCodes;
import com.google.android.gms.games.Player;
import com.google.android.gms.games.leaderboard.LeaderboardScore;
import com.google.android.gms.games.leaderboard.LeaderboardScoreBuffer;
import com.google.android.gms.games.leaderboard.LeaderboardVariant;
import com.google.android.gms.games.leaderboard.Leaderboards;
import com.google.android.gms.games.leaderboard.Leaderboards.LoadScoresResult;
import com.google.android.gms.plus.Plus;
import com.google.example.games.basegameutils.BaseGameUtils;

public class GooglePlayGameServicePlugin implements
		GoogleApiClient.ConnectionCallbacks,
		GoogleApiClient.OnConnectionFailedListener {
	private static final String TAG = "GAME";

	private GoogleApiClient mGoogleApiClient;
	private boolean mResolvingConnectionFailure = false;
	private boolean mSignInClicked = false;
	private boolean mAutoStartSignInFlow = true;
	private static final int RC_RESOLVE = 5000;
	private static final int RC_UNUSED = 5001;
	private static final int RC_SIGN_IN = 9001;

	private static final int PAGE_MAX = 10;
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

	public void onStart() {
		if (mGoogleApiClient != null) {
			Log.d(TAG, "onStart(): connecting");
			mGoogleApiClient.connect();
		}
	}

	public void onStop() {
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
				BaseGameUtils.showActivityResultError(context, requestCode,
						resultCode, R.string.signin_other_error);
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
		// TODO: say hello
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
		// TODO: Sign-in failed, so show sign-in button on main menu
		if (mSignInClicked || mAutoStartSignInFlow) {
			mAutoStartSignInFlow = false;
			mSignInClicked = false;
			mResolvingConnectionFailure = true;
			if (!BaseGameUtils.resolveConnectionFailure(context,
					mGoogleApiClient, connectionResult, RC_SIGN_IN,
					context.getString(R.string.signin_other_error))) {
				mResolvingConnectionFailure = false;
			}
		}
	}

	public void onShowAchievementsRequested() {
		if (isSignedIn()) {
			context.startActivityForResult(
					Games.Achievements.getAchievementsIntent(mGoogleApiClient),
					RC_UNUSED);
			
		} else {
			BaseGameUtils.makeSimpleDialog(context,
					context.getString(R.string.achievements_not_available))
					.show();
		}
	}

	public void onLoadLeaderboardData(String id, int span,
			int leaderboardCollection, final int callback) {
		if (isSignedIn()) {
			PendingResult<Leaderboards.LoadScoresResult> result = Games.Leaderboards
					.loadPlayerCenteredScores(mGoogleApiClient, id, span,
							leaderboardCollection, PAGE_MAX);
			result.setResultCallback(new ResultCallback<LoadScoresResult>() {
				@Override
				public void onResult(LoadScoresResult result) {

					if (result.getStatus().getStatusCode() == GamesStatusCodes.STATUS_OK) {
						String leaderboardId = result.getLeaderboard()
								.getLeaderboardId();
						String leaderboardName = result.getLeaderboard()
								.getDisplayName();
						LeaderboardScoreBuffer scores = result.getScores();
						
						List<Map<String, String>> lscores = new ArrayList<Map<String, String>>();
						int size = scores.getCount();
						for (int i = 0; i < size; i++) {
							LeaderboardScore l = scores.get(i);
							Map<String, String> map = new HashMap<String, String>();
							map.put("rank", l.getDisplayRank());
							map.put("formatScore", l.getDisplayScore());
							map.put("score", l.getRawScore() + "");
							map.put("name", l.getScoreHolderDisplayName());
							map.put("playerId", l.getScoreHolder()
									.getPlayerId());
							lscores.add(map);
						}
						JSONArray obj = new JSONArray(lscores);
						final String response = obj.toString();
						Log.d(TAG, "response: " + response);
						context.runOnGLThread(new Runnable() {
				            @Override
				            public void run() {
				            	Cocos2dxLuaJavaBridge.callLuaFunctionWithString(callback, response);
				            	Cocos2dxLuaJavaBridge.releaseLuaFunction(callback);
				            }
				          });
						
						scores.close();
					}

				}
			});
		} else {
			BaseGameUtils.makeSimpleDialog(context,
					context.getString(R.string.achievements_not_available))
					.show();
		}
	}

	public void onShowLeaderboardsRequested() {
		if (isSignedIn()) {
			context.startActivityForResult(Games.Leaderboards
					.getAllLeaderboardsIntent(mGoogleApiClient), RC_UNUSED);
		} else {
			BaseGameUtils.makeSimpleDialog(context,
					context.getString(R.string.leaderboards_not_available))
					.show();
		}
	}

	public void onShowLeaderboardRequested(String leaderboardID, int timeSpan) {
		if (isSignedIn()) {

			context.startActivityForResult(Games.Leaderboards
					.getLeaderboardIntent(mGoogleApiClient, leaderboardID,
							timeSpan), RC_UNUSED);
		} else {
			BaseGameUtils.makeSimpleDialog(context,
					context.getString(R.string.leaderboards_not_available))
					.show();
		}
	}

	public void onLeaderboardSubmitScore(String leaderboardID, long score) {
		if (isSignedIn()) {
			Log.d(TAG, "onLeaderboardSubmitScore: " + score);
			Games.Leaderboards.submitScoreImmediate(mGoogleApiClient,
					leaderboardID, score);
		} else {
			BaseGameUtils.makeSimpleDialog(context,
					context.getString(R.string.leaderboards_not_available))
					.show();
		}
	}

	public void unlockAchievementRequest(String achievementId,
			String fallbackString) {
		if (isSignedIn()) {
			Games.Achievements.unlock(mGoogleApiClient, achievementId);
		} else {
			Toast.makeText(
					context,
					context.getString(R.string.achievement) + ": "
							+ fallbackString, Toast.LENGTH_LONG).show();
		}
	}

	// 以下是对LUA的静态接口
	/**
	 * 显示排行榜列表
	 * */
	public static void showLeaderboards() {
		Log.d(TAG, "showLeaderboards");
		sInstance.onShowLeaderboardsRequested();
	}

	/**
	 * 显示成就列表
	 * */
	public static void showAchievements() {
		Log.d(TAG, "showAchievements");
		sInstance.onShowAchievementsRequested();
	}

	/**
	 * 解锁成就
	 * */
	public static void unlockAchievement(String achievementID) {
		Log.d(TAG, "unlockAchievement: " + achievementID);
		sInstance.unlockAchievementRequest(achievementID, "");
	}

	/**
	 * 显示指定排行榜ID的总排行榜
	 * */
	public static void showLeaderboardByID(String id, int span) {
		Log.d(TAG, "showLeaderboards");
		int timeSpan = LeaderboardVariant.TIME_SPAN_ALL_TIME;
		if (span == 1) {
			timeSpan = LeaderboardVariant.TIME_SPAN_DAILY;
		} else if (span == 2) {
			timeSpan = LeaderboardVariant.TIME_SPAN_WEEKLY;
		}
		sInstance.onShowLeaderboardRequested(id, timeSpan);
	}

	/**
	 * 提交指定排行榜分数
	 * */
	public static void submitLeaderboardScore(String id, int score) {
		Log.d(TAG, "submitLeaderboardScore," + id + ", " + score);
		sInstance.onLeaderboardSubmitScore(id, score);
	}
	
	/**
	 * 获取指定排行榜分数
	 * 在callback中返回json排行榜数据
	 * */
	public static void loadLeaderboardScore(String id, int callback){
		int span = LeaderboardVariant.TIME_SPAN_ALL_TIME;
		int leaderboardCollection = LeaderboardVariant.COLLECTION_PUBLIC;
		sInstance.onLoadLeaderboardData(id, span, leaderboardCollection, callback);
	}
}
