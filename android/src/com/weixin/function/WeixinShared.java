package com.weixin.function;

import java.io.ByteArrayOutputStream;

import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.Canvas;
import android.graphics.ColorMatrix;
import android.graphics.ColorMatrixColorFilter;
import android.graphics.Paint;
import android.util.Log;

import com.adobe.fre.FREBitmapData;
import com.adobe.fre.FREContext;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.SendMessageToWX;

public class WeixinShared {
	public static final int THUMB_SIZE = 120;
	public static IWXAPI api = null;
	public static FREContext context = null;
	public static String appid = null;
	
	public static void event(String code,String level  ){
		Log.d(code, "event" + ":"+level );
		context.dispatchStatusEventAsync(code, level );
	}
	
	public static String buildTransaction(final String type) {
		return (type == null) ? String.valueOf(System.currentTimeMillis()) : type + System.currentTimeMillis();
	}
	
	public static int getSendTo(String type){
//		event("WXLOG", "sendTo:" + type);
		if (type.equals("WXSceneSession")){
			return SendMessageToWX.Req.WXSceneSession;			
		}else if (type.equals("WXSceneTimeline")){
			return SendMessageToWX.Req.WXSceneTimeline;
		}else{
			//不能发送去收藏？
			return SendMessageToWX.Req.WXSceneTimeline;
		}
	}
	
	public static byte[] bmpToByteArray(final Bitmap bmp, final boolean needRecycle) {
		ByteArrayOutputStream output = new ByteArrayOutputStream();
		bmp.compress(CompressFormat.PNG, 100, output);
		if (needRecycle) {
			bmp.recycle();
		}
		
		byte[] result = output.toByteArray();
		try {
			output.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	public static Bitmap getBitmapFromFreBitmapdata(final FREBitmapData as3Bitmap){
		Bitmap m_encodingBitmap         = null;
		Canvas m_canvas                 = null;
		Paint m_paint                   = null;    
		final float[] m_bgrToRgbColorTransform  =
		    {
		        0,  0,  1f, 0,  0, 
		        0,  1f, 0,  0,  0,
		        1f, 0,  0,  0,  0, 
		        0,  0,  0,  1f, 0
		    };
		final ColorMatrix               m_colorMatrix               = new ColorMatrix(m_bgrToRgbColorTransform);
		final ColorMatrixColorFilter    m_colorFilter               = new ColorMatrixColorFilter(m_colorMatrix);
		try{
			as3Bitmap.acquire();
			int srcWidth = as3Bitmap.getWidth();
		    int srcHeight = as3Bitmap.getHeight();
//		    event("WeixinShared", "size:" + srcWidth + "," + srcHeight);
			m_encodingBitmap    = Bitmap.createBitmap(srcWidth, srcHeight, Bitmap.Config.ARGB_8888);
			m_canvas        = new Canvas(m_encodingBitmap);
			m_paint         = new Paint();
			m_paint.setColorFilter(m_colorFilter);
			
			m_encodingBitmap.copyPixelsFromBuffer(as3Bitmap.getBits());
			as3Bitmap.release();
		}catch (Exception e) {
		    e.printStackTrace();
		    event("WeixinShared", "fail to conver image to bitmap");
		}
		//
		// Convert the bitmap from BGRA to RGBA.
		//
		m_canvas.drawBitmap(m_encodingBitmap, 0, 0, m_paint);
		return m_encodingBitmap;
	}
}
