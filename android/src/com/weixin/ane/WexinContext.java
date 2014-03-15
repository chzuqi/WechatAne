package com.weixin.ane;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.weixin.function.WeixinAppMessage;
import com.weixin.function.WeixinImageMessage;
import com.weixin.function.WeixinLinkMessage;
import com.weixin.function.WeixinOpenUrl;
import com.weixin.function.WeixinRegister;
import com.weixin.function.WeixinTextMessage;

public class WexinContext extends FREContext {
	
	private static final String WECHAT_FUNCTION_REGISTER = "wechat_function_register";//与java端中Map里的key一致
	private static final String WECHAT_FUNCTION_SEND_TEXT = "wechat_function_text";//与java端中Map里的key一致
	private static final String WECHAT_FUNCTION_SEND_LINK = "wechat_function_link";//与java端中Map里的key一致
	private static final String WECHAT_FUNCTION_SEND_IMAGE = "wechat_function_image";//与java端中Map里的key一致
	private static final String WECHAT_FUNCTION_SEND_APP = "wechat_function_app";//与java端中Map里的key一致
	private static final String WECHAT_FUNCTION_OPEN_URL = "wechat_function_open_url";//与java端中Map里的key一致
	@Override
	public void dispose() {

	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		// TODO Auto-generated method stub
		Map<String, FREFunction> map = new HashMap<String, FREFunction>();
		//映射
		map.put(WECHAT_FUNCTION_REGISTER, new WeixinRegister());
		map.put(WECHAT_FUNCTION_SEND_TEXT, new WeixinTextMessage());
		map.put(WECHAT_FUNCTION_SEND_LINK, new WeixinLinkMessage());
		map.put(WECHAT_FUNCTION_SEND_IMAGE, new WeixinImageMessage());
		map.put(WECHAT_FUNCTION_SEND_APP, new WeixinAppMessage());
		map.put(WECHAT_FUNCTION_OPEN_URL, new WeixinOpenUrl());
		return map;
	}

}
