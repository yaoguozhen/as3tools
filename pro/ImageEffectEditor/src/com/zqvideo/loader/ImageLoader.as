package com.zqvideo.loader
{
	import com.zqvideo.event.LoadEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.System;

	/**
	 * 图片加载类
	 * @author .....Li灬Star
	 */
	public class ImageLoader extends EventDispatcher
	{
		private var _imageUrlArr:Array=[];
		private var _allBitmapData:Array=[];
		private var currentLoadObj:Object={};
		private var urlLoader:URLLoader=new URLLoader();
		private var imgUrl:URLRequest=null;
		private var imgLoader:Loader=null;
		private var loaderContext:LoaderContext=null;
		private var bitmap:Bitmap=null;
		private var viewID:int=0;
		private var urlStr:String="";
		private var _currentBitmap:Bitmap=null;
		private var index:int=0;
		

		public function get imageUrlArr():Array{
			return _imageUrlArr;
		}
		
		public function set imageUrlArr(value:Array):void{
			_imageUrlArr=value;
		}
		
		public function get allBitmapData():Array
		{
			return _allBitmapData;
		}

		public function set allBitmapData(value:Array):void
		{
			_allBitmapData=value;
		}

		public function get currentBitmap():Bitmap
		{
			return _currentBitmap;
		}

		public function set currentBitmap(value:Bitmap):void
		{
			_currentBitmap=value;
		}

		public function ImageLoader()
		{
			
		}

		public function loadImgData():void
		{
			if (imageUrlArr.length > 0)
			{
				/*currentLoadObj=imageUrlArr.shift();
				urlStr=currentLoadObj.urlStr;*/
				currentLoadObj={};
				urlStr=imageUrlArr.shift();
				loadImage(urlStr);
			}
		}

		private function loadImage(str:String):void
		{
			imgLoader=new Loader();
			imgUrl=new URLRequest(str);
			loaderContext=new LoaderContext(true);
			imgLoader.load(imgUrl,loaderContext);
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			imgLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
			imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
		}

		private function loaderCompleteHandler(e:Event):void
		{
			bitmap=e.currentTarget.content as Bitmap;
			var container:Sprite=new Sprite();
			container.addChild(bitmap);
			bitmap.width=Root.MAX_IMAGE_WIDTH;
			bitmap.height=Root.MAX_IMAGE_HEIGHT;
			var bitmapData:BitmapData=new BitmapData(bitmap.width,bitmap.height);
			bitmapData.draw(container);
			var _bitmap:Bitmap=new Bitmap(bitmapData,"auto",true);
			currentLoadObj.bitmap=_bitmap;
			currentLoadObj.urlStr=urlStr;
			_allBitmapData.push(currentLoadObj);
			//this.dispatchEvent(new LoadEvent(LoadEvent.IMAGE_LOAD_COMPLETE, currentLoadObj));

			try
			{
				imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
				imgLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
				imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
				imgLoader.unload();
				imgLoader=null;
			} 
			catch(error:Error) 
			{
				trace(error.toString());
			}
			
			if (imageUrlArr.length < 1)
			{
				this.dispatchEvent(new LoadEvent(LoadEvent.IMAGE_ALL_COMPLETE)); //发送图片全部加载完成事件 
			}
			else
			{
				loadImgData();
				index++;
			}
		}

		private function loaderProgressHandler(e:ProgressEvent):void
		{
			//trace(Math.round(e.bytesLoaded/e.bytesTotal*100)+"%");
		}

		private function loaderErrorHandler(e:IOErrorEvent):void
		{
			var obj:Object=new Object();
			obj.errTxt=e.text;
			this.dispatchEvent(new LoadEvent(LoadEvent.IMAGE_LOAD_ERROR, obj));
		}
	}
}
