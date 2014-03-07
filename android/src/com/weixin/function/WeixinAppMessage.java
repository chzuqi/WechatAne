package com.weixin.function;

import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;

import com.adobe.fre.FREBitmapData;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.tencent.mm.sdk.openapi.SendMessageToWX;
import com.tencent.mm.sdk.openapi.WXAppExtendObject;
import com.tencent.mm.sdk.openapi.WXImageObject;
import com.tencent.mm.sdk.openapi.WXMediaMessage;

public class WeixinAppMessage implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] arg1) {
		WeixinShared.context = context;
		int sendTo = 1;
		Bitmap bmp = null;
		String text = null;
		String title = null;
		String url = null;
		try
		{
			sendTo = WeixinShared.getSendTo(arg1[0].getAsString());
			title = arg1[1].getAsString();
			text = arg1[2].getAsString();
			url = arg1[3].getAsString();
			FREBitmapData inputValue = (FREBitmapData)arg1[4];
		    inputValue.acquire();
		    int srcWidth = inputValue.getWidth();
		    int srcHeight = inputValue.getHeight();
		    bmp = Bitmap.createBitmap(srcWidth, srcHeight, Config.ARGB_8888);
		    bmp.copyPixelsFromBuffer(inputValue.getBits());
		}
		catch(Exception e)
		{
			WeixinShared.event("ARG_ERROR", "could not get from args");
			return null;
		}
		try
		{
			final WXAppExtendObject appdata = new WXAppExtendObject();
			//跟ios不一样...and没有url变量
			appdata.extInfo = url;
			
			final WXMediaMessage msg = new WXMediaMessage();
			Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp, WeixinShared.THUMB_SIZE, WeixinShared.THUMB_SIZE, true);
			bmp.recycle();
			msg.thumbData = WeixinShared.bmpToByteArray(thumbBmp, true);  // 设置缩略图
			msg.title = title;
			msg.description = text;
			msg.mediaObject = appdata;
			
			SendMessageToWX.Req req = new SendMessageToWX.Req();
			req.transaction = WeixinShared.buildTransaction("appdata");
			req.message = msg;
			req.scene = sendTo;
			
			// 调用api接口发送数据到微信
			WeixinShared.api.sendReq(req);
		}
		catch(Exception e)
		{
			WeixinShared.event(WeixinCode.SEND_FAIL, e.getMessage());
			return null;
		}
		return null;
	}

}
