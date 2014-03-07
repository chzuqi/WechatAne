package com.weixin.weixinapi;


import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import com.tencent.mm.sdk.openapi.BaseReq;
import com.tencent.mm.sdk.openapi.BaseResp;
import com.tencent.mm.sdk.openapi.ConstantsAPI;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.weixin.function.WeixinCode;
import com.weixin.function.WeixinShared;

public class WXEntryActivity extends Activity implements IWXAPIEventHandler{
	
	// IWXAPI 是第三方app和微信通信的openapi接口
    private IWXAPI api;
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        WeixinShared.api.handleIntent(getIntent(), this);
    }

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		
		setIntent(intent);
        api.handleIntent(intent, this);
	}

	// 微信发送请求到第三方应用时，会回调到该方法
	@Override
	public void onReq(BaseReq req) {
		//额，关我啥事呢...
		switch (req.getType()) {
		case ConstantsAPI.COMMAND_GETMESSAGE_FROM_WX:
			break;
		case ConstantsAPI.COMMAND_SHOWMESSAGE_FROM_WX:
			break;
		default:
			break;
		}
	}

	// 第三方应用发送到微信的请求处理后的响应结果，会回调到该方法
	@Override
	public void onResp(BaseResp resp) {
		switch (resp.errCode) {
		case BaseResp.ErrCode.ERR_OK:
			WeixinShared.event(WeixinCode.ERR_OK, resp.errStr);
			break;
		case BaseResp.ErrCode.ERR_USER_CANCEL:
			WeixinShared.event(WeixinCode.ERR_USER_CANCEL, resp.errStr);
			break;
		case BaseResp.ErrCode.ERR_AUTH_DENIED:
			WeixinShared.event(WeixinCode.ERR_AUTH_DENIED, resp.errStr);
			break;
		default:
			WeixinShared.event("unknow_error", resp.errStr);
			break;
		}
	}
}