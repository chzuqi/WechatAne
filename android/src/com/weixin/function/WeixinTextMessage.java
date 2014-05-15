package com.weixin.function;

import android.widget.Toast;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.tencent.mm.sdk.openapi.SendMessageToWX;
import com.tencent.mm.sdk.openapi.WXMediaMessage;
import com.tencent.mm.sdk.openapi.WXTextObject;

public class WeixinTextMessage implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] arg1) {
		
		WeixinShared.context = context;
		int sendTo = 1;
		String text = null;
		try
		{
			sendTo = WeixinShared.getSendTo(arg1[0].getAsString());
			text = arg1[1].getAsString();
			
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
			WXTextObject textObj = new WXTextObject();
			textObj.text = text;
	
			// 用WXTextObject对象初始化一个WXMediaMessage对象
			WXMediaMessage msg = new WXMediaMessage();
			msg.mediaObject = textObj;
			// 发送文本类型的消息时，title字段不起作用
			// msg.title = "Will be ignored";
			msg.description = text;
	
			// 构造一个Req
			SendMessageToWX.Req req = new SendMessageToWX.Req();
			req.transaction = WeixinShared.buildTransaction("text"); // transaction字段用于唯一标识一个请求
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
