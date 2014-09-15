package 
{
	import LoadEvent;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
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
		private var urlLoader:URLLoader=new URLLoader();
		private var imgUrl:URLRequest=null;
		private var imgLoader:Loader=null;
		private var loaderContext:LoaderContext=null;
		private var bitmap:Bitmap=null;
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
				var str:String=imageUrlArr.shift();
				loadImage(str);
			}
		}

		private function loadImage(str:String):void
		{
			imgLoader=new Loader();
			imgUrl=new URLRequest(str);
			//loaderContext=new LoaderContext(true);
			imgLoader.load(imgUrl);
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			imgLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
			imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
		}

		private function loaderCompleteHandler(e:Event):void
		{
			bitmap=e.currentTarget.content as Bitmap;
			_allBitmapData.push(bitmap);
			currentBitmap=bitmap;
			var obj:Object=new Object();
			obj.bitmap=bitmap;
			this.dispatchEvent(new LoadEvent(LoadEvent.IMAGE_LOAD_COMPLETE, obj));

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
