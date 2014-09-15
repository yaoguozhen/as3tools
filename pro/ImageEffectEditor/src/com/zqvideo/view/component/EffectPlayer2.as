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
		private var imageArr:Array=[];
		private var swfArr:Array=[];
		private var imageAllFlag:Boolean=false;
		private var swfAllFlag:Boolean=false;
		private var currentImgIndex:int=0;
		private var currentEffIndex:int=0;
		private var currentNonePlayImgArr:Array=[];
		private var currentHasPlayImgArr:Array=[];
		private var defaultSwfUrlObj:Object={};
		private const IMG_MAX_NUM:int=6;
		private const EFF_MAX_NUM:int=5;
		private const CON_INIT_WIDTH:Number=300;
		private const CON_INIT_HEIGHT:Number=290;
		private var playViewID:int=0;
		private var playBtn:SimpleButton;
		private var pauseBtn:SimpleButton;
		private var loading:MovieClip;
		private var _playState:Boolean=false;
		private var recordPlayState:String="pause";
        private var _rollOver:Boolean=false;
		
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
			showLoading(true);
			
			addEvents();

			updateEffCoord();
			
		}
		
		protected function thisRollOverHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			addEventListener(MouseEvent.ROLL_OUT,thisRollOutHandler);
			_rollOver=true;
			if(playState)
			{
				pauseBtn.visible=true;
			}
			else
			{
				if(imageArr.length>0)
				{
					playBtn.visible=true;
				}
			}
		}
		
		protected function thisRollOutHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			removeEventListener(MouseEvent.ROLL_OUT,thisRollOutHandler);
			_rollOver=false;
			playBtn.visible=false;
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
				if(_rollOver)
				{
					pauseBtn.visible=true;
				}
				recordPlayState="play";
				Root.previewPlayerState="play";
				if (effClip)
				{
					effClip.effPlay();
				}
			}
			else
			{
				if(_rollOver)
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
			swfUrlArr[0]=defaultSwfUrlObj;
			for (var j:int=0; j < effViewVec.length; j++)
			{
				var _viewID:int=effViewVec[j].arrangeID+1;
				var _swfUrlStr:String="";
				if (effViewVec[j].isHasData)
				{
					_swfUrlStr=Root.assetsURL + effViewVec[j].data.@effectSwfUrl;
					
				}
				else
				{
					_swfUrlStr=Root.assetsURL + effViewVec[j].moRenData.@effectSwfUrl;
					
				}
				var obj:Object={viewID:_viewID,swfUrlStr:_swfUrlStr};
				swfUrlArr.push(obj);
				trace(">>>swfUrlStr:" + _swfUrlStr);
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
			
			if(playViewID>IMG_MAX_NUM-1){
				playViewID=IMG_MAX_NUM-1;
			}
			
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
		
		private function noneEffectStartPlay():void{
			if(swfArr.length<=0){
				return;
			}
			
			//none特效
			setNonePlayImgArr();
			effClip=swfArr[0].clip as MovieClip;
			effClip.bitMapArr=currentNonePlayImgArr;
			effContainer.addChild(effClip);
			effClip.init();
			effClip.addEventListener("ending", noEffectPlayEnd);
			currentImageView=imageViewVec[playViewID] as EditorEffectImage;
			currentImageView.isActived=true;
			updateEffCoord();
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
			trace("===========>playViewID:"+playViewID);
			if (playViewID > IMG_MAX_NUM-1||currentImgIndex>=imageArr.length-1)
			{
				//从头开始循环播放
				while (effContainer.numChildren > 0)
				{
					effContainer.removeChildAt(0);
				}
				playViewID=0;
				currentImgIndex=0;
				currentEffIndex=0;
				startPlayEffect();
				return;
			}
			
			setIsHasEffectPlay();
		}
		
		private function hasEffectStartPlay():void{
			if(swfArr.length<=0){
				return;
			}
			
			//有过渡特效且不是none特效
			setHasPlayImgArr();
			effClip=swfArr[currentEffIndex].clip as MovieClip;
			effClip.bitMapArr=currentHasPlayImgArr;
			effContainer.addChild(effClip);
			effClip.init();
			effClip.addEventListener("ending", hasEffectPlayEnd);
			currentImageView=imageViewVec[playViewID] as EditorEffectImage;
			currentImageView.isActived=true;
			updateEffCoord();
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
			if (effViewVec[playViewID - 1].isHasData && imageViewVec[playViewID].isHasData)
			{
				if(effViewVec[playViewID - 1].data != DataPoolManager.getInstance().moRenEffectData){
					hasEffectStartPlay();
				}else{
					noneEffectStartPlay();
				}
				
			}
			else
			{
				noneEffectStartPlay();
			}
		}
		
		private function setNonePlayImgArr():void{
			if(imageViewVec[playViewID].isHasData){
				playViewID=imageViewVec[playViewID].arrangeID;
			}else{
				for(var i:int=playViewID+1;i<imageViewVec.length;i++){
					if(imageViewVec[i].isHasData){
						playViewID=i;
						break;
						return;
					}else{
						if(i>=imageViewVec.length-1){
							playViewID=0;
						}
					}
				}
			}
			
			for(var j:int=0;j<imageArr.length;j++){
				var imgIndex:int=imageArr[j].viewID;
				if(imgIndex==playViewID){
					currentImgIndex=j;
					break;
				}
			}
			
			trace("none playViewID:"+playViewID+"||"+"currentImgIndex:"+currentImgIndex);
			if(currentImgIndex>imageArr.length-1){
				currentImgIndex=imageArr.length-1;
			}
			currentNonePlayImgArr=[];
			currentNonePlayImgArr.push(imageArr[currentImgIndex].bitmap);
		}
		
		private function setHasPlayImgArr():void{
			for(var i:int=0;i<swfArr.length;i++){
				var effIndex:int=swfArr[i].viewID;
				if(effIndex==playViewID){
					currentEffIndex=i;
					break;
				}
			}
			
			trace("has playViewID:"+playViewID+"||"+"currentEffIndex:"+currentEffIndex);
			if(currentEffIndex>swfArr.length-1){
				currentEffIndex=swfArr.length-1;
			}
			currentHasPlayImgArr=[];
			currentHasPlayImgArr.push(imageArr[currentImgIndex].bitmap,imageArr[currentImgIndex+1].bitmap);
		}
		
		public function updateEffectPlay(obj:Object):void
		{
			trace(">>>updateData***********************>>>");
			showLoading(true);
			updateEffCoord();

			defaultSwfUrlObj={swfUrlStr:Root.assetsURL + DataPoolManager.getInstance().moRenEffectData.@effectSwfUrl,viewID:0};
			imageUrlArr=[];
			loadImgUrlArr=[];
			swfUrlArr=[];
			imageAllFlag=false;
			swfAllFlag=false;
			
			//playViewID=0;
			
			imageViewVec=obj.imageViewVec;
			effViewVec=obj.effectViewVec;

			for (var i:int=0; i < imageViewVec.length; i++)
			{
				if (imageViewVec[i].isHasData)
				{
					var _viewID:int=imageViewVec[i].arrangeID;
					var _urlStr:String=imageViewVec[i].data.@IMGUrl;
					var obj:Object={viewID:_viewID,urlStr:_urlStr};
					imageUrlArr.push(obj);
					trace("===>new imgUrl:"+obj.urlStr);
				}
			}
			//trace("*****>cloneImgUrlArr.length:"+cloneImgUrlArr.length);
			for(var j:int=0;j<cloneImgUrlArr.length;j++){
				trace("*****>clone imgUrl:"+cloneImgUrlArr[j].urlStr);
			}
			
			loadImgUrlArr=EffectUtils.getTheDifferentUrls(imageUrlArr,cloneImgUrlArr);
			cloneImgUrlArr=EffectUtils.clone(imageUrlArr);
			
			trace(">>>loadImgUrlArr.length:"+loadImgUrlArr.length);
			for(var k:int=0;k<loadImgUrlArr.length;k++){
				trace(">>>load imgUrl:"+loadImgUrlArr[k].viewID+"||"+loadImgUrlArr[k].urlStr);
			}
			
			if(loadImgUrlArr.length>0){
				//新增图片
				imageLoader=new ImageLoader();
				imageLoader.addEventListener(LoadEvent.IMAGE_ALL_COMPLETE, imageAllLoadComplete);
				imageLoader.addEventListener(LoadEvent.IMAGE_LOAD_ERROR, imageLoadError);
				imageLoader.imageUrlArr=loadImgUrlArr;
				imageLoader.loadImgData();
			}else{
				//删除图片或者调换位置 
				imageArr=EffectUtils.updateOldImageObjArrange(imageArr,imageUrlArr);
				if(currentImgIndex>imageArr.length-1){
					currentImgIndex=imageArr.length-1;
				}
				imageAllFlag=true;
				loadAllEffectSwf();
			}
		}
		
		private function updateImageObjArr():void{
			if(imageLoader){
				for (var i:int=0; i < imageLoader.allBitmapData.length; i++)
				{
					var obj:Object=imageLoader.allBitmapData[i];
					imageArr.push(obj);
				}
			}
			
			imageArr=EffectUtils.updateNewImageObjArrange(imageArr);
			for(var j:int=0;j<imageArr.length;j++){
				trace(">>>viewID:"+imageArr[j].viewID);
			}
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
