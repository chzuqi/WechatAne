package com.weixin.function;

import android.widget.Toast;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.tencent.mm.sdk.openapi.SendMessageToWX;
import com.tencent.mm.sdk.openapi.WXMediaMessage;
import com.tencent.mm.sdk.openapi.WXWebpageObject;

public class WeixinLinkMessage implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] arg1) {
		WeixinShared.context = context;
		int sendTo = 1;
		String text = null;
		String title = null;
		String url = null;
		try
		{
			sendTo = WeixinShared.getSendTo(arg1[0].getAsString());
			title = arg1[1].getAsString();
			text = arg1[2].getAsString();
			url = arg1[3].getAsString();
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
			WXWebpageObject webpage = new WXWebpageObject();
			webpage.webpageUrl = url;
			WXMediaMessage msg = new WXMediaMessage(webpage);
			msg.title = title;
			msg.description = text;
			
			SendMessageToWX.Req req = new SendMessageToWX.Req();
			req.transaction = WeixinShared.buildTransaction("webpage");
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
