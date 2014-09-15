package com.zqvideo.view.component
{
	import com.zqvideo.utils.ObjectUtils;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class ShowSuCaiImage extends Image
	{
		protected var bitmap:Bitmap;
		protected var dragImage:Sprite;
		protected var isDrag:Boolean=false;
		private var delayTime:int=-1;
		private var _totalDataObj:Object={};
		public var sordID:int=0;
		public function ShowSuCaiImage()
		{
			super();
		}
		
		public function get totalDataObj():Object{
			return _totalDataObj;
		}
		
		public function set totalDataObj(value:Object):void{
			_totalDataObj=value;
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
				/*if(nameTxt){
					nameTxt.visible=true;
					nameTxt.text=imageName;
				}*/
			}
			
			if(value.@IMGUrl){
				imageUrl=value.@IMGUrl;
			}
		}
		
		public function startLoad():void{
			loadUrl(imageUrl);
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
			
			if(value["container"]){
				imageContainer=value.getChildByName("container") as MovieClip;
			}
			
			
			if(value["nameTxt"]){
				nameTxt=value.getChildByName("nameTxt") as TextField;
				nameTxt.visible=false;
			}
			
			rootContainer.buttonMode=true;
			rootContainer.addEventListener(MouseEvent.CLICK,rootClickHandler);
		}
		
		override protected function imageLoadErrorHandler():void{
			imageLoading.visible=false;
			rootContainer.buttonMode=false
			this.dispatchEvent(new Event("img_complete"));
		}
		override protected function imageInitHandler():void{
			this.dispatchEvent(new Event("img_complete"));
			
			if(imageLoading){
				imageLoading.stop();
				imageLoading.visible=false;
			}
			
			//UI里面有个容器背景层
			if(imageContainer.numChildren>1){
				imageContainer.removeChildAt(1);
			}
			
			if(imageContainer&&loader.content){
				bitmap=loader.content as Bitmap;
				bitmap.width=imageContainer.width;
				bitmap.height=imageContainer.height;
				bitmap.smoothing=true;
				imageContainer.addChild(bitmap);
				imageContainer.buttonMode=true;
				imageContainer.addEventListener(MouseEvent.MOUSE_DOWN,imageMouseDownHandler);
			}
			
			rootContainer.buttonMode=false;
			rootContainer.removeEventListener(MouseEvent.CLICK,rootClickHandler);
			
			close();
		}
		
		/*override protected function imageMouseOverHandler(e:MouseEvent):void{
			zheZhao.visible=true;
			zheZhao.buttonMode=true;
			this.addEventListener(MouseEvent.ROLL_OUT,imageMouseOutHandler);
			zheZhao.addEventListener(MouseEvent.MOUSE_DOWN,imageMouseDownHandler);
			
		}
		
		override protected function imageMouseOutHandler(e:MouseEvent):void{
			zheZhao.visible=false;
			zheZhao.buttonMode=false;
			this.removeEventListener(MouseEvent.ROLL_OUT,imageMouseOutHandler);
			zheZhao.removeEventListener(MouseEvent.MOUSE_DOWN,imageMouseDownHandler);
		}*/
		
		private function imageMouseDownHandler(e:MouseEvent):void{
			isDrag=false;
			delayTime=setTimeout(function():void{onImageMouseDown()},200);
			imageContainer.addEventListener(MouseEvent.MOUSE_UP,imageMouseUpHandler); 
		}
		
		private function imageMouseUpHandler(e:MouseEvent):void{
			clearTimeout(delayTime);
			imageContainer.removeEventListener(MouseEvent.MOUSE_UP,imageMouseUpHandler);
			Root.stage.removeEventListener(MouseEvent.MOUSE_UP,imageMouseUpHandler);
			ObjectUtils.gray(this, false);
			Root.editorContainer.mouseChildren=Root.editorContainer.mouseEnabled=true;
			Root.dragType="";
			//trace(">>>isDrag:"+isDrag);
			/*if(!isDrag){
				trace("Click***************>");
				imageMouseClickHandler(null);
			}*/
		}
		
		private function onImageMouseDown():void{
			isDrag=true;
			var dragBMP:Bitmap =new Bitmap(bitmap.bitmapData.clone());
			dragBMP.width=80;
			dragBMP.height=60;
			dragImage=new Sprite();
			dragImage.mouseChildren = false;
			dragImage.mouseEnabled = false;
			dragImage.addChild(dragBMP);
			Root.drag.doDrag(imageContainer,dragImage,totalDataObj);
			dragImage.x=Root.stage.mouseX-dragImage.width/2;
			dragImage.y=Root.stage.mouseY-dragImage.height/2;
			ObjectUtils.gray(this, true);
			Root.editorContainer.mouseChildren=Root.editorContainer.mouseEnabled=false;
			Root.dragType=EditConfig.drag_image;
			Root.stage.addEventListener(MouseEvent.MOUSE_UP,imageMouseUpHandler);
			
		}
		
		/*override protected function imageMouseClickHandler(e:MouseEvent):void{
			if(isSelected){
				isSelected=false;
				sendNotification("selectedImageCommand",{selectedPageIndex:pageIndex,selectedID:id,selectedData:data,updateType:"removeElement",imageType:"EditorEffectImage"});
			}else{
				isSelected=true;
				sendNotification("selectedImageCommand",{selectedPageIndex:pageIndex,selectedID:id,selectedData:data,updateType:"addElement",imageType:"EditorEffectImage"});
			}
		}*/
		
		private function rootClickHandler(e:MouseEvent):void{
			if(data){
				return;
			}
			
			navigateToURL(new URLRequest(Root.toUplaod),"_self");
		}
		
	}
}