package com.rssignaturecapture;

import android.app.Activity;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

public class RSSignatureCaptureContextModule extends ReactContextBaseJavaModule {

    public RSSignatureCaptureContextModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "RSSignatureContextModule";
    }

    public Activity getActivity() {
        return this.getCurrentActivity();
    }
}
