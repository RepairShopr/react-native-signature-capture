package com.rsssignaturecapture;

import android.content.Context;

import android.view.View;
import android.view.MotionEvent;

import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Canvas;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.RectF;

import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;

public class RSSSignatureCaptureView extends View {
	private static final float STROKE_WIDTH = 5f;
	private static final float HALF_STROKE_WIDTH = STROKE_WIDTH / 2;
	
	private Paint paint = new Paint();
	private Path path = new Path();
	
	private float lastTouchX;
	private float lastTouchY;
	private final RectF dirtyRect = new RectF();
	
	public RSSSignatureCaptureView(Context context) {
		
		super(context);
		
		paint.setAntiAlias(true);
		paint.setColor(Color.BLACK);
		paint.setStyle(Paint.Style.STROKE);
		paint.setStrokeJoin(Paint.Join.ROUND);
		paint.setStrokeWidth(STROKE_WIDTH);
		
		// set the bg color as white
		this.setBackgroundColor(Color.WHITE);
		
		// width and height should cover the screen
		this.setLayoutParams(new LinearLayout.LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
		
	}
	
	/**
	* Get signature
	*
	* @return
	*/
	protected Bitmap getSignature() {
		
		Bitmap signatureBitmap = null;
		
		// set the signature bitmap
		if (signatureBitmap == null) {
			signatureBitmap = Bitmap.createBitmap(this.getWidth(), this.getHeight(), Bitmap.Config.RGB_565);
		}
		
		// important for saving signature
		final Canvas canvas = new Canvas(signatureBitmap);
		this.draw(canvas);
		
		return signatureBitmap;
	}
	
	/**
	* clear signature canvas
	*/
	private void clearSignature() {
		path.reset();
		this.invalidate();
	}
	
	// all touch events during the drawing
	@Override
	protected void onDraw(Canvas canvas) {
		canvas.drawPath(this.path, this.paint);
	}
	
	@Override
	public boolean onTouchEvent(MotionEvent event) {
		float eventX = event.getX();
		float eventY = event.getY();
		
		switch (event.getAction()) {
			case MotionEvent.ACTION_DOWN:
			
			path.moveTo(eventX, eventY);
			
			lastTouchX = eventX;
			lastTouchY = eventY;
			return true;
			
			case MotionEvent.ACTION_MOVE:
			
			case MotionEvent.ACTION_UP:
			
			resetDirtyRect(eventX, eventY);
			int historySize = event.getHistorySize();
			for (int i = 0; i < historySize; i++) {
				float historicalX = event.getHistoricalX(i);
				float historicalY = event.getHistoricalY(i);
				
				expandDirtyRect(historicalX, historicalY);
				path.lineTo(historicalX, historicalY);
			}
			path.lineTo(eventX, eventY);
			break;
			
			default:
			
			return false;
		}
		
		invalidate((int) (dirtyRect.left - HALF_STROKE_WIDTH),
		(int) (dirtyRect.top - HALF_STROKE_WIDTH),
		(int) (dirtyRect.right + HALF_STROKE_WIDTH),
		(int) (dirtyRect.bottom + HALF_STROKE_WIDTH));
		
		lastTouchX = eventX;
		lastTouchY = eventY;
		
		return true;
	}
	
	private void expandDirtyRect(float historicalX, float historicalY) {
		if (historicalX < dirtyRect.left) {
			dirtyRect.left = historicalX;
		} else if (historicalX > dirtyRect.right) {
			dirtyRect.right = historicalX;
		}
		
		if (historicalY < dirtyRect.top) {
			dirtyRect.top = historicalY;
		} else if (historicalY > dirtyRect.bottom) {
			dirtyRect.bottom = historicalY;
		}
	}
	
	private void resetDirtyRect(float eventX, float eventY) {
		dirtyRect.left = Math.min(lastTouchX, eventX);
		dirtyRect.right = Math.max(lastTouchX, eventX);
		dirtyRect.top = Math.min(lastTouchY, eventY);
		dirtyRect.bottom = Math.max(lastTouchY, eventY);
	}
}