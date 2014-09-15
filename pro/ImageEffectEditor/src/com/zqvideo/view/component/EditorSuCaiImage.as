package com.zqvideo.view.component
{
	import com.zqvideo.utils.ObjectUtils;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class EditorSuCaiImage extends Image
	{
		private var selectMC:MovieClip;
		private var zheZhao:MovieClip;
		protected var bitmap:Bitmap;
		protected var dragImage:Sprite;
		protected var isDrag:Boolean=false;
		private var delayTime:int=-1;
		
		private var _isSelected:Boolean=false;
		
		public function EditorSuCaiImage()
		{
			super();
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
			
			if(value["zheZhao"]){
				zheZhao=value.getChildByName("zheZhao") as MovieClip;
				zheZhao.visible=false;
			}
			
			if(value["container"]){
				imageContainer=value.getChildByName("container") as MovieClip;
			}
			
			if(value["selectMC"]){
				selectMC=value.getChildByName("selectMC") as MovieClip;
				selectMC.visible=false;
			}
			
			if(value["nameTxt"]){
				nameTxt=value.getChildByName("nameTxt") as TextField;
			}
		}
		/**
		 * 
		 * @return 
		 */
		public function get isSelected():Boolean{
			return _isSelected;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set isSelected(value:Boolean):void{
			_isSelected=value;
			selectMC.visible=value;
		}
		
		override protected function imageInitHandler():void{
			
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
				imageContainer.addEventListener(MouseEvent.MOUSE_OVER,imageMouseOverHandler);
			}
			
			close();
		}
		
		override protected function imageMouseOverHandler(e:MouseEvent):void{
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
		}
		
		private function imageMouseDownHandler(e:MouseEvent):void{
			isDrag=false;
			delayTime=setTimeout(function():void{onImageMouseDown()},200);
			zheZhao.addEventListener(MouseEvent.MOUSE_UP,imageMouseUpHandler); 
		}
		
		private function imageMouseUpHandler(e:MouseEvent):void{
			clearTimeout(delayTime);
			zheZhao.removeEventListener(MouseEvent.MOUSE_UP,imageMouseUpHandler);
			Root.stage.removeEventListener(MouseEvent.MOUSE_UP,imageMouseUpHandler);
			ObjectUtils.gray(this, false);
			Root.editorContainer.mouseChildren=Root.editorContainer.mouseEnabled=true;
			Root.dragType="";
			//trace(">>>isDrag:"+isDrag);
			if(!isDrag){
				trace("Click***************>");
				imageMouseClickHandler(null);
			}
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
			Root.drag.doDrag(imageContainer,dragImage,{selectedPageIndex:pageIndex,selectedID:id,selectedData:data});
			dragImage.x=Root.stage.mouseX-dragImage.width/2;
			dragImage.y=Root.stage.mouseY-dragImage.height/2;
			ObjectUtils.gray(this, true);
			Root.editorContainer.mouseChildren=Root.editorContainer.mouseEnabled=false;
			Root.dragType=EditConfig.drag_image;
			Root.stage.addEventListener(MouseEvent.MOUSE_UP,imageMouseUpHandler);
			
		}
		
		override protected function imageMouseClickHandler(e:MouseEvent):void{
			if(isSelected){
				isSelected=false;
				sendNotification("selectedImageCommand",{selectedPageIndex:pageIndex,selectedID:id,selectedData:data,updateType:"removeElement",imageType:"EditorEffectImage"});
			}else{
				isSelected=true;
				sendNotification("selectedImageCommand",{selectedPageIndex:pageIndex,selectedID:id,selectedData:data,updateType:"addElement",imageType:"EditorEffectImage"});
			}
		}
	}
}