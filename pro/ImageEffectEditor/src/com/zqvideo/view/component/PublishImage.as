package com.zqvideo.view.component
{
	import com.zqvideo.model.data.ZhuanMaState;
	import com.zqvideo.utils.ObjectUtils;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class PublishImage extends Image
	{
		private var selectMC:MovieClip;
		//private var zheZhao:MovieClip;
		private var publicBtn:SimpleButton;
		private var perTxt:TextField;
		private var transcodeMC:MovieClip;
		private var transcodeStatus:TextField;
		private var deleteMC:MovieClip;
		private var deleteBtn:SimpleButton;
		private var status:int=0;
		protected var bitmap:Bitmap;
		//protected var dragImage:Sprite;
		//protected var isDrag:Boolean=false;
		//private var delayTime:int=-1;
		
		private var _isSelected:Boolean=false;
		
		public function PublishImage()
		{
			super();
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			switch(event.currentTarget)
			{
				case publicBtn:
				case imageContainer:
				{
					if(status!=ZhuanMaState.FinishTransCode&&status!=ZhuanMaState.FastCoded){
						//转码或快编不成功
						return;
					}
					if(ExternalInterface.available){
						trace("publishMaterial",data.@FileKEY,data.@id);
						ExternalInterface.call("publishMaterial",data.@FileKEY.toString(),data.@id.toString());
						sendNotification("publishBtnClickCommand");
					}
					break;
				}
				
				case deleteBtn:
					sendNotification("panelShowCommand",{panelName:"DeleteAlertPanel",type:EditConfig.TYPE_CREATE,id:data.@id});
					break;
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
			
			/*if(value["zheZhao"]){
				zheZhao=value.getChildByName("zheZhao") as MovieClip;
				zheZhao.visible=false;
			}*/
			
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
			if(value["publicBtn"]){
				publicBtn=value.getChildByName("publicBtn") as SimpleButton;
				publicBtn.visible=false;
				publicBtn.mouseEnabled=false;
				//publicBtn.addEventListener(MouseEvent.CLICK,clickHandler);
			}
			
			perTxt=value.getChildByName("perTxt") as TextField;
			transcodeMC=value.getChildByName("transcodeMC") as MovieClip;
			transcodeStatus=transcodeMC["transcodeStatus"];
			deleteMC=value.getChildByName("deleteMC") as MovieClip;
			deleteBtn=deleteMC["deleteBtn"];
			
			initShow();
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
		override public function set data(value:XML):void{
			_data=value;
			if(!value){
				_isHasData=false;
				return;
			}
			_isHasData=true;
			
			initShow();
			
			if(value.@Name){
				imageName=value.@Name;
				if(nameTxt){
					nameTxt.visible=true;
					nameTxt.text=imageName;
				}
			}
			
			if(value.@IMG){
				imageUrl=value.@IMG;
				loadUrl(imageUrl);
			}
			
			status=int(data.@status);
			
			switch(status){
				case ZhuanMaState.ToTransCode:
					//loading
					imageLoading.visible=true;
					
					break;
				case ZhuanMaState.FinishTransCode:
					publicBtn.visible=true;
					break;
				case ZhuanMaState.FastCoding:
					//loading
					imageLoading.visible=true;
					break;
				case ZhuanMaState.FastCoded:
					publicBtn.visible=true;
					break;
				case ZhuanMaState.FailTransCode:
					transcodeMC.visible=true;
					transcodeStatus.text="转码失败";
					break;
				case ZhuanMaState.FailFastCoded:
					transcodeMC.visible=true;
					transcodeStatus.text="快编失败";
					break;
			}
			
			this.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			deleteBtn.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function overHandler(e:MouseEvent):void{
			deleteMC.visible=true;
		}
		
		private function outHandler(e:MouseEvent):void{
			deleteMC.visible=false;
		}
		
		override protected function imageInitHandler():void{
			
			if(status==ZhuanMaState.FinishTransCode||status==ZhuanMaState.FastCoded){
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
				imageContainer.addEventListener(MouseEvent.CLICK,clickHandler);
				//imageContainer.addEventListener(MouseEvent.MOUSE_OVER,imageMouseOverHandler);
				
			}
			
			close();
		}
		
		private function initShow():void{
			perTxt.visible=false;
			perTxt.text="0%";
			imageLoading.visible=false;
			transcodeMC.visible=false;
			publicBtn.visible=false;
			deleteMC.visible=false;
		}
		
		/*override protected function imageMouseOverHandler(e:MouseEvent):void{
			zheZhao.visible=true;
			zheZhao.buttonMode=true;
			this.addEventListener(MouseEvent.ROLL_OUT,imageMouseOutHandler);
			zheZhao.addEventListener(MouseEvent.MOUSE_DOWN,imageMouseDownHandler);
			
		}*/
		
		/*override protected function imageMouseOutHandler(e:MouseEvent):void{
			zheZhao.visible=false;
			zheZhao.buttonMode=false;
			this.removeEventListener(MouseEvent.ROLL_OUT,imageMouseOutHandler);
			//zheZhao.removeEventListener(MouseEvent.MOUSE_DOWN,imageMouseDownHandler);
		}*/
		
		/*private function imageMouseDownHandler(e:MouseEvent):void{
			//isDrag=false;
			delayTime=setTimeout(function():void{onImageMouseDown()},200);
			zheZhao.addEventListener(MouseEvent.MOUSE_UP,imageMouseUpHandler); 
		}*/
		
		/*private function imageMouseUpHandler(e:MouseEvent):void{
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
			imageMouseClickHandler(null);
		}*/
		
		/*private function onImageMouseDown():void{
			//isDrag=true;
			var dragBMP:Bitmap =new Bitmap(bitmap.bitmapData.clone());
			dragBMP.width=80;
			dragBMP.height=60;
			dragImage=new Sprite();
			dragImage.mouseChildren = false;
			dragImage.mouseEnabled = false;
			dragImage.addChild(dragBMP);
			Root.drag.doDrag(imageContainer,dragImage,data);
			dragImage.x=Root.stage.mouseX-dragImage.width/2;
			dragImage.y=Root.stage.mouseY-dragImage.height/2;
			ObjectUtils.gray(this, true);
			Root.editorContainer.mouseChildren=Root.editorContainer.mouseEnabled=false;
			Root.dragType=EditConfig.drag_image;
			Root.stage.addEventListener(MouseEvent.MOUSE_UP,imageMouseUpHandler);
			
		}*/
		
		public function updatePerShow(per:String):void{
			perTxt.text=per+"%";
		}
		
		public function updateLoseState():void{
			if(imageLoading.visible){
				imageLoading.visible=false;
				perTxt.text="";
			}
			transcodeMC.visible=true;
			transcodeStatus.text="转码失败";
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