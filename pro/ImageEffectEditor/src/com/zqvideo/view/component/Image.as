package com.zqvideo.view.component
{
	import com.zqvideo.view.core.ComponentView;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	
	import mvc.Command;
	import mvc.ICommand;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class Image extends ComponentView
	{
		protected var _data:XML;
		
		protected var _ui:MovieClip;
		
		protected var _pageIndex:int=0;
		protected var _id:int=0;
		
		protected var _isHasData:Boolean=false;
		
		protected var imageName:String="";
		
		protected var imageUrl:String="";
		
		protected var loader:Loader;
		
		protected var loaderContext:LoaderContext; 
		
		protected var imageContainer:MovieClip;
		
		protected var imageLoading:MovieClip;
		
		protected var nameTxt:TextField;
		
		protected var tipTxt:TextField;
		
		public function Image()
		{
			super();
		}
		
		override protected function addToStageShow():void{
			this.addChild(rootContainer);
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get data():XML{
			return _data;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set data(value:XML):void{
			_data=value;
			if(!value){
				_isHasData=false;
				return;
			}
			_isHasData=true;
			if(value.@Name){
				imageName=value.@Name;
				if(nameTxt){
					nameTxt.visible=true;
					nameTxt.text=imageName;
				}
			}
			
			if(value.@IMGUrl){
				imageUrl=value.@IMGUrl;
				loadUrl(imageUrl);
			}
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get pageIndex():int{
			return _pageIndex;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set pageIndex(value:int):void{
			_pageIndex=value;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get id():int{
			return _id;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set id(value:int):void{
			_id=value;
		}
		
		public function get isHasData():Boolean{
			return _isHasData;
		}
		
		public function set isHasData(value:Boolean):void{
			_isHasData=value;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get ui():MovieClip{
			return _ui;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set ui(value:MovieClip):void{
			_ui=value;
			if(value){
				rootContainer.addChild(value);
			}
			
			if(value["container"]){
				imageContainer=value.getChildByName("container") as MovieClip;
			}
			
			if(value["loading"]){
				imageLoading=value.getChildByName("loading") as MovieClip;
			}
			
			if(value["tipTxt"]){
				tipTxt=value.getChildByName("tipTxt") as TextField;
			}
			
			if(value["nameTxt"]){
				nameTxt=value.getChildByName("nameTxt") as TextField;
			}
		}
		
		/**
		 * 
		 * @param e
		 */
		protected function imageMouseOverHandler(e:MouseEvent):void{
			
		}
		
		/**
		 * 
		 * @param e
		 */
		protected function imageMouseOutHandler(e:MouseEvent):void{
			
		}
		
		/**
		 * 
		 * @param e
		 */
		protected function imageMouseClickHandler(e:MouseEvent):void{
			
		}
		
		/**
		 * 
		 * @param url
		 */
		public function loadUrl(url:String):void{
			if(url){
				if(imageLoading){
					imageLoading.visible=true;
				}
				
				/*if(tipTxt){
					tipTxt.visible=true;
				}*/
				
				loader=new Loader();
				loaderContext=new LoaderContext(true);
				loader.load(new URLRequest(url),loaderContext);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadErrorHandler);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,loadProgressHandler);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler);
			}
			
		}
		
		protected function loadErrorHandler(e:IOErrorEvent):void{
			//trace("图片加载出错:"+e.text);
			imageLoadErrorHandler();
			if(tipTxt){
				tipTxt.visible=true;
				tipTxt.text="图片加载出错！";
			}
		}
		protected function imageLoadErrorHandler():void
		{
			
		}
		protected function loadProgressHandler(e:ProgressEvent):void{
			/*if(tipTxt){
				tipTxt.visible=true;
				var per:String=String(Math.round(e.bytesLoaded/e.bytesTotal*100))+"%";
				tipTxt.text=per;
			}*/
		}
		
		protected function loadCompleteHandler(e:Event):void{
			imageInitHandler();
		}
		
		protected function imageInitHandler():void{
			imageContainer.buttonMode=true;
			imageContainer.addEventListener(MouseEvent.MOUSE_OVER,imageMouseOverHandler);
			imageContainer.addEventListener(MouseEvent.MOUSE_OUT,imageMouseOutHandler);
			imageContainer.addEventListener(MouseEvent.CLICK,imageMouseClickHandler);
		}
		
		protected function close():void{
			try
			{
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,loadErrorHandler);
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,loadProgressHandler);
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadCompleteHandler);
				loader.unload();
				loader=null;
			} 
			catch(error:Error) 
			{
				trace(error);
				
			}
		}
	}
}