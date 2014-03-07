package com.weixin.function;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

public class WeixinRegister implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] arg1) {
		WeixinShared.context = context;
		
		try
		{
			WeixinShared.appid = arg1[0].getAsString();
		}
		catch(Exception e)
		{
			WeixinShared.event("ARG_ERROR", "could not get appid from args");
			return null;
		}
		try
		{
			WeixinShared.api = WXAPIFactory.createWXAPI(context.getActivity(), null);
			// 将该app注册到微信
			WeixinShared.api.registerApp(WeixinShared.appid);
		}
		catch(Exception e)
		{
			WeixinShared.event(WeixinCode.INIT_FAIL, e.getMessage());
			return null;
		}
		return null;
	}

}
