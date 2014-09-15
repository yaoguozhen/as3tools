package com.zqvideo.view.component
{
	import com.zqvideo.event.DragEvent;
	import com.zqvideo.model.data.DataPoolManager;
	import com.zqvideo.utils.SkinManager;
	import com.zqvideo.view.YTip;
	import com.zqvideo.view.core.ComponentView;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mvc.Command;
	import mvc.ICommand;
	
	public class EditorImageAndEffectBox extends ComponentView
	{
		private const MAX_IMAGE_NUM:int=6;
		private const MAX_EFFECT_NUM:int=5;
		private var imageDistance:Number=0;
		private var effTransitionDistance:Number=0;
		private var _imageVec:Vector.<EditorEffectImage>=new Vector.<EditorEffectImage>();
		private var _effTransitionVec:Vector.<EffTransitionElement>=new Vector.<EffTransitionElement>();
		private var _hasSelectedImageData:Vector.<Object>=new Vector.<Object>();
		private var _hasSelectedEffectData:Vector.<Object>=new Vector.<Object>();
		private var effectViewID:int;
		private var effectPlayImageUrlArr:Array=[];
		private var effectSwfUrl:String="";
		
		private var _inputData:XML;
		private var timeID:int=-1;
		
		private var currentDragImg:EditorEffectImage;
		private var currentDragTran:EffTransitionElement;
		
		
		public function EditorImageAndEffectBox()
		{
			super();
		}
		
		override protected function addToStageShow():void{
			this.addChild(rootContainer);
			var imageExample:EditorEffectImage=new EditorEffectImage();
			var imageCls:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info,"EditorImageContainer");
			imageExample.ui=new imageCls();
			effTransitionDistance=imageExample.width;
			var effTransitionExample:EffTransitionElement=new EffTransitionElement();
			imageDistance=effTransitionExample.width;
			//trace(imageDistance+"||"+effTransitionDistance);
			
			for(var i:int=0;i<MAX_IMAGE_NUM;i++){
				var image:EditorEffectImage=new EditorEffectImage();
				image.ui=new imageCls();
				image.arrangeID=i;
				image.x=i*(image.width+imageDistance);
				rootContainer.addChild(image);
				image.addEventListener(DragEvent.DRAG_DROP,dragDropHandler);
				_imageVec.push(image);
			}
			
			var effTransitionOffSetX:Number=effTransitionDistance;
			for(var j:int=0;j<MAX_EFFECT_NUM;j++){
				var effTransition:EffTransitionElement=new EffTransitionElement();
				effTransition.arrangeID=j;
				effTransition.x=effTransitionOffSetX+j*(effTransition.width+effTransitionDistance);
				rootContainer.addChild(effTransition);
				effTransition.addEventListener(DragEvent.DRAG_DROP,dragDropHandler);
				_effTransitionVec.push(effTransition);
			}
			
			Root.stage.addEventListener(DragEvent.GLOBAL_DRAG_ING,dragIngHandler);
			Root.stage.addEventListener(DragEvent.GLOBAL_DRAG_OTHER,dragOtherHandler);
		}
		
		private function dragOtherHandler(e:DragEvent):void{
			if(currentDragImg){
				currentDragImg.hasOverOutEventFlag=true;
				currentDragImg.isActived=false;
				currentDragImg=null;
			}
			if(currentDragTran){
				currentDragTran.isActived=false;
				currentDragTran=null;
			}
		}
		
		private function dragIngHandler(e:DragEvent):void{
			if(Root.dragType==EditConfig.drag_image){
				if(currentDragImg){
					currentDragImg.hasOverOutEventFlag=true;
					currentDragImg.isActived=false;
					currentDragImg=null;
				}
				if(e.dropTarget is EditorEffectImage){
					
					currentDragImg=EditorEffectImage(e.dropTarget);
					currentDragImg.hasOverOutEventFlag=false;
					currentDragImg.isActived=true;
				}
				
			}else if(Root.dragType==EditConfig.drag_transition){
				if(currentDragTran){
					currentDragTran.isActived=false;
					currentDragTran=null;
				}
				if(e.dropTarget is EffTransitionElement){
					currentDragTran=EffTransitionElement(e.dropTarget);
					currentDragTran.isActived=true;
				}
			}
		}
		
		private function dragDropHandler(e:DragEvent):void{
			trace(">>>DragEvent.DRAG_DROP");
			
			if(Root.dragType==EditConfig.drag_image){
				if(e.dropTarget is EditorEffectImage){
					currentDragImg=e.dropTarget as EditorEffectImage;
					//trace(">>>currentDragImg.arrangeID:"+currentDragImg.arrangeID);
					//trace(">>>hasSelectedImageData.length:"+hasSelectedImageData.length);
					if(isDragTheLastViewImage(currentDragImg.arrangeID)==false){
						var rightActiveIndex:int=hasSelectedImageData.length;
						if(rightActiveIndex<0){
							rightActiveIndex=0;
						}
						imageVec[rightActiveIndex].isShanDong=true;
						currentDragImg.isActived=false;
						return;
					}
					var obj:Object=e.data;
					currentDragImg.isActived=false;
					currentDragImg.isShanDong=false;
					currentDragImg.data=obj.selectedData;
					currentDragImg.pageIndex=obj.selectedPageIndex;
					currentDragImg.id=obj.selectedID;
					currentDragImg.hasOverOutEventFlag=true;
					Root.isImageDiaoHuan=false;
					updateSelectedImageData();
				}
			}else if(Root.dragType==EditConfig.drag_transition){
				if(e.dropTarget is EffTransitionElement){
					currentDragTran=e.dropTarget as EffTransitionElement;
					if(isHasTwoViewImage(currentDragTran.arrangeID)==false){
						var tipPosition:Point=new Point(currentDragTran.x+currentDragTran.width/2,currentDragTran.y-10);
						var globalPosition:Point=currentDragTran.parent.localToGlobal(tipPosition);
						//trace("globalPosition:"+globalPosition.x+"||"+globalPosition.y);
						var paramObj:Object=new Object();
						paramObj.point=globalPosition;
						YTip.getInstance().show(Root.LANGUAGE_DATA.mustTwoImage[0],"3",paramObj,true);
						currentDragTran.isActived=false;
						return;
					}
					var xml:XML=e.data as XML;
					currentDragTran.data=xml;
					currentDragTran.isActived=false;
					updateSelectedEffectData();
				}
			}
			
			Root.editorContainer.mouseChildren=Root.editorContainer.mouseEnabled=true;
		}
		
		public function initSelectedImageShow():void{
			
			/*for(var i:int=0;i<DataPoolManager.getInstance().hasSelectedImageData.length;i++){
				var _pageIndex:int=DataPoolManager.getInstance().hasSelectedImageData[i].pageIndex;
				var _id:int=DataPoolManager.getInstance().hasSelectedImageData[i].id;
				var _data:XML=DataPoolManager.getInstance().hasSelectedImageData[i].data;
				//trace(data.toXMLString()+"***************************>");
				var obj:Object={pageIndex:_pageIndex,id:_id,data:_data};
				_hasSelectedImageData.push(obj);
				imageVec[i].pageIndex=_pageIndex;
				imageVec[i].id=_id;
				imageVec[i].data=_data;
				trace(">>>编辑页面初始化选择图片:"+imageVec[i].pageIndex+"||"+imageVec[i].id+"||"+imageVec[i].data);
			}*/
				
			//currentDragImg=imageVec[0];
			
			
			for(var j:int=0;j<effTransitionVec.length;j++){
				effTransitionVec[j].moRenData=DataPoolManager.getInstance().moRenEffectData;
			}
			
			//effectPlay(0);
		}
		
		/**
		 * 
		 * @param selectedObj
		 */
		public function addSelectedElement(selectedObj:Object):void{
			if(hasSelectedImageData.length>=Root.MAX_SELECT_NUM){
				return;
			}
			for(var i:int=0;i<imageVec.length;i++){
				
				if(!imageVec[i].isHasData){
					var _pageIndex:int=selectedObj.selectedPageIndex;
					var _id:int=selectedObj.selectedID;
					var _data:XML=selectedObj.selectedData;
					var obj:Object={pageIndex:_pageIndex,id:_id,data:_data};
					imageVec[i].pageIndex=_pageIndex;
					imageVec[i].id=_id;
					imageVec[i].data=_data;
					break;
				}
			}
			Root.isImageDiaoHuan=false;
			updateSelectedImageData();
		}
		
		/**
		 * 
		 * @param selectedObj
		 */
		public function removeSelectedElement(selectedObj:Object):void{
			trace(">>>原始删除数据:"+selectedObj.selectedPageIndex+"||"+selectedObj.selectedID);
			
			for(var i:int=0;i<hasSelectedImageData.length;i++){ 
				var obj:Object=hasSelectedImageData[i] as Object;
				if(obj.pageIndex==selectedObj.selectedPageIndex&&obj.id==selectedObj.selectedID){
					hasSelectedImageData.splice(i,1);
					break;
				}
			}
			
			//缩进
			for(var j:int=0;j<imageVec.length;j++){
				imageVec[j].initShow();
			}
			
			for(var k:int=0;k<hasSelectedImageData.length;k++){
				imageVec[k].pageIndex=hasSelectedImageData[k].pageIndex;
				imageVec[k].id=hasSelectedImageData[k].id;
				imageVec[k].data=hasSelectedImageData[k].data;
			}
			
			
			//不缩进
			/*for(var j:int=0;j<imageVec.length;j++){
				var img:EditorEffectImage=imageVec[j] as EditorEffectImage;
				if(img.pageIndex==selectedObj.selectedPageIndex&&img.id==selectedObj.selectedID){
					img.initShow();
					break;
				}
			}*/
			Root.isImageDiaoHuan=false;
			updateSelectedImageData();
		}
		
		public function tiaoHuanSelectedElement(idObj:Object):void{
			var preID:int=idObj.preID;
			var nextID:int=idObj.nextID;
			
			if(!imageVec[preID].isHasData||!imageVec[nextID].isHasData){
				return;
			}
			
			var prePageIndex:int=imageVec[preID].pageIndex;
			var pre_ID:int=imageVec[preID].id;
			var preData:XML=imageVec[preID].data;
			
			var nextPageIndex:int=imageVec[nextID].pageIndex;
			var next_ID:int=imageVec[nextID].id;
			var nextData:XML=imageVec[nextID].data;
			
			//trace(preID+"||"+nextID);
			if(imageVec[preID].isHasData&&imageVec[nextID].isHasData){
				imageVec[preID].pageIndex=nextPageIndex;
				imageVec[preID].id=next_ID;
				imageVec[preID].data=nextData;
				
				imageVec[nextID].pageIndex=prePageIndex;
				imageVec[nextID].id=pre_ID;
				imageVec[nextID].data=preData;
				
				Root.isImageDiaoHuan=true;
				updateSelectedImageData();
			}
		}
		
		private function updateSelectedImageData():void{
			var vector:Vector.<Object>=new Vector.<Object>();
			//hasSelectedImageData.length=0;
			for(var i:int=0;i<imageVec.length;i++){
				if(imageVec[i].isHasData){
					var _pageIndex:int=imageVec[i].pageIndex;
					var _id:int=imageVec[i].id;
					var _data:XML=imageVec[i].data;
					var obj:Object={pageIndex:_pageIndex,id:_id,data:_data};
					vector.push(obj);
				}
			}
			hasSelectedImageData=vector;
			effectPlay(0);
			
			/*for(var j:int=0;j<hasSelectedImageData.length;j++){
				trace(hasSelectedImageData[j].pageIndex+"///"+hasSelectedImageData[j].id);
			}*/
		}
		
		public function addSelectedEffect(selectedObj:Object):void{
			if(hasSelectedEffectData.length>=Root.MAX_SELECT_NUM-1){
				return;
			}
			for(var i:int=0;i<effTransitionVec.length;i++){
				if(!effTransitionVec[i].isHasData){
					effTransitionVec[i].data=selectedObj.effData;
					break;
				}
			}
			
			updateSelectedEffectData();
		}
		
		public function removeSelectedEffect(selectedObj:Object):void{
			
			for(var i:int=0;i<hasSelectedEffectData.length;i++){
				var obj:Object=hasSelectedEffectData[i] as Object;
				if(obj.id==selectedObj.effData.@id&&obj.arrangeID==selectedObj.arrangeViewID){
					hasSelectedEffectData.splice(i,1);
					break;
				}
			}
			
			for(var j:int=0;j<effTransitionVec.length;j++){
				var effTransition:EffTransitionElement=effTransitionVec[j] as EffTransitionElement;
				var effData:XML=selectedObj.effData;
				var arrangeID:int=selectedObj.arrangeViewID;
				if(effTransition.id==effData.@id&&effTransition.arrangeID==arrangeID){
					effTransition.reset();
					break;
				}
			}
			
			updateSelectedEffectData();
		}
		
		public function updateSelectedEffectData():void{
			var vector:Vector.<Object>=new Vector.<Object>();
			//hasSelectedEffectData.length=0;
			for(var i:int=0;i<effTransitionVec.length;i++){
				if(effTransitionVec[i].isHasData){
					var _data:XML=effTransitionVec[i].data;
					var _id:int=int(_data.@id);
					var _arrangeID:int=effTransitionVec[i].arrangeID;
					var obj:Object={data:_data,id:_id,arrangeID:_arrangeID};
					vector.push(obj);
				}
			}
			hasSelectedEffectData=vector;
			effectPlay(0);
	
			/*for(var j:int=0;j<hasSelectedEffectData.length;j++){
				trace(hasSelectedEffectData[j].id+"||"+hasSelectedEffectData[j].effName+"||"+hasSelectedEffectData[j].arrangeID);
			}*/
		}
		
		private function effectPlay($viewID:int):void{
			sendNotification("updateEffectPlayCommand",{panelName:"EffectPlayer",message:"PauseRightNow"});
			//if(imageVec[$viewID].isHasData){
				callFunctionLater(sendNotificationFunc);
				//sendNotification("updateEffectPlayCommand",{panelName:"EditorPanel",imageViewVec:imageVec,effectViewVec:effTransitionVec});
			//}
		}
		
		private function callFunctionLater(func:Function):void{
			timeID=setTimeout(func,500);
		}
		
		private function sendNotificationFunc():void{
			if(timeID){
				clearTimeout(timeID);
			}
			sendNotification("updateEffectPlayCommand",{panelName:"EditorPanel",imageViewVec:imageVec,effectViewVec:effTransitionVec});
		}
		
		private function isDragTheLastViewImage(dragID:int):Boolean{
			if(dragID>hasSelectedImageData.length){
				return false;
			}else{
				return true;
			}
			return false;
		}
		
		private function isHasTwoViewImage(dragID:int):Boolean{
			if(imageVec[dragID].isHasData&&imageVec[dragID+1].isHasData){
				return true;
			}else{
				return false;
			}
			return false;
		}
		
		public function get hasSelectedImageData():Vector.<Object>{
			return _hasSelectedImageData;
		}
		
		public function set hasSelectedImageData(value:Vector.<Object>):void{
			_hasSelectedImageData=value;
		}
		
		public function get imageVec():Vector.<EditorEffectImage>{
			return _imageVec;
		}
		
		public function set imageVec(value:Vector.<EditorEffectImage>):void{
			_imageVec=value;
		}
		
		public function get hasSelectedEffectData():Vector.<Object>{
			return _hasSelectedEffectData;
		}
		
		public function set hasSelectedEffectData(value:Vector.<Object>):void{
			_hasSelectedEffectData=value;
		}
		
		public function get effTransitionVec():Vector.<EffTransitionElement>{
			return _effTransitionVec;
		}
		
		public function set effTransitionVec(value:Vector.<EffTransitionElement>):void{
			_effTransitionVec=value;
		}
		
		public function get inputData():XML{
			return _inputData;
		}
		
		public function set inputData(value:XML):void{
			_inputData=value;
		}
	}
}