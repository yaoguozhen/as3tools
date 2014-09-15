package com.zqvideo.view.component
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class HasSelectedImage extends Image
	{
		private var closeBtn:SimpleButton;
		private var zheZhao:MovieClip;
		
		public function HasSelectedImage()
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
				value.buttonMode=true;
				value.addEventListener(MouseEvent.MOUSE_OVER,imageMouseOverHandler);
				value.addEventListener(MouseEvent.MOUSE_OUT,imageMouseOutHandler);
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
			
			if(value["nameTxt"]){
				nameTxt=value.getChildByName("nameTxt") as TextField;
			}
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
				loader.content.width=imageContainer.width;
				loader.content.height=imageContainer.height;
				Bitmap(loader.content).smoothing=true;
				imageContainer.addChild(loader.content);
			}
			
			close();
		}
		
		override protected function imageMouseOverHandler(e:MouseEvent):void{
			zheZhao.visible=true;
			closeBtn.visible=true;
		}
		
		override protected function imageMouseOutHandler(e:MouseEvent):void{
			zheZhao.visible=false;
			closeBtn.visible=false;
		}
		
		private function closeClickHandler(e:MouseEvent):void{
			sendNotification("selectedImageCommand",{selectedPageIndex:pageIndex,selectedID:id,selectedData:data,updateType:"removeElement",imageType:"HomePageImage"});
		}
	}
}