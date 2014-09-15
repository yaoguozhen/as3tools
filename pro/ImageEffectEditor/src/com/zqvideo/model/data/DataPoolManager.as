package com.zqvideo.model.data
{
	import com.zqvideo.view.component.HasSelectedImage;
	
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class DataPoolManager extends EventDispatcher
	{
		private static var instance:DataPoolManager=new DataPoolManager();
		
		private var _configData:XML;
		private var _info:LoaderInfo;
		
		private var _hasSelectedImageData:Vector.<Object>=new Vector.<Object>();
		private var _moRenEffectData:XML;
		
		private var _sc:Number=0;
		
		

		/**
		 * 
		 * @throws Error
		 */
		public function DataPoolManager()
		{
			if (instance)
			{
				throw new Error("PlayerUrlManager.getInstance()获取实例");
			}
		}

		/**
		 * 
		 * @return 
		 */
		public static function getInstance():DataPoolManager
		{
			return instance;
		}

		
		/**
		 * 
		 * @return 
		 */
		public function get configData():XML{
			return _configData;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set configData(value:XML):void{
			_configData=value;
			if(value==null){
				return;
			}
			
			_moRenEffectData=value.effects.effect[0];
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get info():LoaderInfo{
			return _info;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set info(value:LoaderInfo):void{
			_info=value;
		}
		
		public function get hasSelectedImageData():Vector.<Object>{
			return _hasSelectedImageData;
		}
		
		public function set hasSelectedImageData(value:Vector.<Object>):void{
			_hasSelectedImageData=value;
		}
		
		public function get moRenEffectData():XML{
			return _moRenEffectData;
		}
		
		public function set moRenEffectData(value:XML):void{
			_moRenEffectData=value;
		}
		
		
		/**
		 * 
		 * @return 
		 */
		public function get sc():Number{
			return _sc;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set sc(value:Number):void{
			_sc=value;
		}
		
		
	}
}
