WechatAne
=========

微信ane for ios and android

WeixinSdk.instance.register("你的微信appid");  
WeixinSdk.instance.addEventListener(StatusEvent.STATUS, onStatus);  

function onStatus(e:StatusEvent):void  
{   
	trace(e.code, e.level);  
	switch(e.code)  
	{  
		case "onResp":  
			if (e.level == "0")  
			{  
			//你的分享成功代码    
			}  
			break;  
	}  
}  
  
WeixinSdk.instance.sendTextContent(WeixinSdk.WXSceneSession, "text");  
WeixinSdk.instance.sendImageContent(WeixinSdk.WXSceneFavorite, bmd);  
WeixinSdk.instance.sendAppContent(WeixinSdk.WXSceneTimeline, "title", "content", "http://www.github.com", bmd);  
