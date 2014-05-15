package com.weixin.function;

import android.graphics.Bitmap;
import android.widget.Toast;

import com.adobe.fre.FREBitmapData;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.tencent.mm.sdk.openapi.SendMessageToWX;
import com.tencent.mm.sdk.openapi.WXImageObject;
import com.tencent.mm.sdk.openapi.WXMediaMessage;

public class WeixinImageMessage implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] arg1) {
		WeixinShared.context = context;
		int sendTo = 1;
		Bitmap bmp = null;
		try
		{
			sendTo = WeixinShared.getSendTo(arg1[0].getAsString());
			FREBitmapData as3Bitmap = (FREBitmapData)arg1[1];
			bmp = WeixinShared.getBitmapFromFreBitmapdata(as3Bitmap);
		}
		catch(Exception e)
		{
			WeixinShared.event("ARG_ERROR", "could not get from args");
			return null;
		}
		try
		{
			if (WeixinShared.api.isWXAppInstalled() == false){
				Toast.makeText(WeixinShared.context.getActivity(), "微信没安装，无法分享。", Toast.LENGTH_SHORT).show();
				return null;
			}
			WXImageObject imgObj = new WXImageObject(bmp);
			
			WXMediaMessage msg = new WXMediaMessage();
			msg.mediaObject = imgObj;
			
			Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp, WeixinShared.THUMB_SIZE, WeixinShared.THUMB_SIZE, true);
			msg.thumbData = WeixinShared.bmpToByteArray(thumbBmp, true);  // 设置缩略图

			SendMessageToWX.Req req = new SendMessageToWX.Req();
			req.transaction = WeixinShared.buildTransaction("img");
			req.message = msg;
			req.scene = sendTo;
			
			// 调用api接口发送数据到微信
			WeixinShared.api.sendReq(req);
			bmp.recycle();
			
		}
		catch(Exception e)
		{
			WeixinShared.event(WeixinCode.SEND_FAIL, e.getMessage());
			return null;
		}
		return null;
	}

}
