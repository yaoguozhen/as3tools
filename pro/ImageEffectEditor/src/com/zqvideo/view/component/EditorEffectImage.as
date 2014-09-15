package com.zqvideo.view.component
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.utils.Timer;

	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class EditorEffectImage extends Image
	{
		private var closeBtn:SimpleButton;
		private var zheZhao:MovieClip;
		private var activedMC:MovieClip;
		private var shanDongMC:MovieClip;
		private var _isShanDong:Boolean=false;
		
		private var _isActived:Boolean=false;
		private var _arrangeID:int=0;
		
		private var _hasOverOutEventFlag:Boolean=true;
		
		
		public function EditorEffectImage()
		{
			super();
			
			loader=new Loader();
			loaderContext=new LoaderContext(true);
		}
		
		override public function set data(value:XML):void{
			_data=value;
			if(!value){
				_isHasData=false;
				return;
			}
			_isHasData=true;
			if(value.@Name){
				imageName=value.@Name;
				if(nameTxt){
					//nameTxt.visible=true;
					nameTxt.text=imageName;
				}
			}
			
			if(value.@IMGUrl){
				imageUrl=value.@IMGUrl;
				loadUrl(imageUrl);
			}
		}
		
		override public function get ui():MovieClip{
			return _ui;
		}
		
		override public function set ui(value:MovieClip):void{
			_ui=value;
			if(value){
				rootContainer.addChild(value);
			}
			
			if(value["loading"]){
				imageLoading=value.getChildByName("loading") as MovieClip;
				imageLoading.visible=false;
			}
			
			if(value["closeBtn"]){
				closeBtn=value.getChildByName("closeBtn") as SimpleButton;
				closeBtn.addEventListener(MouseEvent.CLICK,closeClickHandler);
				closeBtn.visible=false;
			}
			
			if(value["zheZhao"]){
				zheZhao=value.getChildByName("zheZhao") as MovieClip;
				zheZhao.visible=false;
			}
			
			if(value["container"]){
				imageContainer=value.getChildByName("container") as MovieClip;
			}
			
			
			if(value["activedMC"]){
				activedMC=value.getChildByName("activedMC") as MovieClip;
				activedMC.visible=false;
			}
			
			if(value["shanDongMC"]){
				shanDongMC=value.getChildByName("shanDongMC") as MovieClip;
				shanDongMC.visible=false;
			}
			
			if(value["nameTxt"]){
				nameTxt=value.getChildByName("nameTxt") as TextField;
				nameTxt.visible=false;
			}
		}
		
		public function get hasOverOutEventFlag():Boolean{
			return _hasOverOutEventFlag;
		}
		
		public function set hasOverOutEventFlag(value:Boolean):void{
			if(value){
				ui.buttonMode=true;
				ui.addEventListener(MouseEvent.MOUSE_OVER,imageMouseOverHandler);
				ui.addEventListener(MouseEvent.MOUSE_OUT,imageMouseOutHandler);
			}else{
				ui.buttonMode=false;
				ui.removeEventListener(MouseEvent.MOUSE_OVER,imageMouseOverHandler);
				ui.removeEventListener(MouseEvent.MOUSE_OUT,imageMouseOutHandler);
			}
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get isActived():Boolean{
			return _isActived;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set isActived(value:Boolean):void{
			_isActived=value;
			activedMC.visible=value;
		}
		
		public function get isShanDong():Boolean{
			return _isShanDong;
		}
		
		public function set isShanDong(value:Boolean):void{
			_isShanDong=value;
			shanDongMC.visible=value;
		}
		
		public function get arrangeID():int{
			return _arrangeID;
		}
		
		public function set arrangeID(value:int):void{
			_arrangeID=value;
		}
		
		override public function loadUrl(url:String):void{
			imageLoading.visible=true;
			loader.load(new URLRequest(url),loaderContext);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadErrorHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,loadProgressHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler);
		}
		
		override protected function imageInitHandler():void{
			
			imageLoading.visible=false;
			
			//UI里面有个容器背景层
			if(imageContainer.numChildren>1){
				imageContainer.removeChildAt(1);
			}
			
			if(imageContainer&&loader.content){
				loader.content.width=imageContainer.width;
				loader.content.height=imageContainer.height;
				Bitmap(loader.content).smoothing=true;
				imageContainer.addChild(loader.content);
				
				hasOverOutEventFlag=true;
			}
			//trace(imageContainer.numChildren+"==============================>");
			close();
		}
		
		override protected function close():void{
			try
			{
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,loadErrorHandler);
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,loadProgressHandler);
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadCompleteHandler);
				loader.unload();
			} 
			catch(error:Error) 
			{
				trace(error);
				
			}
		}
		
		override protected function imageMouseOverHandler(e:MouseEvent):void{
			if(imageContainer.numChildren<=1){
				return;
			}
			zheZhao.visible=true;
			closeBtn.visible=true;
		}
		
		override protected function imageMouseOutHandler(e:MouseEvent):void{
			if(imageContainer.numChildren<=1){
				return;
			}
			zheZhao.visible=false;
			closeBtn.visible=false;
		}
		
		private function closeClickHandler(e:MouseEvent):void{
			if(!isHasData){
				return;
			}
			sendNotification("selectedImageCommand",{selectedPageIndex:pageIndex,selectedID:id,selectedData:data,updateType:"removeElement",imageType:"EditorEffectImage"});
		}
		
		
		public function initShow():void{
			pageIndex=0;
			id=0;
			data=null;
			if(imageContainer){
				while(imageContainer.numChildren>1){
					imageContainer.removeChildAt(1);
				}
			}
			if(imageLoading){
				imageLoading.visible=false;
			}
			if(closeBtn){
				closeBtn.visible=false;
			}
			if(zheZhao){
				zheZhao.visible=false;
			}
			if(nameTxt){
				nameTxt.text="";
				nameTxt.visible=false;
			}
			isActived=false;
			hasOverOutEventFlag=false;
		}
	}
}