package com.rssignaturecapture;

import android.Manifest;
import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.os.Environment;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.RCTEventEmitter;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Date;

public class RSSignatureCaptureMainView extends LinearLayout implements OnClickListener, RSSignatureCaptureView.SignatureCallback {
  private LinearLayout buttonsLayout;
  private RSSignatureCaptureView signatureView;

  private Activity mActivity;
  private int mOriginalOrientation;
  private Boolean saveFileInExtStorage = false;
  private String viewMode = "portrait";
  private Boolean showNativeButtons = true;
  private int maxSize = 500;
  private ReactContext mReactContext;

  public RSSignatureCaptureMainView(ReactContext context, Activity activity) {
    super(context);
    Log.d("React:", "RSSignatureCaptureMainView(Contructtor)");
    mOriginalOrientation = activity.getRequestedOrientation();
    mActivity = activity;
    mReactContext = context;
    setOrientation(LinearLayout.VERTICAL);
    signatureView = new RSSignatureCaptureView(context, this);
    buttonsLayout = this.buttonsLayout();
    addView(this.buttonsLayout);
    addView(signatureView);

    setLayoutParams(new android.view.ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
        ViewGroup.LayoutParams.MATCH_PARENT));
  }

  public void setSaveFileInExtStorage(Boolean saveFileInExtStorage) {
    this.saveFileInExtStorage = saveFileInExtStorage;
  }

  public void setViewMode(String viewMode) {
    this.viewMode = viewMode;

    if (viewMode.equalsIgnoreCase("portrait")) {
      mActivity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
    } else if (viewMode.equalsIgnoreCase("landscape")) {
      mActivity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
    }
  }

  public void setShowNativeButtons(Boolean showNativeButtons) {
    this.showNativeButtons = showNativeButtons;
    if (showNativeButtons) {
      Log.d("Added Native Buttons", "Native Buttons:" + showNativeButtons);
      buttonsLayout.setVisibility(View.VISIBLE);
    } else {
      buttonsLayout.setVisibility(View.GONE);
    }
  }

  public void setMaxSize(int size) {
    this.maxSize = size;
  }


  private LinearLayout buttonsLayout() {

    // create the UI programatically
    LinearLayout linearLayout = new LinearLayout(this.getContext());
    Button saveBtn = new Button(this.getContext());
    Button clearBtn = new Button(this.getContext());

    // set orientation
    linearLayout.setOrientation(LinearLayout.HORIZONTAL);
    linearLayout.setBackgroundColor(Color.WHITE);

    // set texts, tags and OnClickListener
    saveBtn.setText("Save");
    saveBtn.setTag("Save");
    saveBtn.setOnClickListener(this);

    clearBtn.setText("Reset");
    clearBtn.setTag("Reset");
    clearBtn.setOnClickListener(this);

    linearLayout.addView(saveBtn);
    linearLayout.addView(clearBtn);

    // return the whoe layout
    return linearLayout;
  }

  // the on click listener of 'save' and 'clear' buttons
  @Override
  public void onClick(View v) {
    String tag = v.getTag().toString().trim();

    // save the signature
    if (tag.equalsIgnoreCase("save")) {
      this.saveImage();
    }

    // empty the canvas
    else if (tag.equalsIgnoreCase("Reset")) {
      this.signatureView.clearSignature();
    }
  }

  private boolean permissionsCheck() {
    int writePermission = ContextCompat.checkSelfPermission(mReactContext, Manifest.permission.WRITE_EXTERNAL_STORAGE);
    if (writePermission != PackageManager.PERMISSION_GRANTED) {
      String[] PERMISSIONS = {
          Manifest.permission.WRITE_EXTERNAL_STORAGE,
      };
      String[] permissions = {Manifest.permission.WRITE_EXTERNAL_STORAGE};
      ActivityCompat.requestPermissions(mActivity, permissions, 1);
      return false;

    }
    return true;
  }

  private File createNewFile() {
    Format formatter = new SimpleDateFormat("yyyy-MM-dd-HH:mm:ss");
    String s = formatter.format(new Date());
    String filename = "image-" + s + ".png";
    File path;
    path = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
    File f = new File(path, filename);
    try {
      path.mkdirs();
      f.createNewFile();
    } catch (IOException e) {
      e.printStackTrace();
    }

    return f;
  }

  /**
   * save the signature to an sd card directory
   */
  final void saveImage() {
    if (permissionsCheck()) {
      File outputFile = createNewFile();
      OutputStream fout;
      try {

        if (saveFileInExtStorage) {
          fout = new FileOutputStream(outputFile);
          this.signatureView.getSignature().compress(Bitmap.CompressFormat.PNG, 90, fout);
          fout.flush();
          fout.close();
        }


        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        Bitmap resizedBitmap = getResizedBitmap(this.signatureView.getSignature());
        resizedBitmap.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream);

        byte[] byteArray = byteArrayOutputStream.toByteArray();
        String encoded = Base64.encodeToString(byteArray, Base64.DEFAULT);

        WritableMap event = Arguments.createMap();
        event.putString("pathName", outputFile.getAbsolutePath());
        event.putString("encoded", encoded);
        mReactContext.getJSModule(RCTEventEmitter.class).receiveEvent(getId(), "topChange", event);
      } catch (IOException e) {
        e.printStackTrace();
      }
    }
  }


  public Bitmap getResizedBitmap(Bitmap image) {
    Log.d("React Signature", "maxSize:" + maxSize);
    int width = image.getWidth();
    int height = image.getHeight();

    float bitmapRatio = (float) width / (float) height;
    if (bitmapRatio > 1) {
      width = maxSize;
      height = (int) (width / bitmapRatio);
    } else {
      height = maxSize;
      width = (int) (height * bitmapRatio);
    }

    return Bitmap.createScaledBitmap(image, width, height, true);
  }


  public void reset() {
    if (this.signatureView != null) {
      this.signatureView.clearSignature();
    }
  }

  @Override
  public void onDragged() {
    WritableMap event = Arguments.createMap();
    event.putBoolean("dragged", true);
    ReactContext reactContext = (ReactContext) getContext();
    reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(getId(), "topChange", event);

  }
}
