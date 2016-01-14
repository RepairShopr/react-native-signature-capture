package com.rssignaturecapture;

import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.SimpleViewManager;

import android.app.Activity;

public class RSSignatureCaptureViewManager extends SimpleViewManager<RSSignatureCaptureMainView> {
	private Activity mCurrentActivity;

	public RSSignatureCaptureViewManager(Activity activity) {
		mCurrentActivity = activity;
	}

	@Override
	public String getName() {
		return "RSSignatureView";
	}

	@Override
	public RSSignatureCaptureMainView createViewInstance(ThemedReactContext context) {
		return new RSSignatureCaptureMainView(context, mCurrentActivity);
	}
}
