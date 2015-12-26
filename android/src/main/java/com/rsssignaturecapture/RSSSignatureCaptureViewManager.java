package com.rsssignaturecapture;

import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.SimpleViewManager;

public class RSSSignatureCaptureViewManager extends SimpleViewManager<RSSSignatureCaptureView> {
	@Override
	public String getName() {
		return "RSSSignatureView";
	}

	@Override
	public RSSSignatureCaptureView createViewInstance(ThemedReactContext context) {
		return new RSSSignatureCaptureView(context);
	}
}