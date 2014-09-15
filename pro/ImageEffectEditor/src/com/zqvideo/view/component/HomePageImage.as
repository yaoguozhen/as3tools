package com.zqvideo.view.component
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;

	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class HomePageImage extends Image
	{
		private var selectMC:MovieClip;
		private var zheZhao:MovieClip;
		
		private var _isSelected:Boolean=false;
		
		public function HomePageImage()
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
			
			if(value["selectMC"]){
				selectMC=value.getChildByName("selectMC") as MovieClip;
				selectMC.visible=false;
			}
			
			if(value["zheZhao"]){
				zheZhao=value.getChildByName("zheZhao") as MovieClip;
				zheZhao.visible=false;
			}
			
			if(value["container"]){
				imageContainer=value.getChildByName("container") as MovieClip;
			}
			
			if(value["loading"]){
				imageLoading=value.getChildByName("loading") as MovieClip;
				imageLoading.visible=false;
			}
			
			if(value["tipTxt"]){
				tipTxt=value.getChildByName("tipTxt") as TextField;
				tipTxt.visible=false;
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
			if(value==true){
				zheZhao.visible=true;
				zheZhao.removeEventListener(MouseEvent.MOUSE_OUT,imageMouseOutHandler);
				this.buttonMode=true;
				this.addEventListener(MouseEvent.CLICK,imageMouseClickHandler);
			}else{
				zheZhao.addEventListener(MouseEvent.MOUSE_OUT,imageMouseOutHandler);
				this.buttonMode=false;
			}
		}
		
		override protected function imageInitHandler():void{
			
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
				loader.content.width=imageContainer.width;
				loader.content.height=imageContainer.height;
				Bitmap(loader.content).smoothing=true;
				imageContainer.addChild(loader.content);
				imageContainer.buttonMode=true;
				imageContainer.addEventListener(MouseEvent.MOUSE_OVER,imageMouseOverHandler);
			}
			
			close();
		}
		
		override protected function imageMouseOverHandler(e:MouseEvent):void{
			zheZhao.visible=true;
			zheZhao.buttonMode=true;
			zheZhao.addEventListener(MouseEvent.MOUSE_OUT,imageMouseOutHandler);
			this.addEventListener(MouseEvent.CLICK,imageMouseClickHandler);
		}
		
		override protected function imageMouseOutHandler(e:MouseEvent):void{
			zheZhao.visible=false;
			zheZhao.buttonMode=false;
			zheZhao.removeEventListener(MouseEvent.MOUSE_OUT,imageMouseOutHandler);
			this.removeEventListener(MouseEvent.CLICK,imageMouseClickHandler);
		}
		
		override protected function imageMouseClickHandler(e:MouseEvent):void{
			trace(isSelected);
			if(isSelected){
				isSelected=false;
				sendNotification("selectedImageCommand",{selectedPageIndex:pageIndex,selectedID:id,selectedData:data,updateType:"removeElement",imageType:"HomePageImage"});
			}else{
				isSelected=true;
				sendNotification("selectedImageCommand",{selectedPageIndex:pageIndex,selectedID:id,selectedData:data,updateType:"addElement",imageType:"HomePageImage"});
			}
		}
	}
}