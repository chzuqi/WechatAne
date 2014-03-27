package air.com.loves.supertaste.qihoo.wxapi;


import android.app.Activity;
import android.os.Bundle;

import com.tencent.mm.sdk.openapi.BaseReq;
import com.tencent.mm.sdk.openapi.BaseResp;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.weixin.function.WeixinCode;
import com.weixin.function.WeixinShared;

public class WXEntryActivity extends Activity implements IWXAPIEventHandler{
	
	// IWXAPI 是第三方app和微信通信的openapi接口
//    private IWXAPI api;
	
	public static final String ON_RESP = "wechat.onResp";
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);//wx51c7ffc4b174a70a
//        WeixinShared.api = WXAPIFactory.createWXAPI(this, "wx51c7ffc4b174a70a", false);
//        WeixinShared.context = this.getApplicationContext();
        WeixinShared.api.handleIntent(getIntent(), this);
    }

//	@Override
//	protected void onNewIntent(Intent intent) {
//		super.onNewIntent(intent);
//		
//		setIntent(intent);
//		WeixinShared.api.handleIntent(intent, this);
//	}

	// 微信发送请求到第三方应用时，会回调到该方法
	@Override
	public void onReq(BaseReq req) {
		//额，关我啥事呢...
//		switch (req.getType()) {
//		case ConstantsAPI.COMMAND_GETMESSAGE_FROM_WX:
//			break;
//		case ConstantsAPI.COMMAND_SHOWMESSAGE_FROM_WX:
//			break;
//		default:
//			break;
//		}
	}

	// 第三方应用发送到微信的请求处理后的响应结果，会回调到该方法
	@Override
	public void onResp(BaseResp resp) {
		switch (resp.errCode) {
		case BaseResp.ErrCode.ERR_OK:
			WeixinShared.event("onResp", "0");
//			sendData("onResp", resp.errStr);
			break;
		case BaseResp.ErrCode.ERR_USER_CANCEL:
			WeixinShared.event(WeixinCode.ERR_USER_CANCEL,"resp:" +  resp.errStr);
			break;
		case BaseResp.ErrCode.ERR_AUTH_DENIED:
			WeixinShared.event(WeixinCode.ERR_AUTH_DENIED,"resp:" +  resp.errStr);
			break;
		default:
			WeixinShared.event("unknow_error","resp:" +  resp.errStr);
			break;
		}
		this.finish();
	}
	
//	private void sendData(String tag, String level){
//		Log.d(tag, "level = " + level);
//		Intent intent = new Intent(ON_RESP);  
//        intent.putExtra("tag", tag);
//        intent.putExtra("level", level);
//        sendBroadcast(intent);
//	}
}