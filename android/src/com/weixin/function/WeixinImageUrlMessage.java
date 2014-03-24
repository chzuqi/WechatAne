package com.weixin.function;

import java.net.URL;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.tencent.mm.sdk.openapi.SendMessageToWX;
import com.tencent.mm.sdk.openapi.WXImageObject;
import com.tencent.mm.sdk.openapi.WXMediaMessage;

public class WeixinImageUrlMessage implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] arg1) {
		WeixinShared.context = context;
		String url;
		String send;
		try
		{
			send = arg1[0].getAsString();
			url = arg1[1].getAsString();
		}
		catch(Exception e)
		{
			WeixinShared.event("ARG_ERROR", "could not get from args");
			return null;
		}
		//載入必須異步進行
		new SendImageTask().execute(send, url);
		return null;
	}
}
class SendImageTask extends AsyncTask<String, Void, Void> {

	@Override
	protected Void doInBackground(String... params) {
		// TODO Auto-generated method stub
		String sent = params[0];
		String url = params[1];
		int sendTo = WeixinShared.getSendTo(sent);
		WXImageObject imgObj = new WXImageObject();
		imgObj.imageUrl = url;
		
		WXMediaMessage msg = new WXMediaMessage();
		msg.mediaObject = imgObj;
		try{
//			WeixinShared.event("WXLOG", "starting decode stream" + url);
			Bitmap bmp = BitmapFactory.decodeStream(new URL(url).openStream());
//			WeixinShared.event("WXLOG", "load complete");
			Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp, WeixinShared.THUMB_SIZE, WeixinShared.THUMB_SIZE, true);
//			WeixinShared.event("WXLOG", "ready to recycle");
			//bmp.recycle();
			msg.thumbData = WeixinShared.bmpToByteArray(thumbBmp, true);
		}catch(Exception e)
		{
			WeixinShared.event("ERROR while loading", e.toString());
			return null;
		}
		
//		WeixinShared.event("WXLOG", "prepered sending");
		SendMessageToWX.Req req = new SendMessageToWX.Req();
		req.transaction = WeixinShared.buildTransaction("img");
		req.message = msg;
		req.scene = sendTo;
//		WeixinShared.event("WXLOG", "sending");
		// 调用api接口发送数据到微信
		WeixinShared.api.sendReq(req);
		return null;
	}
}
