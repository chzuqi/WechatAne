package com.czqsoft.anes
{
	import flash.desktop.NativeApplication;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.InvokeEvent;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	/**
	 * 微信ANE，ios版
	 * 如果需要使用，请于app.xml加入以下代码
	   <dict>
	    <key>CFBundleURLName</key>
	    <string>weixin</string>
	    <key>CFBundleURLSchemes</key>
	    <array>
	      <string>你的微信appid</string>
	    </array>
	   </dict> 
	 * 
	 * @author czq
	 * 
	 */	
	public class WeixinSdk extends EventDispatcher
	{
		private static var _instance:WeixinSdk;
		private static var _extContext:ExtensionContext;
		private static var _appid:String;
//		private static var _shareTo:String;
		protected static var APPSTRING:String = 'com.czqsoft.ane.WeixinSdk';
		
		public static const WXSceneSession:String = "WXSceneSession";
		public static const WXSceneTimeline:String = "WXSceneTimeline";
		public static const WXSceneFavorite:String = "WXSceneFavorite";
		
		public function WeixinSdk(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public static function get instance():WeixinSdk
		{
			if (!_instance)
			{
				_instance=new WeixinSdk();
				_extContext=ExtensionContext.createExtensionContext(APPSTRING, null);
				if (!_extContext)
				{
					trace("ERROR - Extension context is null. Please check if extension.xml is setup correctly.");
				}
				else
				{
					_extContext.addEventListener(StatusEvent.STATUS, _instance.statusHandler);
					NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE,_instance.systemInvoke);
				}
			}
			return _instance;
		}
		/**
		 * 必须将url事件传入微信处理 
		 * @param event
		 * 
		 */		
		protected function systemInvoke(event:InvokeEvent):void
		{
			if(event.arguments.length>0){
				var url:String = event.arguments[0] as String;
				var b:Boolean = _extContext.call("openUrl",url);
			}
		}
		
		protected function statusHandler(event:StatusEvent):void
		{
			dispatchEvent(event);
		}
		/**
		 * 注册微信 
		 * @param appid 微信上的appid
		 * 
		 */		
		public function register(appid:String):void
		{
			_appid = appid;
			_extContext.call("registerWeixin", appid);
		}
		
		public function sendTextContent(shareTo:String, text:String):void
		{
			_extContext.call("sendTextContent", shareTo, text);
		}
		/**
		 * 分享链接 
		 * @param shareTo
		 * @param title
		 * @param text
		 * @param url
		 * 
		 */		
		public function sendLinkContent(shareTo:String, title:String, text:String, url:String):void
		{
			_extContext.call("sendLinkContent", shareTo, title, text, url);
		}
		/**
		 * 分享图片信息 
		 * @param shareTo
		 * @param image
		 * 
		 */		
		public function sendImageContent(shareTo:String, image:BitmapData):void
		{
			_extContext.call("sendImageContent", shareTo, image);
		}
		/**
		 * 发送应用信息 
		 * @param shareTo
		 * @param title 标题
		 * @param text 文字内容
		 * @param url 将要跳至的链接
		 * @param image 图片
		 * 
		 */		
		public function sendAppContent(shareTo:String, title:String, text:String, url:String, image:BitmapData):void
		{
			_extContext.call("sendAppContent", shareTo, title, text, url, image);
		}
	}
}