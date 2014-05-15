package com.weixin.function;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

public class WeixinIsInstalled implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] arg1) {
		WeixinShared.context = context;
//			Toast.makeText(WeixinShared.context.getActivity(), "微信没安装，无法分享。", Toast.LENGTH_SHORT).show();
		try{
			return FREObject.newObject(WeixinShared.api.isWXAppInstalled());
		}catch(FREWrongThreadException e){
			return null;
		}
	}

}
