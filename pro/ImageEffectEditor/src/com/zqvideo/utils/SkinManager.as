package com.zqvideo.utils
{
	import flash.display.LoaderInfo;
	import flash.utils.Dictionary;
	import flash.system.ApplicationDomain;

	/**
	 * 获取库元件总类
	 */
	public class SkinManager
	{
		private static var skinDict:Dictionary=new Dictionary();

		public function SkinManager()
		{
		}

		public static function addSwfSkin($obj:LoaderInfo, $name:String):void
		{
			skinDict[$name]=$obj;
		}

		public static function getSwfSkin($name:String):LoaderInfo
		{
			return skinDict[$name];
		}

		public static function getSkinClassByName($loadInfo:LoaderInfo, $name:String):Class
		{
			var app:ApplicationDomain=$loadInfo.applicationDomain;
			var cls:Class=app.getDefinition($name) as Class
			return cls;
		}
	}
}
