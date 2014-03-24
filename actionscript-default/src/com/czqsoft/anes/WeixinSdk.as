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
	 * 微信ANE
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
		private static var _appid:String;
		
		private static var APPSTRING:String = 'com.weixin.ane';
		/**
		 * 分享到会话 
		 */		
		public static const WXSceneSession:String = "WXSceneSession";
		/**
		 * 分享到朋友圈 
		 */		
		public static const WXSceneTimeline:String = "WXSceneTimeline";
		/**
		 * 分享到收藏夹 
		 */		
		public static const WXSceneFavorite:String = "WXSceneFavorite";

		private static const WECHAT_FUNCTION_REGISTER:String = "wechat_function_register";//与java端中Map里的key一致
		private static const WECHAT_FUNCTION_SEND_TEXT:String = "wechat_function_text";//与java端中Map里的key一致
		private static const WECHAT_FUNCTION_SEND_LINK:String = "wechat_function_link";//与java端中Map里的key一致
		private static const WECHAT_FUNCTION_SEND_IMAGE:String = "wechat_function_image";//与java端中Map里的key一致
		private static const WECHAT_FUNCTION_SEND_APP:String = "wechat_function_app";//与java端中Map里的key一致
		private static const WECHAT_FUNCTION_OPEN_URL:String = "wechat_function_open_url";//与java端中Map里的key一致

		public function WeixinSdk(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public static function get instance():WeixinSdk
		{
			if (!_instance)
			{
				_instance=new WeixinSdk();
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
		}
		
		public function sendTextContent(shareTo:String, text:String):void
		{
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
		}
		/**
		 * 分享图片信息 
		 * @param shareTo
		 * @param image
		 * 
		 */		
		public function sendImageContent(shareTo:String, image:BitmapData):void
		{
		}
		/**
		 * 分享图片信息(by url) 
		 * @param shareTo
		 * @param imageUrl
		 * 
		 */	
		public function sendImageContentByUrl(shareTo:String, imageUrl:String):void{
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
		}
	}
}