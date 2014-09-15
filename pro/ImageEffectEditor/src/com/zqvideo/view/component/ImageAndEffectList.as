package com.zqvideo.view.component
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.zqvideo.model.data.DataPoolManager;
	import com.zqvideo.utils.SkinManager;
	import com.zqvideo.view.YScrollBar;
	import com.zqvideo.view.YScrollBarEvent;
	import com.zqvideo.view.core.ComponentView;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class ImageAndEffectList extends ComponentView
	{
		private var pageIndex:int=1;
		private var totalPageNum:int=1;
		private var targetLoadPageIndex:int=0;
		private var listVec:Vector.<ImageList>=new Vector.<ImageList>();
		private var bg:Sprite;
		private const maxWidth:Number=600;
		private const maxHeight:Number=285;
		private var totalMaskSp:Sprite;
		private var imgMaskSp:Sprite;
		private var effMaskSp:Sprite;
		private var currentMaskSp:Sprite;
		
		private var totalContainer:Sprite;
		private var imageListContainer:Sprite;
		private var imageList:ImageList;
		private var effectBox:EffectArrangeBox;
		
		private var scrollBarMC:MovieClip;
		private var yScrollBar:YScrollBar;
		
		private var reflinePoint:Point;
		private var nextLoadFlag:Boolean=false;
		
		private var _selectListType:String=Root.SELECT_IMAGE;
		private var imageTween:TweenMax;
		private var effectTween:TweenMax;
		private var totalTween:TweenMax;
		private var imgScrollBarValue:Number=0;
		private var effScrollBarValue:Number=0;
		private var recordImgBarValue:Number=0;
		private var recordEffBarValue:Number=0;
		private var recordImgListY:Number=0;
		private var recordEffListY:Number=0;
		private var listDistanceY:Number=312;
		
		private var sp:Shape;
		public function ImageAndEffectList()
		{
			super();
		}
		
		override protected function addToStageShow():void{
			initShow();
		}
		
		private function initShow():void{
			bg=new Sprite();
			this.addChild(bg);
			bg.graphics.clear();
			bg.graphics.beginFill(0x0,0);
			bg.graphics.drawRect(0,0,maxWidth,maxHeight); 
			bg.graphics.endFill();
			//bg.visible=false;
			
			totalContainer=new Sprite();
			this.addChild(totalContainer);
			
			totalMaskSp=new Sprite();
			this.addChild(totalMaskSp);
			totalMaskSp.graphics.clear();
			totalMaskSp.graphics.beginFill(0x0,0.5);
			totalMaskSp.graphics.drawRect(0,0,maxWidth,maxHeight);
			totalMaskSp.graphics.endFill();
			
			totalContainer.mask=totalMaskSp;
			
			imageListContainer=new Sprite();
			
			var uploadBtnGroup:Sprite=creatUploadBtnGroup();
			totalContainer.addChild(uploadBtnGroup);
			totalContainer.addChild(imageListContainer);
			imageListContainer.name="imageList";
			
			imgMaskSp=new Sprite();
			totalContainer.addChild(imgMaskSp);
			imgMaskSp.graphics.clear();
			imgMaskSp.graphics.beginFill(0x0,0.5);
			imgMaskSp.graphics.drawRect(0,0,maxWidth,maxHeight);
			imgMaskSp.graphics.endFill();
			
			imageListContainer.mask=imgMaskSp;
			
			effectBox=new EffectArrangeBox();
			totalContainer.addChild(effectBox);
			effectBox.y=maxHeight;
			effectBox.name="effectList";
			
			effMaskSp=new Sprite();
			totalContainer.addChild(effMaskSp);
			effMaskSp.graphics.clear();
			effMaskSp.graphics.beginFill(0x0,0.5);
			effMaskSp.graphics.drawRect(0,0,maxWidth,maxHeight);
			effMaskSp.graphics.endFill();
			effMaskSp.y=maxHeight;
			
			effectBox.mask=effMaskSp;
						
			var refline:Sprite=new Sprite();
			this.addChild(refline);
			refline.graphics.clear();
			refline.graphics.beginFill(0xFF0000,1);
			refline.graphics.drawRect(0,0,totalMaskSp.width,1);
			refline.graphics.endFill();
			refline.y=totalMaskSp.y+totalMaskSp.height;
			refline.visible=false;
			reflinePoint=new Point(refline.x,refline.y);
			
			var scrollBarCls:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info,"ImageScrollBar");
			scrollBarMC=new scrollBarCls();
			this.addChild(scrollBarMC);
			scrollBarMC.x=totalMaskSp.x+totalMaskSp.width-5;
			yScrollBar=new YScrollBar();
			yScrollBar.addEventListener(YScrollBarEvent.VALUE_CHANGE,yScrollBarChangeHandler);
			
			
			showListByPageIndex(pageIndex);
			
			sp=new Shape();
			sp.graphics.clear();
			sp.graphics.beginFill(0xff0000);
			sp.graphics.drawCircle(0,0,10);
			sp.graphics.endFill();
			this.addChild(sp);
			sp.visible=false;
		}
		
		public function get effectArrangeBox():EffectArrangeBox{
			return effectBox;
		}
		
		public function get selectListType():String{
			return _selectListType;
		}
		
		public function set selectListType(value:String):void{
			_selectListType=value;
			sendNotification("imgAndEffSelectCommand",{hasSelected:true});
//			stopImgTween();
//			stopEffTween();
			stopTotalTween();
			imageListContainer.visible=effectBox.visible=true;
			if(_selectListType==Root.SELECT_IMAGE){
				recordEffBarValue=effScrollBarValue;
				recordEffListY=effectBox.y;
				totalTween=TweenMax.to(totalContainer,0.5,{y:0,onComplete:showList,onCompleteParams:["image"]});
			}else if(_selectListType==Root.SELECT_EFFECT){
				recordImgBarValue=imgScrollBarValue;
				recordImgListY=imageListContainer.y;
				totalTween=TweenMax.to(totalContainer,0.5,{y:-maxHeight,onComplete:showList,onCompleteParams:["effect"]});
			}
		}
		
		private function totalTweenComplete():void{
			sendNotification("imgAndEffSelectCommand",{hasSelected:false});
		}
		
		/*private function effMoveInit():void{
			
			effectBox.visible=true;
			effectBox.alpha=1;
			effectBox.y=reflinePoint.y-50;
		}*/
		
		/*private function imgMoveInit():void{
			
			imageListContainer.visible=true;
			imageListContainer.alpha=1;
			imageListContainer.y=-300;
		}*/
		
		/*private function hideList(type:String):void{
			if(type=="image"){
				stopImgTween();
				imageListContainer.visible=false;
				imageListContainer.alpha=1;
			}else if(type=="effect"){
				stopEffTween();
				effectBox.visible=false;
				effectBox.alpha=1;
			}
		}*/
		
		private function showList(type:String):void{
			stopTotalTween();
			
			if(type=="image"){
				imageListContainer.visible=true;
				effectBox.visible=false;
				setShowCurrentList(imageListContainer);
				yScrollBar.value=recordImgBarValue;
				//imageListContainer.y=recordImgListY;
				trace(",,,,"+recordImgListY);
			}else if(type=="effect"){
				trace("========+++++++++++++");
				imageListContainer.visible=false;
				effectBox.visible=true;
				setShowCurrentList(effectBox);
				yScrollBar.value=recordEffBarValue;
				//effectBox.y=recordEffListY;
			}
			sendNotification("imgAndEffSelectCommand",{hasSelected:false});
		}
		
		/*private function stopImgTween():void{
			if(imageTween){
				imageTween.pause();
				imageTween=null;
			}
		}*/
		
		/*private function stopEffTween():void{
			if(effectTween){
				effectTween.pause();
				effectTween=null;
			}
		}*/
		
		private function stopTotalTween():void{
			if(totalTween){
				totalTween.pause();
				totalTween=null;
			}
		}
		
		private function setShowCurrentList(list:Sprite):void{
			if(list.name=="imageList"){
				
				currentMaskSp=imgMaskSp;
			}else if(list.name=="effectList"){
				
				currentMaskSp=effMaskSp;
			}
			
			if(list.height>maxHeight){
				scrollBarMC.visible=true;
				yScrollBar.init(list,scrollBarMC,currentMaskSp.x,currentMaskSp.y,currentMaskSp.width,currentMaskSp.height);
				this.addEventListener(MouseEvent.MOUSE_WHEEL,scrollWheelHandler);
			}else{
				scrollBarMC.visible=false;
				this.removeEventListener(MouseEvent.MOUSE_WHEEL,scrollWheelHandler);
			}
		}
		
		private function scrollWheelHandler(evn:MouseEvent):void{
			if(evn.delta<0)
			{
				yScrollBar.scroll("up");
			}
			else
			{
				yScrollBar.scroll("down");
			}

		}
		
		private function yScrollBarChangeHandler(e:YScrollBarEvent):void{
			if(selectListType==Root.SELECT_IMAGE){
				imgScrollBarValue=e.value;
			}else{
				effScrollBarValue=e.value;
			}
			//trace(">>>,,,,"+e.value);
//			if(e.contentMoveDir=="down"||targetLoadPageIndex>totalPageNum){
//				return;
//			}
//			if(listVec[targetLoadPageIndex-1]){
//				var endList:ImageList=listVec[targetLoadPageIndex-1] as ImageList;
//				var globalPoint:Point=imageListContainer.localToGlobal(new Point(endList.x,endList.y));
//				var localPoint:Point=this.globalToLocal(globalPoint);
//				//trace(endList.y+"||"+localPoint.y+"||"+reflinePoint.y);
//				
//				sp.x=endList.x;
//				sp.y=endList.y;
//				if(localPoint.y<=reflinePoint.y){
//					//trace("XXXXXXXXXXXXXXXXXXXXXXXX:"+endList.pageIndex);
//					if(nextLoadFlag==true){
//						return;
//					}
//					showListByPageIndex(targetLoadPageIndex+1);
//					nextLoadFlag=true;
//				}
//			}
			
		}
		private function creatUploadBtnGroup():Sprite
		{
			var imageMCCls:Class;
			var img:MovieClip;
			var sp:Sprite=new Sprite();
			for(var i:uint=0;i<4;i++)
			{
				imageMCCls=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info, "NewImgSucai");
				img=new imageMCCls();
				img.loading.visible=false;
				//img.nameTxt.visible=false;
				img.nameTxt.text="上传图片"
				img.y=i*(img.height+1);
				sp.addChild(img);
			}
			sp.buttonMode=true;
			sp.addEventListener(MouseEvent.CLICK,uploadBtnClickHandler);
			return sp;
		}
		
		private function uploadBtnClickHandler(event:MouseEvent):void
		{
			navigateToURL(new URLRequest(Root.toUplaod),"_self");
		}
		private function showListByPageIndex($pageIndex:int):void{
			if(listVec.length>=totalPageNum||$pageIndex>totalPageNum){
				return;
			}
			imageList=new ImageList();
			imageListContainer.addChild(imageList);
			imageList.y=($pageIndex-1)*listDistanceY;
			listVec.push(imageList);
			setShowCurrentList(imageListContainer);
			sendNotification("updateDataCommand",{dataType:"EDITOR_PAGE_FENYE",pageNum:$pageIndex,imgNum:Root.EDITORPAGE_IMAGE_SHOWNUM,panelName:"EditorPanel"});
		}
		
		public function updateListByData(obj:Object):void{
			var xml:XML=obj.xml;
			//trace("分页数据:"+xml.toString());
			totalPageNum=int(xml.@TotalPage);
			pageIndex=int(xml.@Page);
			//trace("loaded pageIndex:"+pageIndex+"||"+"totalPageNum:"+totalPageNum);
			nextLoadFlag=false;
			if(listVec[pageIndex-1]==null){
				return;
			}
			listVec[pageIndex-1].pageIndex=pageIndex;
			listVec[pageIndex-1].xmlNodeName="img";
			listVec[pageIndex-1].data=xml;
			//trace("oldIndex:"+targetLoadPageIndex);
			/*if(targetLoadPageIndex>=pageIndex){
				return;
			}*/
			targetLoadPageIndex=pageIndex+1;
			//trace("newIndex:"+targetLoadPageIndex);
			if(targetLoadPageIndex<=totalPageNum){
				showListByPageIndex(targetLoadPageIndex);
			}
		}
	}
}