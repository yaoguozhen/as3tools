package com.zqvideo.view.component
{
	import com.zqvideo.utils.ObjectUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mvc.Command;
	import mvc.ICommand;
	
/*	import org.gif.events.GIFPlayerEvent;
	import org.gif.player.GIFPlayer;*/
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class EffectImage extends Image
	{
		protected var _effName:String="";
		protected var _effImgUrl:String="";
		protected var _effSwfUrl:String="";
		protected var _effDuration:Number=0;
		protected var bitmap:Bitmap;
		protected var animationMC:MovieClip;
		
		protected var zheZhao:MovieClip;
		protected var _effTransitionVec:Vector.<EffTransitionElement>=new Vector.<EffTransitionElement>();
		protected var dragImage:Sprite;
		protected var isDrag:Boolean=false;
		protected var delayTime:int=-1;
		public var sordID:int=0;
		
		//private var myGIFPlayer:GIFPlayer;
		
		public function EffectImage()
		{
			super();
		}
		
		/**
		 * 
		 * @param value
		 */
		override public function set data(value:XML):void{
			_data=value;
			if(!value){
				return;
			}
			
			if(value.@id){
				_id=int(value.@id);
			}
			
			if(value.@effectName){
				_effName=value.@effectName;
				//trace(">>>特效名字:"+_effName);
				if(nameTxt){
					nameTxt.text=_effName;
				}
			}
			
			if(value.@effectImgUrl){
				_effImgUrl=Root.assetsURL+value.@effectImgUrl;
				//loadUrl(_effImgUrl);
			}
			
			if(value.@effectSwfUrl){
				_effSwfUrl=Root.assetsURL+value.@effectSwfUrl;
			}
			trace("value:",_effImgUrl,_effSwfUrl)
		}
		/*
		override public function loadUrl(url:String):void
		{
			myGIFPlayer = new GIFPlayer();
			myGIFPlayer.addEventListener ( IOErrorEvent.IO_ERROR, onIOError );
			myGIFPlayer.addEventListener ( GIFPlayerEvent.COMPLETE, onCompleteGIFLoad );
			myGIFPlayer.load ( new URLRequest (url));
		}
		*/
		/*protected function onCompleteGIFLoad(event:Event):void
		{
			myGIFPlayer.removeEventListener ( IOErrorEvent.IO_ERROR, onIOError );
			myGIFPlayer.removeEventListener ( GIFPlayerEvent.COMPLETE, onCompleteGIFLoad );
			
			trace("gif 特效加载完毕")
			imageInitHandler()
		}
		
		protected function onIOError(event:Event):void
		{
			myGIFPlayer.removeEventListener ( IOErrorEvent.IO_ERROR, onIOError );
			myGIFPlayer.removeEventListener ( GIFPlayerEvent.COMPLETE, onCompleteGIFLoad );
			
			trace("特效gif加载失败")
		}*/
		
		/**
		 * 
		 * @return 
		 */
		public function get effName():String{
			return _effName;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get effImgUrl():String{
			return _effImgUrl;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get effSwfUrl():String{
			return _effSwfUrl;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get effDuration():Number{
			return _effDuration;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set effDuration(value:Number):void{
			_effDuration=value;
		}
		
		/**
		 * 
		 * @return 
		 */
		override public function get ui():MovieClip{
			return _ui;
		}
		
		/**
		 * 
		 * @param value
		 */
		override public function set ui(value:MovieClip):void{
			_ui=value;
			if(value){
				rootContainer.addChild(value);
			}
			
			if(value["container"]){
				imageContainer=value.getChildByName("container") as MovieClip;
			}
			
			if(value["loading"]){
				imageLoading=value.getChildByName("loading") as MovieClip;
				imageLoading.visible=false;
			}
			
			if(value["zheZhao"]){
				zheZhao=value.getChildByName("zheZhao") as MovieClip;
				zheZhao.visible=false;
			}
			
			if(value["tipTxt"]){
				tipTxt=value.getChildByName("tipTxt") as TextField;
				tipTxt.visible=false;
			}
			
			if(value["nameTxt"]){
				nameTxt=value.getChildByName("nameTxt") as TextField;
			}
		}
		
		public function get effTransitionVec():Vector.<EffTransitionElement>{
			return _effTransitionVec;
		}
		
		public function set effTransitionVec(value:Vector.<EffTransitionElement>):void{
			_effTransitionVec=value;
		}
		public function startLoad():void{
			loadUrl(_effImgUrl);
		}
		/**
		 * 
		 * @param e
		 */
		override protected function imageMouseOverHandler(e:MouseEvent):void{
			zheZhao.visible=true;
			zheZhao.buttonMode=true;
			this.addEventListener(MouseEvent.ROLL_OUT,imageMouseOutHandler);
			zheZhao.addEventListener(MouseEvent.MOUSE_DOWN,imageMouseDownHandler);
		}
		
		/**
		 * 
		 * @param e
		 */
		override protected function imageMouseOutHandler(e:MouseEvent):void{
			zheZhao.visible=false;
			zheZhao.buttonMode=false;
			this.removeEventListener(MouseEvent.ROLL_OUT,imageMouseOutHandler);
			zheZhao.removeEventListener(MouseEvent.MOUSE_DOWN,imageMouseDownHandler);
		}
		
		private function imageMouseDownHandler(e:MouseEvent):void{
			isDrag=false;
			//trace(delayTime);
			delayTime=setTimeout(function():void{onImageMouseDown()},200);
			zheZhao.addEventListener(MouseEvent.MOUSE_UP,imageMouseUpHandler);
		}
		
		private function onImageMouseDown():void{
			isDrag=true;
			var animationBitmap:BitmapData=new BitmapData(animationMC.width,animationMC.height);
			animationBitmap.draw(animationMC);
			var dragBMP:Bitmap =new Bitmap(animationBitmap);
			dragBMP.width=imageContainer.width;
			dragBMP.height=imageContainer.height;
			dragImage=new Sprite();
			dragImage.mouseChildren = false;
			dragImage.mouseEnabled = false;
			dragImage.addChild(dragBMP);
			Root.drag.doDrag(imageContainer,dragImage,data);
			dragImage.x=Root.stage.mouseX-dragImage.width/2;
			dragImage.y=Root.stage.mouseY-dragImage.height/2;
			ObjectUtils.gray(imageContainer, true);
			Root.editorContainer.mouseChildren=Root.editorContainer.mouseEnabled=false;
			Root.dragType=EditConfig.drag_transition;
			Root.stage.addEventListener(MouseEvent.MOUSE_UP,imageMouseUpHandler);
		}
		
		private function imageMouseUpHandler(e:MouseEvent):void{
			clearTimeout(delayTime);
			zheZhao.removeEventListener(MouseEvent.MOUSE_UP,imageMouseUpHandler);
			Root.stage.removeEventListener(MouseEvent.MOUSE_UP,imageMouseUpHandler);
			ObjectUtils.gray(imageContainer, false);
			Root.editorContainer.mouseChildren=Root.editorContainer.mouseEnabled=true;
			Root.dragType="";
			//trace(">>>isDrag:"+isDrag);
			/*if(!isDrag){
				trace("Click***************>");
				sendNotification("selectedEffectCommand",{panelName:"EditorPanel",updateType:"clickAddEffect",effData:data});
			}*/
		}
		override protected function imageLoadErrorHandler():void{
			imageLoading.visible=false;
			this.dispatchEvent(new Event("eff_complete"));
		}
		
		override protected function imageInitHandler():void{
			this.dispatchEvent(new Event("eff_complete"));
			
			if(imageLoading){
				imageLoading.stop();
				imageLoading.visible=false;
			}
			if(tipTxt){
				tipTxt.visible=false;
			}
			//UI里面有个容器背景层
			if(imageContainer.numChildren>1){
				imageContainer.removeChildAt(1);
			}
			if(imageContainer&&loader.content){
				/*bitmap=loader.content as Bitmap;
				bitmap.width=imageContainer.width;
				bitmap.height=imageContainer.height;
				bitmap.smoothing=true;*/
				
				animationMC=loader.content as MovieClip;
				animationMC.width=imageContainer.width;
				animationMC.height=imageContainer.height;
				imageContainer.addChild(animationMC);
				imageContainer.buttonMode=true;
				imageContainer.addEventListener(MouseEvent.ROLL_OVER,imageMouseOverHandler);
			}
			close();
		}
		/*override protected function close():void{
			try
			{
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,loadErrorHandler);
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,loadProgressHandler);
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadCompleteHandler);
				loader=null;
			} 
			catch(error:Error) 
			{
				trace(error);
				
			}
		}*/
	}
}