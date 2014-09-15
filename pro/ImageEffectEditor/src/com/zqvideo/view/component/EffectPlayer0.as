package com.zqvideo.view.component
{
	import com.zqvideo.event.LoadEvent;
	import com.zqvideo.loader.ImageLoader;
	import com.zqvideo.loader.SWFLoader;
	import com.zqvideo.model.data.DataPoolManager;
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
	
	import mvc.Command;
	import mvc.ICommand;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class EffectPlayer0 extends ComponentView
	{
		private var imageViewVec:Vector.<EditorEffectImage>=new Vector.<EditorEffectImage>();
		private var effViewVec:Vector.<EffTransitionElement>=new Vector.<EffTransitionElement>();
		private var imageUrlArr:Array=[];
		private var swfUrlArr:Array=[];
		private var imageLoader:ImageLoader;
		private var swfLoader:SWFLoader;
		private var effClip:MovieClip;
		private var currentImageView:EditorEffectImage;
		
		private var imageArr:Array=[];
		private var swfArr:Array=[];
		private var imageAllFlag:Boolean=false;
		private var swfAllFlag:Boolean=false;
		
		private var isHasEffect:Boolean=false;
		
		private const CON_INIT_WIDTH:Number=390;
		private const CON_INIT_HEIGHT:Number=272;
		private const MAX_WIDTH:Number=390;
		private const MAX_HEIGHT:Number=260;
		private var playViewID:int=0;
		
		private var playBtn:SimpleButton;
		private var pauseBtn:SimpleButton;
		private var loading:MovieClip;
		
		private var _playState:Boolean=false;
		private var recordPlayState:String="pause";
		
		public function EffectPlayer0()
		{
			super();
		}
		
		override protected function addToStageShow():void{
			this.addChild(rootContainer);
			rootContainer.graphics.clear();
			rootContainer.graphics.beginFill(0x4D4D4D,0.5);
			rootContainer.graphics.drawRect(0,0,390,272);
			rootContainer.graphics.endFill();
			
			var playBtnCls:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info,"PlayBtn");
			playBtn=new playBtnCls();
			this.addChild(playBtn);
			playBtn.name="PlayBtn";
			playBtn.x=(this.width-playBtn.width)/2-5;
			playBtn.y=this.height-playBtn.height;
			playBtn.visible=false;
			
			var pauseBtnCls:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info,"PauseBtn");
			pauseBtn=new pauseBtnCls();
			this.addChild(pauseBtn);
			pauseBtn.name="PauseBtn";
			pauseBtn.x=playBtn.x;
			pauseBtn.y=playBtn.y;
			pauseBtn.visible=false;
			
			var loadingCls:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info,"Loading");
			loading=new loadingCls();
			this.addChild(loading);
			showLoading(true);
			
			addEvents();
			
			updateEffCoord();
		}
		
		override protected function addEvents():void{
			playBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			pauseBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		override protected function removeEvents():void{
			playBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			pauseBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		public function get playState():Boolean{
			return _playState;
		}
		
		public function set playState(value:Boolean):void{
			_playState=value;
			if(value){
				playBtn.visible=false;
				pauseBtn.visible=true;
				recordPlayState="play";
				if(effClip){
					effClip.effPlay();
				}
			}else{
				playBtn.visible=true;
				pauseBtn.visible=false;
				recordPlayState="pause";
				if(effClip){
					effClip.effPause();
				}
			}
		}
		
		private function imageAllLoadComplete(e:LoadEvent):void{
			imageArr=[];
			for(var i:int=0;i<imageLoader.allBitmapData.length;i++){
				var bitMap:Bitmap=imageLoader.allBitmapData[i] as Bitmap;
				//var imageZoom:ImageZoom = new ImageZoom(bitMap.width, bitMap.height, MAX_WIDTH, MAX_HEIGHT);
				bitMap.width=MAX_WIDTH;
				bitMap.height = MAX_HEIGHT;
				imageArr.push(bitMap);
			}
			try
			{
				imageLoader.removeEventListener(LoadEvent.IMAGE_ALL_COMPLETE,imageAllLoadComplete);
				imageLoader.removeEventListener(LoadEvent.IMAGE_LOAD_ERROR,imageLoadError);
				imageLoader.imageUrlArr=[];
				imageLoader.allBitmapData=[];
				//imageLoader=null;
			} 
			catch(error:Error) 
			{
				
			}
			imageAllFlag=true;
			trace(">>>images all load complete>>>length>>>"+imageArr.length);
			
			swfUrlArr[0]=Root.assetsURL+DataPoolManager.getInstance().moRenEffectData.@effectSwfUrl;
			if(effViewVec.length>0){
				for(var j:int=0;j<effViewVec.length;j++){
					var swfUrlStr:String="";
					if(effViewVec[j].isHasData){
						swfUrlStr=Root.assetsURL+effViewVec[j].data.@effectSwfUrl;
						swfUrlArr.push(swfUrlStr);
					}else{
						swfUrlStr=Root.assetsURL+effViewVec[j].moRenData.@effectSwfUrl;
						swfUrlArr.push(swfUrlStr);
					}
					trace(">>>swfUrlStr:"+swfUrlStr);
				}
				swfLoader=new SWFLoader();
				swfLoader.addEventListener(LoadEvent.SWF_ALL_COMPLTE,swfAllLoadComplete);
				swfLoader.addEventListener(LoadEvent.SWF_LOAD_ERROR,swfLoadError);
				swfLoader.swfUrlArr=swfUrlArr;
				swfLoader.loadSwfData();
			}
		}
		
		private function imageLoadError(e:LoadEvent):void{
			sendNotification("panelShowCommand",{panelName:"AlertPanel",alertContent:Root.LANGUAGE_DATA.imageLoadError[0]});
		}
		
		private function swfAllLoadComplete(e:LoadEvent):void{
			swfArr=swfLoader.allClipData;
			try
			{
				swfLoader.removeEventListener(LoadEvent.SWF_ALL_COMPLTE,swfAllLoadComplete);
				swfLoader.removeEventListener(LoadEvent.SWF_LOAD_ERROR,swfLoadError);
				swfLoader.swfUrlArr=[];
				swfLoader.allClipData=[];
				//swfLoader=null;
			} 
			catch(error:Error) 
			{
				
			}
			swfAllFlag=true;
			trace(">>>swfs all load complete>>>length>>>"+swfArr.length);
			if(imageAllFlag&&swfAllFlag){
				startPlayEffect();
			}
		}
		
		private function swfLoadError(e:LoadEvent):void{
			sendNotification("panelShowCommand",{panelName:"AlertPanel",alertContent:Root.LANGUAGE_DATA.swfLoadError[0]});
		}
		
		private function startPlayEffect():void{
			if(playViewID!=0){
				return;
			}
			showLoading(false);
			
			if(effClip){
				effClip.destroy();
				effClip.removeEventListener("ending",noEffectPlayEnd);
				effClip.removeEventListener("ending",hasEffectPlayEnd);
				rootContainer.removeChild(effClip);
				effClip=null;
			}
			
			updateEffCoord();
			//第一张图片 none特效
			trace("从头开始播放*******************************>");
			if(effClip){
				effClip.destroy();
				effClip.removeEventListener("ending",noEffectPlayEnd); 
				effClip.removeEventListener("ending",hasEffectPlayEnd);
				rootContainer.removeChild(effClip);
				effClip=null;
			}
			if(currentImageView){
				currentImageView.isActived=false;
				currentImageView=null;
			}
			currentImageView=imageViewVec[0] as EditorEffectImage;
			currentImageView.isActived=true;
			effClip=swfArr[0] as MovieClip;
			effClip.bitMapArr=imageArr.slice(playViewID,playViewID+1);
			effClip.init();
			rootContainer.addChild(effClip);
			updateEffCoord();
			effClip.addEventListener("ending",noEffectPlayEnd);
			if(recordPlayState=="pause"){
				playState=false;
			}else{
				playState=true;
			}
		}
		
		private function noEffectPlayEnd(e:Event):void{
			trace(">>>none play end============================>");
			if(effClip){
				effClip.removeEventListener("ending",noEffectPlayEnd);
				effClip.removeEventListener("ending",hasEffectPlayEnd);
				rootContainer.removeChild(effClip);
				effClip=null;
			}
			if(currentImageView){
				currentImageView.isActived=false;
				currentImageView=null;
			}
			
			playViewID++;
			if(playViewID>imageArr.length-1){
				//从头开始循环播放
				while(rootContainer.numChildren>0){
					rootContainer.removeChildAt(0);
				}
				playViewID=0;
				startPlayEffect();
				return;
			}
			
			if(effViewVec[playViewID-1].isHasData&&effViewVec[playViewID-1].data!=DataPoolManager.getInstance().moRenEffectData){
				//有过渡特效且不是none特效
				effClip=swfArr[playViewID] as MovieClip;
				effClip.bitMapArr=imageArr.slice(playViewID-1,playViewID+1);
				effClip.init();
				rootContainer.addChild(effClip);
				updateEffCoord();
				effClip.addEventListener("ending",hasEffectPlayEnd);
				currentImageView=imageViewVec[playViewID] as EditorEffectImage;
				currentImageView.isActived=true;
				
			}else{
				//none特效
				effClip=swfArr[0] as MovieClip;
				effClip.bitMapArr=imageArr.slice(playViewID,playViewID+1);
				effClip.init();
				rootContainer.addChild(effClip);
				updateEffCoord();
				effClip.addEventListener("ending",noEffectPlayEnd);
				currentImageView=imageViewVec[playViewID] as EditorEffectImage;
				currentImageView.isActived=true;
			}
		}
		
		private function hasEffectPlayEnd(e:Event):void{
			trace(">>>effect play end============================>");
			if(effClip){
				effClip.removeEventListener("ending",hasEffectPlayEnd);
				rootContainer.removeChild(effClip);
				effClip=null;
			}
			if(currentImageView){
				currentImageView.isActived=false;
				currentImageView=null;
			}
			effClip=swfArr[0] as MovieClip;
			effClip.bitMapArr=imageArr.slice(playViewID,playViewID+1);
			effClip.init();
			rootContainer.addChild(effClip);
			updateEffCoord();
			effClip.addEventListener("ending",noEffectPlayEnd);
			currentImageView=imageViewVec[playViewID] as EditorEffectImage;
			currentImageView.isActived=true;
		}
		
		public function updateEffectPlay(obj:Object):void{
			trace(">>>updateData***********************>>>");
			showLoading(true);
			updateEffCoord();
			
			imageUrlArr=[];
			swfUrlArr=[];
			imageAllFlag=false;
			swfAllFlag=false;
			isHasEffect=false;
			playViewID=0;
			imageViewVec=obj.imageViewVec;
			effViewVec=obj.effectViewVec;
			
			if(imageViewVec.length>0){
				for(var i:int=0;i<imageViewVec.length;i++){
					if(imageViewVec[i].isHasData){
						var imgUrlStr:String=imageViewVec[i].data.@IMGUrl;
						imageUrlArr.push(imgUrlStr);
					}
					//trace(imgUrlStr);
				}
				imageLoader=new ImageLoader();
				imageLoader.addEventListener(LoadEvent.IMAGE_ALL_COMPLETE,imageAllLoadComplete);
				imageLoader.addEventListener(LoadEvent.IMAGE_LOAD_ERROR,imageLoadError);
				imageLoader.imageUrlArr=imageUrlArr;
				imageLoader.loadImgData();
			}
			
			
		}
		
		private function btnClickHandler(e:MouseEvent):void{
			var btnName:String=e.currentTarget.name;
			
			switch(btnName){
				case "PlayBtn":
					playState=true;
					break;
				
				case "PauseBtn":
					playState=false;
					break;
			}
		}
		
		public function pauseRightNow():void{
			showLoading(true);
			if(effClip){
				effClip.effPause();
			}
		}
		
		public function showLoading(flag:Boolean):void{
			loading.visible=flag;
		}
		
		private function updateEffCoord():void{
			if(effClip){
				effClip.x=(CON_INIT_WIDTH-MAX_WIDTH)/2;
				effClip.y=(CON_INIT_HEIGHT-MAX_HEIGHT)/2;
				//trace("****************************>>>"+container.width+","+container.height+"||"+effClip.width+","+effClip.height);
			}
			loading.x=CON_INIT_WIDTH/2;
			loading.y=CON_INIT_HEIGHT/2;
		}
		
	}
}