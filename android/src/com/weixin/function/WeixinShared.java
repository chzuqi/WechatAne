package com.weixin.function;

import java.io.ByteArrayOutputStream;

import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.SendMessageToWX;

public class WeixinShared {
	public static final int THUMB_SIZE = 150;
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
		if (type == "WXSceneSession"){
			return SendMessageToWX.Req.WXSceneSession;			
		}else if (type == "WXSceneTimeline"){
			return SendMessageToWX.Req.WXSceneTimeline;
		}else{
			//不能发送去收藏？
			return SendMessageToWX.Req.WXSceneSession;
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
}
