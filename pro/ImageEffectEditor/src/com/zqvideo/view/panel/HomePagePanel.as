package com.zqvideo.view.panel
{
	import com.greensock.TweenMax;
	import com.zqvideo.model.data.DataEvent;
	import com.zqvideo.model.data.DataPoolManager;
	import com.zqvideo.utils.SkinManager;
	import com.zqvideo.view.LayerManager;
	import com.zqvideo.view.component.BiaoDianBox;
	import com.zqvideo.view.component.HasSelectedImageBox;
	import com.zqvideo.view.component.HomePageImage;
	import com.zqvideo.view.component.ImageArrangeBox;
	import com.zqvideo.view.core.PanelView;
	import com.zqvideo.view.core.View;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class HomePagePanel extends PanelView
	{
		private var pageIndex:int=1;
		private var homePageBg:MovieClip;
		private var imageContainerOne:Sprite;
		private var imageContainerTwo:Sprite;
		private var totalImageContainer:Sprite;
		private var containerMask:Sprite;
		private var currentImageContainer:Sprite;
		private var oldImageContainer:Sprite;
		private var imageArrangeBox:ImageArrangeBox;
		private var arrangeImageNum:int=10;
		private var leftBtn:SimpleButton;
		private var rightBtn:SimpleButton;
		private var editorBtn:SimpleButton;
		private var yiXuanTxt:TextField;
		private var biaoDianBox:BiaoDianBox;
		private var hasSelectedImageBox:HasSelectedImageBox;
		
		private var containerOneTween:TweenMax;
		private var containerTwoTween:TweenMax;
		private var direction:String="";
		
		private var maskWidth:Number=855;
		private var maskHeight:Number=430;
		
		private var timeID:int=-1;
		
		
		public function HomePagePanel()
		{
			module=new MovieClip();
			layer=LayerManager.addToLayer(this,module);
			
			super();
		}
		
		override protected function addToStageShow():void{
			/*var bgCls:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info, "BackGround");
			homePageBg=new bgCls();
			module.addChild(homePageBg);
			
			leftBtn=homePageBg.getChildByName("leftBtn") as SimpleButton;
			rightBtn=homePageBg.getChildByName("rightBtn") as SimpleButton;
			editorBtn=homePageBg.getChildByName("editorBtn") as SimpleButton;
			yiXuanTxt=homePageBg.getChildByName("yiXuanTxt") as TextField;
			
			totalImageContainer=new Sprite();
			module.addChild(totalImageContainer);
			
			containerMask=new Sprite();
			module.addChild(containerMask);
			containerMask.graphics.clear();
			containerMask.graphics.beginFill(0x000000,1);
			containerMask.graphics.drawRect(0,0,maskWidth,maskHeight);
			containerMask.graphics.endFill();
			containerMask.x=totalImageContainer.x;
			containerMask.y=totalImageContainer.y;
			totalImageContainer.mask=containerMask;
			
			imageContainerOne=new Sprite();
			imageContainerTwo=new Sprite();
			totalImageContainer.addChild(imageContainerOne); 
			totalImageContainer.addChild(imageContainerTwo);
			
			biaoDianBox=new BiaoDianBox();
			module.addChild(biaoDianBox);
			
			hasSelectedImageBox=new HasSelectedImageBox();
			module.addChild(hasSelectedImageBox);
			hasSelectedImageBox.x=yiXuanTxt.x+yiXuanTxt.width+10;
			hasSelectedImageBox.y=yiXuanTxt.y-yiXuanTxt.height/2;
			
			sendNotification("updateDataCommand",{dataType:"HOME_PAGE_FENYE",pageNum:pageIndex,imgNum:Root.HOMEPAGE_IMAGE_SHOWNUM,panelName:"HomePagePanel"});*/
	
		}
		
		override protected function addEvents():void{
			/*leftBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			rightBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			editorBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			biaoDianBox.addEventListener(DataEvent.SELECT_POINT,selectPointHandler);*/
		}
		
		override protected function removeEvents():void{
			/*leftBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			rightBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			editorBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			biaoDianBox.removeEventListener(DataEvent.SELECT_POINT,selectPointHandler);*/
		}
		
		override public function initShowView():void{
			layer.visible=false;
		}
		
		override public function resetShowView():void{
			
		}
		
		override public function destory():void{
			while(module.numChildren>0){
				module.removeChildAt(0);
			}
			
		}
		
		private function btnClickHandler(e:MouseEvent):void{
			switch(e.currentTarget.name){
				/*case "leftBtn":
					if(pageIndex<=1){
						return;
					}else{
						sendNotification("panelShowCommand",{panelName:"LoadingPanel"});
						direction="left";
						pageIndex--;
						updateBiaoDianShow(pageIndex);
						callFunctionLater(sendNotificationFunc);
					}
					break;
				
				case "rightBtn":
					if(pageIndex>=Root.homeImageTotalPage){
						return;
					}else{
						sendNotification("panelShowCommand",{panelName:"LoadingPanel"});
						direction="right";
						pageIndex++;
						updateBiaoDianShow(pageIndex);
						callFunctionLater(sendNotificationFunc);
					}
					break;
				
				case "editorBtn":
					if(hasSelectedImageBox.hasSelectedImageData.length<Root.MAX_SELECT_NUM){
						sendNotification("panelShowCommand",{panelName:"AlertPanel",alertContent:Root.LANGUAGE_DATA.selectMinWarn[0]});
					}else{
						DataPoolManager.getInstance().hasSelectedImageData=hasSelectedImageBox.hasSelectedImageData;
						sendNotification("panelShowCommand",{panelName:"EditorPanel"});
					}
					break;*/
			}
		}
		
		private function callFunctionLater(func:Function):void{
			timeID=setTimeout(func,500);
		}
		
		private function sendNotificationFunc():void{
			if(timeID){
				clearTimeout(timeID);
			}
			sendNotification("updateDataCommand",{dataType:"HOME_PAGE_FENYE",pageNum:pageIndex,imgNum:Root.HOMEPAGE_IMAGE_SHOWNUM,panelName:"HomePagePanel"});
		}
		
		private function selectPointHandler(e:DataEvent):void{
			sendNotification("panelShowCommand",{panelName:"LoadingPanel"});
			direction=e.obj.direction;
			pageIndex=e.obj.pageIndex;
			callFunctionLater(sendNotificationFunc);
		}
		
		override public function updatePanel(updateObj:Object):void{
			sendNotification("panelHideCommand",{panelName:"LoadingPanel"});
			var type:String=updateObj.dataType;
			
			switch(type){
				case "HOME_PAGE_FENYE":
					createContainerByXml(updateObj.xml);
					trace("HomePage:"+updateObj.xml.toXMLString());
					break;
			}
		}
		
		private function createContainerByXml(data:XML):void{
			if(currentImageContainer==null){
				currentImageContainer=imageContainerOne;
				oldImageContainer=imageContainerOne;
				imageContainerShowByXml(data);
				Root.homeImageTotalPage=data.@TotalPage;
				biaoDianBox.totalNum=Root.homeImageTotalPage;
				biaoDianBox.x=(homePageBg.width-biaoDianBox.width)/2;
				biaoDianBox.y=totalImageContainer.y+totalImageContainer.height+10;
			}else{
				if(direction=="left"){
					tweenMove("left",data);
				}else{
					tweenMove("right",data);
					
				}
			}
		}
		
		private function tweenMove($direction:String,$data:XML):void{
			if(currentImageContainer==imageContainerOne){
				oldImageContainer=imageContainerOne;
				currentImageContainer=imageContainerTwo;
			}else{
				oldImageContainer=imageContainerTwo;
				currentImageContainer=imageContainerOne;
			}
			
			if($direction=="left"){
				imageContainerShowByXml($data);
				currentImageContainer.x=oldImageContainer.x+oldImageContainer.width+15;
				containerOneTween=TweenMax.to(oldImageContainer,1,{x:oldImageContainer.x-oldImageContainer.width-15,onComplete:tweenOneComplete});
				containerTwoTween=TweenMax.to(currentImageContainer,1,{x:currentImageContainer.x-currentImageContainer.width-15,onComplete:tweenTwoComplete});
			}else{
				imageContainerShowByXml($data);
				currentImageContainer.x=oldImageContainer.x-oldImageContainer.width-15;
				containerOneTween=TweenMax.to(oldImageContainer,1,{x:oldImageContainer.x+oldImageContainer.width+15,onComplete:tweenOneComplete});
				containerTwoTween=TweenMax.to(currentImageContainer,1,{x:currentImageContainer.x+currentImageContainer.width+15,onComplete:tweenTwoComplete});
			}
		}
		
		private function imageContainerShowByXml($data:XML):void{
			while(currentImageContainer.numChildren>0){
				currentImageContainer.removeChildAt(0);
			}
			
			imageArrangeBox=new ImageArrangeBox();
			currentImageContainer.addChild(imageArrangeBox);
			imageArrangeBox.pageIndex=pageIndex;
			imageArrangeBox.imageType="HomePageImage";
			imageArrangeBox.arrangeDirection="Horizontal";
			imageArrangeBox.arrangeImageNum=arrangeImageNum;
			imageArrangeBox.xmlNodeName="img";
			imageArrangeBox.data=$data;
			
			imageArrangeBox.addImageSelectedStatus(hasSelectedImageBox.hasSelectedImageData);
			
			totalImageContainer.x=((rightBtn.x-leftBtn.x+leftBtn.width)-imageArrangeBox.width)/2;
			totalImageContainer.y=(homePageBg.height-imageArrangeBox.height)/2-20;
			
			containerMask.x=totalImageContainer.x;
			containerMask.y=totalImageContainer.y;
			totalImageContainer.mask=containerMask;
			
		}
		
		private function tweenOneComplete():void{
			if(containerOneTween){
				if(currentImageContainer!=imageContainerOne){
					while(imageContainerOne.numChildren>0){
						imageContainerOne.removeChildAt(0);
					}
				}
				containerOneTween.pause();
				containerOneTween=null;
			}
		}
		
		private function tweenTwoComplete():void{
			if(containerTwoTween){
				if(currentImageContainer!=imageContainerTwo){
					while(imageContainerTwo.numChildren>0){
						imageContainerTwo.removeChildAt(0);
					}
				}
				containerTwoTween.pause();
				containerTwoTween=null;
			}
		}
		
		private function updateBiaoDianShow($index:int):void{
			biaoDianBox.updateBiaoDianShow($index-1,direction);
		}
		
		public function updateSelectedImageBox(selectedData:Object):void{
			if(selectedData.imageType!="HomePageImage"){
				return;
			}
			
			if(selectedData.updateType=="addElement"){
				if(hasSelectedImageBox.hasSelectedImageData.length>=Root.MAX_SELECT_NUM){
					sendNotification("panelShowCommand",{panelName:"AlertPanel",alertContent:Root.LANGUAGE_DATA.selectMaxWarn[0]});
					if(imageArrangeBox){
						imageArrangeBox.removeImageSelectedStatus(selectedData);
					}
				}else{
					hasSelectedImageBox.addSelectedElement(selectedData);
				}
				
			}else{
				if(hasSelectedImageBox.hasSelectedImageData.length<=0){
					return;
				}else{
					hasSelectedImageBox.removeSelectedElement(selectedData);
					if(imageArrangeBox){
						imageArrangeBox.removeImageSelectedStatus(selectedData);
					}
				}
			}
		}
	}
}