package com.rssignaturecapture;

import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.SimpleViewManager;

public class RSSignatureCaptureViewManager extends SimpleViewManager<RSSignatureCaptureView> {
	@Override
	public String getName() {
		return "RSSignatureView";
	}

	@Override
	public RSSignatureCaptureView createViewInstance(ThemedReactContext context) {
		return new RSSignatureCaptureView(context);
	}
}