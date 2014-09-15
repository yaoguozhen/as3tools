package com.zqvideo.view.component
{
	import com.greensock.TweenMax;
	import com.zqvideo.event.LoadEvent;
	import com.zqvideo.loader.ImageLoader;
	import com.zqvideo.loader.SWFLoader;
	import com.zqvideo.model.data.DataPoolManager;
	import com.zqvideo.utils.EffectUtils;
	import com.zqvideo.utils.ImageZoom;
	import com.zqvideo.utils.SkinManager;
	import com.zqvideo.view.core.ComponentView;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import flashx.textLayout.elements.BreakElement;
	
	import mvc.Command;
	import mvc.ICommand;

	/**
	 *
	 * @author .....Li灬Star
	 */
	public class EffectPlayer extends ComponentView
	{
		private var imageViewVec:Vector.<EditorEffectImage>=new Vector.<EditorEffectImage>();
		private var effViewVec:Vector.<EffTransitionElement>=new Vector.<EffTransitionElement>();
		private var imageUrlArr:Array=[];
		private var cloneImgUrlArr:Array=[];
		private var loadImgUrlArr:Array=[];
		private var swfUrlArr:Array=[];
		private var imageLoader:ImageLoader;
		private var swfLoader:SWFLoader;
		private var effClip:MovieClip;
		private var currentImageView:EditorEffectImage;
		private var effContainer:Sprite;
		private var totalImgObjArr:Array=[];
		private var imageArr:Array=[];
		private var swfArr:Array=[];
		private var imageAllFlag:Boolean=false;
		private var swfAllFlag:Boolean=false;
		private const CON_INIT_WIDTH:Number=300;
		private const CON_INIT_HEIGHT:Number=290;
		private var playViewID:int=0;
		private var playBtn:SimpleButton;
		private var pauseBtn:SimpleButton;
		private var loading:MovieClip;
		private var _playState:Boolean=false;
		private var recordPlayState:String="pause";
        private var _rollOver:Boolean=false;
		private var _defaultPreviewImage:MovieClip;
		private var hasData:Boolean=false;
		
		public function EffectPlayer()
		{
			super();
		}

		override protected function addToStageShow():void
		{
			addEventListener(MouseEvent.ROLL_OVER,thisRollOverHandler);
			
			effContainer=new Sprite();
			this.addChild(effContainer);
			effContainer.graphics.clear();
			effContainer.graphics.beginFill(0x4D4D4D, 0.5);
			effContainer.graphics.drawRect(0, 0, 300, 298);
			effContainer.graphics.endFill();

			var defaultPreviewImageCls:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info, "DefaultPreviewImage");
			_defaultPreviewImage=new defaultPreviewImageCls();
			this.addChild(_defaultPreviewImage);
			
			var playBtnCls:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info, "PlayBtn");
			playBtn=new playBtnCls();
			this.addChild(playBtn);
			playBtn.name="PlayBtn";
			playBtn.x=(this.width - playBtn.width) / 2;
			playBtn.y=(this.height - playBtn.height)/2;
			playBtn.visible=false;

			var pauseBtnCls:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info, "PauseBtn");
			pauseBtn=new pauseBtnCls();
			this.addChild(pauseBtn);
			pauseBtn.name="PauseBtn";
			pauseBtn.x=playBtn.x;
			pauseBtn.y=playBtn.y;
			pauseBtn.visible=false;

			var loadingCls:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info, "Loading");
			loading=new loadingCls();
			this.addChild(loading);
			showLoading(false);
			
			addEvents();

			updateEffCoord();
			
		}
		protected function thisRollOverHandler(event:MouseEvent):void
		{
			trace(playState)
			// TODO Auto-generated method stub
			addEventListener(MouseEvent.ROLL_OUT,thisRollOutHandler);
			_rollOver=true;
			if(playState)
			{
				if(hasData)
				{
					pauseBtn.visible=true;
				}
			}
			else
			{
				if(hasData)
				{
					playBtn.visible=true;
				}
				else
				{
					playBtn.visible=false;
				}
			}
		}
		
		protected function thisRollOutHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			removeEventListener(MouseEvent.ROLL_OUT,thisRollOutHandler);
			_rollOver=false;
			//playBtn.visible=false;
			pauseBtn.visible=false;
		}
		
		override protected function addEvents():void
		{
			playBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
			pauseBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
		}

		override protected function removeEvents():void
		{
			playBtn.removeEventListener(MouseEvent.CLICK, btnClickHandler);
			pauseBtn.removeEventListener(MouseEvent.CLICK, btnClickHandler);
		}

		public function get playState():Boolean
		{
			return _playState;
		}

		public function set playState(value:Boolean):void
		{
			_playState=value;
			if (value)
			{
				playBtn.visible=false;
				pauseBtn.visible=false;
				recordPlayState="play";
				Root.previewPlayerState="play";
				if (effClip)
				{
					effClip.effPlay();
				}
			}
			else
			{
				if(hasData)
				{
					playBtn.visible=true;
				}
				pauseBtn.visible=false;
				recordPlayState="pause";
				Root.previewPlayerState="pause";
				if (effClip)
				{
					effClip.effPause();
				}
			}
			sendNotification("controlSoundCommand", {play: value});
		}
        
		
		private function imageAllLoadComplete(e:LoadEvent):void
		{
			updateImageObjArr();
			//trace(">>>images all load complete>>>length>>>" + imageArr.length);
			try
			{
				imageLoader.removeEventListener(LoadEvent.IMAGE_ALL_COMPLETE, imageAllLoadComplete);
				imageLoader.removeEventListener(LoadEvent.IMAGE_LOAD_ERROR, imageLoadError);
				imageLoader.imageUrlArr=[];
				imageLoader.allBitmapData=[];
				imageLoader=null;
			}
			catch (error:Error)
			{

			}
			imageAllFlag=true;
			loadAllEffectSwf();
		}

		private function imageLoadError(e:LoadEvent):void
		{
			sendNotification("panelShowCommand", {panelName: "AlertPanel", alertContent: Root.LANGUAGE_DATA.imageLoadError[0]});
		}
        
		private function loadAllEffectSwf():void{
			swfUrlArr[0]=Root.assetsURL + DataPoolManager.getInstance().moRenEffectData.@effectSwfUrl;
			for (var j:int=0; j < effViewVec.length; j++)
			{
				var swfUrlStr:String="";
				if (effViewVec[j].isHasData)
				{
					swfUrlStr=Root.assetsURL + effViewVec[j].data.@effectSwfUrl;
					swfUrlArr.push(swfUrlStr);
				}
				else
				{
					swfUrlStr=Root.assetsURL + effViewVec[j].moRenData.@effectSwfUrl; 
					swfUrlArr.push(swfUrlStr);
				}
				trace(">>>swfUrlStr:" + swfUrlStr);
			}
			trace("***>swfUrlArr.length:"+swfUrlArr.length);
			swfLoader=new SWFLoader();
			swfLoader.addEventListener(LoadEvent.SWF_ALL_COMPLTE, swfAllLoadComplete);
			swfLoader.addEventListener(LoadEvent.SWF_LOAD_ERROR, swfLoadError);
			swfLoader.swfUrlArr=swfUrlArr;
			swfLoader.loadSwfData();
		}
		
		private function swfAllLoadComplete(e:LoadEvent):void
		{
			swfArr=swfLoader.allClipData;
			trace(">>>swfs all load complete>>>length>>>" + swfArr.length);
			try
			{
				swfLoader.removeEventListener(LoadEvent.SWF_ALL_COMPLTE, swfAllLoadComplete);
				swfLoader.removeEventListener(LoadEvent.SWF_LOAD_ERROR, swfLoadError);
				swfLoader.swfUrlArr=[];
				swfLoader.allClipData=[];
				swfLoader=null;
			}
			catch (error:Error)
			{

			}
			swfAllFlag=true;
			if (imageAllFlag && swfAllFlag)
			{
				startPlayEffect();
			}
			
			trace(imageArr.length,playState);
			if(imageArr.length>0&&playState==false)
			{
			    playBtn.visible=true;
			}
		}

		private function swfLoadError(e:LoadEvent):void
		{
			sendNotification("panelShowCommand", {panelName: "AlertPanel", alertContent: Root.LANGUAGE_DATA.swfLoadError[0]});
		}

		private function startPlayEffect():void
		{
			showLoading(false);

			effClipDestroy();

			if (currentImageView)
			{
				currentImageView.isActived=false;
				currentImageView=null;
			}
			trace("!!!!!:"+playViewID);
			
			if(playViewID>imageArr.length-1){
				playViewID=imageArr.length-1;
			}
			
			if(playViewID<0){
				playViewID=0;
			}
			
			updateNonePlayTime();
			noneEffectStartPlay();
			
			if (recordPlayState == "pause")
			{
				playState=false;
			}
			else
			{
				playState=true;
			}
		}

		private function noEffectPlayEnd(e:Event):void
		{
			trace(">>>none play end============================>");
			effClipDestroy();
			if (currentImageView)
			{
				currentImageView.isActived=false;
				currentImageView=null;
			}

			playViewID++;
			
			if (playViewID > imageArr.length - 1)
			{
				//从头开始循环播放
				while (effContainer.numChildren > 0)
				{
					effContainer.removeChildAt(0);
				}
				playViewID=0;
				startPlayEffect();
				return;
			}

			setIsHasEffectPlay();
		}

		private function hasEffectPlayEnd(e:Event):void
		{
			trace(">>>effect play end============================>");
			effClipDestroy();
			if (currentImageView)
			{
				currentImageView.isActived=false;
				currentImageView=null;
			}
			noneEffectStartPlay();
		}
        
		private function setIsHasEffectPlay():void{
			if (effViewVec[playViewID - 1].isHasData && effViewVec[playViewID - 1].data != DataPoolManager.getInstance().moRenEffectData)
			{
				hasEffectStartPlay();
			}
			else
			{
				noneEffectStartPlay();
			}
		}
		
		private function noneEffectStartPlay():void{
			if(swfArr.length<=0||playViewID<0){
				return;
			}
			
			trace("noneEffectStartPlay:"+playViewID);
			//none特效
			effClip=swfArr[0] as MovieClip;
			effClip.nonePlayTime=Root.singleImgTime;
			effClip.bitMapArr=imageArr.slice(playViewID, playViewID + 1);
			effContainer.addChild(effClip);
			effClip.init();
			effClip.addEventListener("ending", noEffectPlayEnd);
			currentImageView=imageViewVec[playViewID] as EditorEffectImage;
			trace("currentImageView.isHasData:"+currentImageView.isHasData);
			currentImageView.isActived=true;
			updateEffCoord();
		}
		
		private function hasEffectStartPlay():void{
			if(swfArr.length<=0){
				return;
			}
			//有过渡特效且不是none特效
			effClip=swfArr[playViewID] as MovieClip;
			effClip.bitMapArr=imageArr.slice(playViewID - 1, playViewID + 1);
			effContainer.addChild(effClip);
			effClip.init();
			effClip.addEventListener("ending", hasEffectPlayEnd);
			currentImageView=imageViewVec[playViewID] as EditorEffectImage;
			currentImageView.isActived=true;
			updateEffCoord();
		}
		
		public function updateEffectPlay(obj:Object):void
		{
			trace(">>>updateData***********************>>>");
			showLoading(true);
			updateEffCoord();

			imageUrlArr=[];
			loadImgUrlArr=[];
			swfUrlArr=[];
			imageAllFlag=false;
			swfAllFlag=false;
			
			//playViewID=0;
			
			imageViewVec=obj.imageViewVec;
			effViewVec=obj.effectViewVec;
            hasData=false;
			for (var i:int=0; i < imageViewVec.length; i++)
			{
				if (imageViewVec[i].isHasData)
				{
					hasData=true;
					
					var urlStr:String=imageViewVec[i].data.@IMGUrl;
					imageUrlArr.push(urlStr);
					trace("===>new imgUrl:"+urlStr);
				}
			}

			if(hasData)
			{
				_defaultPreviewImage.visible=false;
			}
			else
			{
				playBtn.visible=false;
				_defaultPreviewImage.visible=true;
			}
			
			trace("*****>cloneImgUrlArr.length:"+cloneImgUrlArr.length);
			for(var j:int=0;j<cloneImgUrlArr.length;j++){
				trace("*****>clone imgUrl:"+cloneImgUrlArr[j]);
			}
			
			loadImgUrlArr=EffectUtils.getTheDifferentUrls(imageUrlArr,cloneImgUrlArr);
			trace("99999999999999999999999999999999999:",loadImgUrlArr)
			cloneImgUrlArr=EffectUtils.clone(imageUrlArr);
			
			trace(">>>loadImgUrlArr.length:"+loadImgUrlArr.length);
			for(var k:int=0;k<loadImgUrlArr.length;k++){
				trace(">>>load imgUrl:"+loadImgUrlArr[k]);
			}
			
			if(loadImgUrlArr.length>0){
				imageLoader=new ImageLoader();
				imageLoader.addEventListener(LoadEvent.IMAGE_ALL_COMPLETE, imageAllLoadComplete);
				imageLoader.addEventListener(LoadEvent.IMAGE_LOAD_ERROR, imageLoadError);
				imageLoader.imageUrlArr=loadImgUrlArr;
				
				imageLoader.loadImgData();
			}else{
				updateImageObjArr();
				if(imageArr.length<=0){
					
					initAllSettings();
					return;
				}
				imageAllFlag=true;
				if(Root.isImageDiaoHuan==true){
					swfAllFlag=true;
					startPlayEffect();
					if(imageArr.length>0&&playState==false)
					{
						playBtn.visible=true;
					}
					return;
				}
				
				loadAllEffectSwf();
			}
		}
		
		private function updateImageObjArr():void{
			totalImgObjArr=EffectUtils.getTheSameImgObjUrls(imageUrlArr,totalImgObjArr);
			
			if(imageLoader){
				for (var i:int=0; i < imageLoader.allBitmapData.length; i++)
				{
					var obj:Object=imageLoader.allBitmapData[i];
					totalImgObjArr.push(obj);
				}
			}
			
			var arrangeUrlArr:Array=[];
			for (var j:int=0; j < imageViewVec.length; j++)
			{
				if (imageViewVec[j].isHasData)
				{
					var urlStr:String=imageViewVec[j].data.@IMGUrl;
					arrangeUrlArr.push(urlStr);
				}
			}
			
			imageArr=EffectUtils.getTheArrangeUrls(arrangeUrlArr,totalImgObjArr);
			
		}
		
		private function initAllSettings():void{
			playState=false;
			playViewID=0;
			effClipDestroy();
			while(effContainer.numChildren>0){
				effContainer.removeChildAt(0);
			}
			showLoading(false);
		}
		
		private function updateNonePlayTime():void{
			var selectImgNum:int=0;
			for(var i:int=0;i<imageViewVec.length;i++){
				if(imageViewVec[i].isHasData){
					selectImgNum++;
				}
			}
			
			var selectEffNum:int=0;
			for(var j:int=0;j<effViewVec.length;j++){
				if(effViewVec[j].isHasData){
					selectEffNum++;
				}
			}
			
			Root.singleImgTime=(Root.TOTAL_PLAY_TIME-Root.SINGLE_EFF_TIME*selectEffNum)/selectImgNum;
			trace("=====>Root.singleImgTime:"+Root.singleImgTime);
		}

		private function btnClickHandler(e:MouseEvent):void
		{
			var btnName:String=e.currentTarget.name;

			switch (btnName)
			{
				case "PlayBtn":
					playState=true;
					break;

				case "PauseBtn":
					playState=false;
					break;
			}
		}

		public function pauseRightNow():void
		{
			showLoading(true);
			if (effClip)
			{
				effClip.effPause();
			}
		}

		public function showLoading(flag:Boolean):void
		{
			loading.visible=flag;
		}

		private function updateEffCoord():void
		{
			if (effClip)
			{
				effClip.x=(CON_INIT_WIDTH - Root.MAX_IMAGE_WIDTH) / 2;
				effClip.y=(CON_INIT_HEIGHT - Root.MAX_IMAGE_HEIGHT) / 2;
				//trace("****************************>>>"+container.width+","+container.height+"||"+effClip.width+","+effClip.height);
			}
			loading.x=CON_INIT_WIDTH / 2;
			loading.y=CON_INIT_HEIGHT / 2;
		}
		
		private function effClipDestroy():void{
			if (effClip)
			{
				effClip.destroy();
				effClip.removeEventListener("ending", noEffectPlayEnd);	
				effClip.removeEventListener("ending", hasEffectPlayEnd);
				effContainer.removeChild(effClip);
				effClip=null;
			}
		}
	}
}
