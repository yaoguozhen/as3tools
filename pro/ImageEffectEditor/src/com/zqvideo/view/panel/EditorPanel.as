package com.zqvideo.view.panel
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.zqvideo.event.NetEvent;
	import com.zqvideo.model.data.DataPoolManager;
	import com.zqvideo.model.data.EventManager;
	import com.zqvideo.model.data.ZhuanMaState;
	import com.zqvideo.model.request.DeleteReq;
	import com.zqvideo.model.request.PerReq;
	import com.zqvideo.model.request.RequestType;
	import com.zqvideo.utils.SkinManager;
	import com.zqvideo.view.LayerManager;
	import com.zqvideo.view.PreviewSoundPlayer;
	import com.zqvideo.view.YTip;
	import com.zqvideo.view.component.EditorImageAndEffectBox;
	import com.zqvideo.view.component.EditorSuCaiImage;
	import com.zqvideo.view.component.EffectArrangeBox;
	import com.zqvideo.view.component.EffectImage;
	import com.zqvideo.view.component.EffectPlayer;
	import com.zqvideo.view.component.ImageAndEffectList;
	import com.zqvideo.view.component.ImageArrangeBox;
	import com.zqvideo.view.component.PublishImage;
	import com.zqvideo.view.core.PanelView;
	import com.zqvideo.view.core.View;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import flashx.textLayout.elements.BreakElement;
	
	import net.hires.debug.Stats;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class EditorPanel extends PanelView
	{
		private var pageIndex:int=0;
//		private var totalPageNum:int=2;
		private var editorBackGround:MovieClip;
		private var leftBtn:SimpleButton;
		private var rightBtn:SimpleButton;
		private var shengChengBtn:SimpleButton;
		private var pageNumTxt:TextField;
		private var selectMusic:MovieClip;
		private var showSoundListBtn:MovieClip;
		private var selectImageBtn:MovieClip;
		private var selectEffectBtn:MovieClip;
		private var imageContainerOne:Sprite;
		private var imageContainerTwo:Sprite;
		private var totalImageContainer:Sprite;
		private var containerMask:Sprite;
		private var currentImageContainer:Sprite;
		private var oldImageContainer:Sprite;
		private var imageArrangeBox:ImageArrangeBox;
		private var arrangeImageNum:int=10;
		private var editorImageAndEffectBox:EditorImageAndEffectBox;
		private var imageAndEffectList:ImageAndEffectList;
		private var effectPlayer:EffectPlayer;
		private var soundList:SoundListPanel;
		
		private var containerOneTween:TweenMax;
		private var containerTwoTween:TweenMax;
		private var direction:String="";
		
		private var _imgAndEffCanSelect:Boolean=true;
		private var _currentSelectBtn:MovieClip;
		
		private var maskWidth:Number=843;
		private var maskHeight:Number=83;
		private var soundData:XMLList;
		
		private const listX:Number=320;
		private const listY:Number=122;
		
		private var createDeleteReq:DeleteReq=new DeleteReq();
		private var createPerReq:PerReq=new PerReq();
		private const DELETE_SUCCESS:String="success";
		private const DELETE_ERROR:String="error";
		
		private var createUpdateFlag:Boolean=false;
		private var createUpdateID_Arr:Array=[];
		private var createPerStrArr:Array=[];
		private var updateTimer:Timer;
		
		private const DELAY_TIME:Number=2;
		private var createTimeID:int=-1;
		
		private var currentData:XML;
		
		private var isTweenMove:Boolean=false;
		
		public function EditorPanel()
		{
			module=new MovieClip();
			layer=LayerManager.addToLayer(this,module);
			
			super();
		}
		
		override protected function addToStageShow():void{
			var bgCls:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info, "EditorBackGround");
			editorBackGround=new bgCls();
			module.addChild(editorBackGround);
			
			var tipSkinClass:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info, "YTip");
			var tip:YTip=YTip.getInstance();
			tip.init(Root.stage,new tipSkinClass());
				
			
			leftBtn=editorBackGround.getChildByName("leftBtn") as SimpleButton;
			rightBtn=editorBackGround.getChildByName("rightBtn") as SimpleButton;
			shengChengBtn=editorBackGround.getChildByName("shengChengBtn") as SimpleButton;
			pageNumTxt=editorBackGround.getChildByName("pageNumTxt") as TextField;
			pageNumTxt.visible=false;
			selectMusic=editorBackGround.getChildByName("selectMusic") as MovieClip;
			selectMusic.buttonMode=true;
			showSoundListBtn=editorBackGround.getChildByName("showSoundListBtn") as MovieClip;
			showSoundListBtn.stop();
			activeShowSoundListBtn(false)
			selectImageBtn=editorBackGround.getChildByName("selectImageBtn") as MovieClip;
			selectEffectBtn=editorBackGround.getChildByName("selectEffectBtn") as MovieClip;
			selectImageBtn.buttonMode=selectEffectBtn.buttonMode=true;
			
			leftBtn.enabled=false;
			rightBtn.enabled=false;
			
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
			
			editorImageAndEffectBox=new EditorImageAndEffectBox();
			module.addChild(editorImageAndEffectBox);
			editorImageAndEffectBox.x=2;
			editorImageAndEffectBox.y=446;
			
			imageAndEffectList=new ImageAndEffectList();
			module.addChild(imageAndEffectList);
			imageAndEffectList.x=listX;
			imageAndEffectList.y=listY;
			
			effectPlayer=new EffectPlayer();
			module.addChild(effectPlayer);
			effectPlayer.x=7;
			effectPlayer.y=113;
			
			soundList=new SoundListPanel();
			soundList.visible=false;
			module.addChild(soundList);
			
			//module.addChild(new Stats());
			
			currentSelectBtn=selectImageBtn;
			
			initDataPort();
			
			updateTimer=new Timer(10000);
			updateTimer.addEventListener(TimerEvent.TIMER,updateTimerHandler);
			updateTimer.start();
		}
		private function activeShowSoundListBtn(b:Boolean):void
		{
			showSoundListBtn.gotoAndStop(1);
			if(b)
			{
				showSoundListBtn.buttonMode=true;
				showSoundListBtn.alpha=1;
				showSoundListBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
				showSoundListBtn.addEventListener(MouseEvent.ROLL_OVER,showSoundListBtnRollOverHandler);
			}
			else
			{
				showSoundListBtn.buttonMode=false;
				showSoundListBtn.alpha=0.5;
				showSoundListBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
				showSoundListBtn.removeEventListener(MouseEvent.ROLL_OVER,showSoundListBtnRollOverHandler);
			}
			
		}
		
		private function showSoundListBtnRollOverHandler(event:MouseEvent):void
		{
			showSoundListBtn.addEventListener(MouseEvent.ROLL_OUT,showSoundListBtnRollOutHandler);
			showSoundListBtn.gotoAndStop(2)
		}
		
		protected function showSoundListBtnRollOutHandler(event:MouseEvent):void
		{
			showSoundListBtn.removeEventListener(MouseEvent.ROLL_OUT,showSoundListBtnRollOutHandler);
			showSoundListBtn.gotoAndStop(1)
		}
		private function initDataPort():void{
			createDeleteReq.targetName=String(EditConfig.TYPE_CREATE);
			createDeleteReq.request.url=Root.removeG;
			EventManager.instance.addEventListener(RequestType.DELETE_CATALOG,onDeleteCatalogData);
			
			createPerReq.targetName=String(EditConfig.TYPE_CREATE);
			createPerReq.request.url=Root.queryPercentGenerate;
			EventManager.instance.addEventListener(RequestType.GET_PER,onGetPer);
		}
		
		public function get effect_Player():EffectPlayer{
			return effectPlayer;
		}
		
		public function get imgAndEffCanSelect():Boolean{
			return _imgAndEffCanSelect;
		}
		
		public function set imgAndEffCanSelect(value:Boolean):void{
			_imgAndEffCanSelect=value;
			if(value==true){
				selectImageBtn.mouseEnabled=selectEffectBtn.mouseEnabled=true;
			}else{
				selectImageBtn.mouseEnabled=selectEffectBtn.mouseEnabled=false;
			}
		}
		
		public function get currentSelectBtn():MovieClip{
			return _currentSelectBtn;
		}
		
		public function set currentSelectBtn(value:MovieClip):void{
			_currentSelectBtn=value;
			selectImageBtn.buttonMode=selectEffectBtn.buttonMode=true;
			if(value==selectImageBtn){
				selectImageBtn.gotoAndStop(2);
				selectEffectBtn.gotoAndStop(1);
				selectImageBtn.buttonMode=false;
			}else{
				selectImageBtn.gotoAndStop(1);
				selectEffectBtn.gotoAndStop(2);
				selectEffectBtn.buttonMode=false;
			}
		}
		
		private function imageAndEffectBoxInitShow():void{
			sendNotification("updateDataCommand",{dataType:"GENERATE_FENYE",Page:pageIndex});
			
			editorImageAndEffectBox.initSelectedImageShow();
		}
		
		private function effectArrangeBoxInitShow():void{
			imageAndEffectList.effectArrangeBox.xmlNodeName="effects";
			imageAndEffectList.effectArrangeBox.effTransitionVec=editorImageAndEffectBox.effTransitionVec;
			imageAndEffectList.effectArrangeBox.data=DataPoolManager.getInstance().configData;
		}
		
		public function updateList(obj:Object):void{
			var type:String=obj.dataType;
			
			switch(type){
				case "EDITOR_PAGE_FENYE": 
					imageAndEffectList.updateListByData(obj);
					
					//trace("EditorPanel:"+obj.xml.toXMLString());
					break;
			}
		}
		
		override public function updatePanel(updateObj:Object):void{
			sendNotification("panelHideCommand",{panelName:"LoadingPanel"});
			var type:String=updateObj.dataType;
			
			switch(type){
				case "GENERATE_FENYE":
					currentData=updateObj.xml;
					createContainerByXml(updateObj.xml);
					//trace("GENERATE_FENYE:"+updateObj.xml.toXMLString());
					break;
			}
		}
		
		private function createContainerByXml(data:XML):void{
			Root.editorImageTotalPage=data.@TotalPage;
			trace("Root.editorImageTotalPage:",Root.editorImageTotalPage);
			if(currentImageContainer==null){
				currentImageContainer=imageContainerOne;
				oldImageContainer=imageContainerOne;
				imageContainerShowByXml(data);
				updatePageTxtShow(pageIndex);
			}else{
				if(isTweenMove==true){
					if(direction=="left"){
						tweenMove("left",data);
					}else{
						tweenMove("right",data);
						
					}
				}else{
					if(imageArrangeBox){
						imageArrangeBox.data=data;
						isUpdateByData(EditConfig.TYPE_CREATE,data);
					}
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
			//imageArrangeBox.imageType="EditorSuCaiImage";
			imageArrangeBox.imageType="PublishSucai";
			imageArrangeBox.arrangeDirection="Horizontal";
			imageArrangeBox.arrangeImageNum=arrangeImageNum;
			imageArrangeBox.xmlNodeName="Clip";
			imageArrangeBox.data=$data;
			
			isUpdateByData(EditConfig.TYPE_CREATE,$data);
			
			trace("editorImageAndEffectBox.hasSelectedImageData.length:"+editorImageAndEffectBox.hasSelectedImageData.length);
			imageArrangeBox.addImageSelectedStatus(editorImageAndEffectBox.hasSelectedImageData);
			
			totalImageContainer.x=((rightBtn.x-leftBtn.x+leftBtn.width)-maskWidth)/2+6;
			totalImageContainer.y=30;
			
			containerMask.x=totalImageContainer.x;
			containerMask.y=totalImageContainer.y;
			totalImageContainer.mask=containerMask;
			
			if(Root.editorImageTotalPage>1&&pageIndex<Root.editorImageTotalPage-1)
			{
			    rightBtn.enabled=true;
			}
			
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
		
		private function isUpdateByData(dataType:uint,xml:XML):void{
			for(var i:int=0;i<xml.Clip.length();i++){
				var childXml:XML=xml.Clip[i];
				var status:int=childXml.@status;
				if(status==ZhuanMaState.ToTransCode||status==ZhuanMaState.FastCoding){
					createUpdateFlag=true;
					createUpdateID_Arr.push(childXml.@FileKEY);
				}
			}
		}
		
		private function updatePageTxtShow($index:int):void{
			pageNumTxt.text="第"+String($index)+"/"+String(Root.editorImageTotalPage)+"页";
		}
		
		public function updateSelectedImageBox(selectedData:Object):void{
			if(selectedData.imageType!="EditorEffectImage"){
				return;
			}
			
			if(selectedData.updateType=="addElement"){
				if(editorImageAndEffectBox.hasSelectedImageData.length>=Root.MAX_SELECT_NUM){
					sendNotification("panelShowCommand",{panelName:"AlertPanel",alertContent:Root.LANGUAGE_DATA.selectMaxWarn[0]});
					if(imageArrangeBox){
						imageArrangeBox.removeImageSelectedStatus(selectedData);
					}
					
				}else{
					editorImageAndEffectBox.addSelectedElement(selectedData);
				}
			}else{
				if(editorImageAndEffectBox.hasSelectedImageData.length<=0){
					return;
				}else{
					editorImageAndEffectBox.removeSelectedElement(selectedData);
					if(imageArrangeBox){
						imageArrangeBox.removeImageSelectedStatus(selectedData);
					}
				}
			}
		}
		
		public function updateSelectedEffectBox(selectedData:Object):void{
			if(selectedData.updateType=="clickAddEffect"){
				
				if(editorImageAndEffectBox.hasSelectedEffectData.length>=Root.MAX_SELECT_NUM-1){
					sendNotification("panelShowCommand",{panelName:"AlertPanel",alertContent:Root.LANGUAGE_DATA.effectSelectedWarn[0]});
				}else{
					editorImageAndEffectBox.addSelectedEffect(selectedData);
				}
				
			}else if(selectedData.updateType=="removeEffect"){
				if(editorImageAndEffectBox.hasSelectedEffectData.length<=0){
					return;
				}else{
					editorImageAndEffectBox.removeSelectedEffect(selectedData);
				}
			}
		}
		
		public function tiaoHuanImageBox($idObj:Object):void{
			editorImageAndEffectBox.tiaoHuanSelectedElement($idObj);
		}
		
		public function updateEffectPlay(obj:Object):void{
			effectPlayer.updateEffectPlay(obj);
		}
		
		public function onSureDeleteCatalog(obj:Object):void{
			//var dataType:uint=uint(obj.type);
			createDeleteReq.id=String(obj.id);
			createDeleteReq.send();
		}
		
		private function onDeleteCatalogData(event:NetEvent):void{
			//var dataType:uint=uint(event.targetName);
			var deleteResult:String=String(event.data);
			
			if(deleteResult==DELETE_SUCCESS){
				callQuerySpace(); 
				sendNotificationFunc();
			}
		}
		
		private function callQuerySpace():void{
			if(ExternalInterface.available){
				ExternalInterface.call("querySpace");
			}
		}
		
		private function onGetPer(event:NetEvent):void{
			//var dataType:uint=uint(event.targetName);
			var allStr:String=String(event.data);
			trace(">>>allStr:"+allStr);
			
			splitStrArr(EditConfig.TYPE_CREATE,currentData,createPerStrArr,allStr);
		}
		
		private function splitStrArr(type:uint,catalogData:XML,strArr:Array,allStr:String):void{
			if(!allStr||allStr.length<=0){
				createSetTimeOut();
				return;
			}
			
			strArr=[];
			strArr=allStr.split(",");
			var objArr:Array=[];
			
			for(var i:int=0;i<strArr.length;i++){
				var str:String=strArr[i];
				var index:int=str.indexOf(":");
				var id:String=str.substring(0,index);
				var per:String=str.substring(index+1,str.length);
				
				for(var j:int=0;j<catalogData.Clip.length();j++){
					if(catalogData.Clip[j].@FileKEY==id){
						var obj:Object={Index:j,ID:id,Per:per};
						objArr.push(obj);
					}
				}
			}
			
			for(var k:int=0;k<objArr.length;k++){
				var Index:int=objArr[k].Index;
				var ID:String=objArr[k].ID;
				var Per:String=objArr[k].Per;
				if(int(Per)<0){
					PublishImage(imageArrangeBox.imgContainer.getChildAt(Index)).updateLoseState();
					updateID_Arr(ID,createUpdateID_Arr);
				}else{
					PublishImage(imageArrangeBox.imgContainer.getChildAt(Index)).updatePerShow(Per);
					if(int(Per)>=100){
						createSetTimeOut();
					}
				}
				
			}
		}
		
		private function updateID_Arr(id:String,arr:Array):void{
			var index:int=arr.indexOf(id);
			if(index>=0){
				arr.splice(index,1);
			}
		}
		
		private function createSetTimeOut():void{
			if(createTimeID){
				clearTimeout(createTimeID);
			}
			createTimeID=setTimeout(updateCreateAgain,DELAY_TIME);
		}
		
		private function updateCreateAgain():void{
			if(createTimeID){
				clearTimeout(createTimeID);
			}
			createPerReset();
			isTweenMove=false;
			sendNotification("updateDataCommand",{dataType:"GENERATE_FENYE",Page:0});
		}
		
		private function createPerReset():void{
			createUpdateFlag=false;
			createUpdateID_Arr=[];
			createPerReq.reset();
		}
		
		private function updateTimerHandler(e:TimerEvent):void{
			
			if(createUpdateFlag&&!createPerReq.isProgressFlag&&createUpdateID_Arr.length>0){
				trace("***>create per FileKEY:"+createUpdateID_Arr);
				createPerReq.idArr=createUpdateID_Arr;
				createPerReq.send();
			}
		}
		
		override protected function addEvents():void{
			leftBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			rightBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			shengChengBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			selectMusic.addEventListener(MouseEvent.CLICK,btnClickHandler);
			selectImageBtn.addEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
			selectEffectBtn.addEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
			selectImageBtn.addEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
			selectEffectBtn.addEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
			selectImageBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			selectEffectBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		override protected function removeEvents():void{
			leftBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			rightBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			shengChengBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			selectMusic.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			selectImageBtn.removeEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
			selectEffectBtn.removeEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
			selectImageBtn.removeEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
			selectEffectBtn.removeEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
			selectImageBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			selectEffectBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function btnOverHandler(e:MouseEvent):void{
			var tip:YTip=YTip.getInstance();
			var btn:MovieClip=e.currentTarget as MovieClip;
			var label:String="";
			switch(btn)
			{
				case selectImageBtn:
				    label="图片素材";
					break;
				case selectEffectBtn:
					label="切换效果";
					break;
			}
			
			var tipPosition:Point=new Point(btn.x+btn.width/2,btn.y);
			var obj:Object=new Object();
			obj.point=tipPosition
			tip.show(label,"3",obj);
			
			if(imgAndEffCanSelect==false||currentSelectBtn==MovieClip(e.currentTarget)){
				return;
			}
			MovieClip(e.currentTarget).gotoAndStop(2);
		}
		
		private function btnOutHandler(e:MouseEvent):void{
			var tip:YTip=YTip.getInstance();
			tip.hide();
			
			if(imgAndEffCanSelect==false||currentSelectBtn==MovieClip(e.currentTarget)){
				return;
			}
			MovieClip(e.currentTarget).gotoAndStop(1);
		}
		
		private function btnClickHandler(e:MouseEvent):void{
			switch(e.currentTarget.name){
				case "leftBtn":
					if(leftBtn.enabled)
					{
						if(pageIndex<=0){
							return;
						}else{
							createPerReset();
							sendNotification("panelShowCommand",{panelName:"LoadingPanel"});
							direction="left";
							isTweenMove=true;
							pageIndex--;
							updatePageTxtShow(pageIndex);
							callFunctionLater(sendNotificationFunc);
							if(pageIndex<=0){
								leftBtn.enabled=false;
							}
							rightBtn.enabled=true;
						}
					}
					break;
				
				case "rightBtn":
					if(rightBtn.enabled)
					{
						if(pageIndex>=Root.editorImageTotalPage-1){
							return;
						}else{
							createPerReset();
							sendNotification("panelShowCommand",{panelName:"LoadingPanel"});
							direction="right";
							isTweenMove=true;
							pageIndex++;
							updatePageTxtShow(pageIndex);
							callFunctionLater(sendNotificationFunc);
							trace("pageIndex,Root.editorImageTotalPage-1",pageIndex,Root.editorImageTotalPage)
							if(pageIndex>=Root.editorImageTotalPage-1){
								rightBtn.enabled=false;
							}
							leftBtn.enabled=true;
						}
					}
					break;
				case "shengChengBtn":
					
					if(editorImageAndEffectBox.hasSelectedImageData.length<=0){
						sendNotification("panelShowCommand",{panelName:"AlertPanel",alertContent:Root.LANGUAGE_DATA.selectMinWarn[0]});
					}else{
						//sendNotification("creatInputDataCommand",{panelName:"EditorPanel",inputView:editorImageAndEffectBox});
						isTweenMove=false;
						sendNotification("panelShowCommand",{panelName:"ShengChengPanel",inputView:editorImageAndEffectBox,showType:"inputBigMC"});
					}
					break;
				case "selectMusic":
					if(!soundData)
					{
						soundData=DataPoolManager.getInstance().configData.sounds.sound;
					}
					
					if(soundData)
					{
						if(!soundList.dataSource)
						{
							soundList.dataSource=soundData;
						}
						
						var btn:MovieClip=e.currentTarget as MovieClip;
						if(btn.currentFrame==1)
						{
							btn.gotoAndStop(2);
							soundList.visible=true;
							soundList.y=selectMusic.y-soundList.height-8;
							Root.useSound=true;
							activeShowSoundListBtn(true);
						}
						else
						{
							btn.gotoAndStop(1);
							soundList.visible=false;
							Root.useSound=false;
							var previewSoundPlayer:PreviewSoundPlayer=PreviewSoundPlayer.instance;
							previewSoundPlayer.stop();
							activeShowSoundListBtn(false)
						}
					}
					break;
				case "selectImageBtn":
					
					if(imageAndEffectList.selectListType!=Root.SELECT_IMAGE){
						currentSelectBtn=selectImageBtn;
						imageAndEffectList.selectListType=Root.SELECT_IMAGE;
						
					}
					break;
				case "selectEffectBtn":
					
					if(imageAndEffectList.selectListType!=Root.SELECT_EFFECT){
						currentSelectBtn=selectEffectBtn;
						imageAndEffectList.selectListType=Root.SELECT_EFFECT;
					}
					break;
			    case "showSoundListBtn":
					soundList.visible=!soundList.visible;
					break;
			}
		}
		
		private function callFunctionLater(func:Function):void{
			setTimeout(func,500);
		}
		
		private function sendNotificationFunc():void{
			sendNotification("updateDataCommand",{dataType:"GENERATE_FENYE",Page:pageIndex});
		}
		
		override public function initShowView():void{
			layer.visible=false;
		}
		
		override public function resetShowView():void{
			
		}
		
		override public function destory():void{
			
		}
		
		override public function set isShow(value:Boolean):void{
			_isShow=value;
			
			if(tween){
				tween.pause();
				tween=null;
			}
			
			if(value){
				addEvents();
				effectArrangeBoxInitShow();
				imageAndEffectBoxInitShow();
				layer.visible=true;
				
				tween=TweenMax.from(layer,0.5,{alpha:0,ease:Back.easeInOut,onComplete:tweenClose});
			}else{
				removeEvents();
				tween=TweenMax.to(layer,0.5,{alpha:0,ease:Back.easeInOut,onComplete:tweenClose});
			}
			
		}
	}
}