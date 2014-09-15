package com.zqvideo.view.component
{
	import com.zqvideo.model.data.DataPoolManager;
	import com.zqvideo.utils.SkinManager;
	import com.zqvideo.view.core.ComponentView;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	
	import mvc.Command;
	import mvc.ICommand;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class EffTransitionElement extends ComponentView
	{
		private var tiaoHuanBtn:SimpleButton;
		private var icon:MovieClip;
		private var closeBtn:SimpleButton;
		private var nameTxt:TextField;
		private var activedMC:MovieClip;
		private var container:MovieClip;
		private var effTransitionMC:MovieClip;
		
		private var _moRenData:XML;
		private var _data:XML;
		private var _id:int;
		private var _effName:String="";
		private var _arrangeID:int=0;
		private var _isHasData:Boolean=false;
		private var _isActived:Boolean=false;
		private var _nameShowFlag:Boolean=false;
		
		protected var loader:Loader;
		protected var loaderContext:LoaderContext; 
		protected var imageContainer:MovieClip;
		protected var imageLoading:MovieClip;
		
		public function EffTransitionElement()
		{
			super();
		}
		
		override protected function addToStageShow():void{
			this.addChild(rootContainer);
			
			var effTransitionCls:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info,"GuoDuTeXiao");
			effTransitionMC=new effTransitionCls();
			
			rootContainer.addChild(effTransitionMC);
			tiaoHuanBtn=effTransitionMC.getChildByName("tiaoHuanBtn") as SimpleButton;
			icon=effTransitionMC.getChildByName("icon") as MovieClip;
			closeBtn=effTransitionMC.getChildByName("closeBtn") as SimpleButton;
			nameTxt=effTransitionMC.getChildByName("nameTxt") as TextField;
			nameTxt.visible=false;
			activedMC=effTransitionMC.getChildByName("activedMC") as MovieClip;
			imageContainer=effTransitionMC.getChildByName("container") as MovieClip;
			imageLoading=effTransitionMC.getChildByName("loading") as MovieClip;
			imageLoading.visible=false;
			
			loader=new Loader();
			loaderContext=new LoaderContext(true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadErrorHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,loadProgressHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler);
			
			isActived=false;
			nameShowFlag=false;
			addEvents();
			
		}
		
		public function get moRenData():XML{
			return _moRenData;
		}
		
		public function set moRenData(value:XML):void{
			_moRenData=value;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get data():XML{
			return _data;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set data(value:XML):void{
			_data=value;
			
			if(!value){
				_isHasData=false;
				return;
			}
			
			_isHasData=true;
			
			if(value.@id){
				_id=int(value.@id);
			}
			
			//trace(value.@effectName+"||"+value.@effectImgUrl+"||"+value.@effectSwfUrl);
			if(value.@effectName){
				//trace(value.effName); //特效名称
				nameShowFlag=true;
			}
		}
		
		public function get id():int{
			return _id;
		}
		
		public function set id(value:int):void{
			_id=value;
		}
		
		
		public function get effName():String{
			return _effName;
		}
		
		public function set effName(value:String):void{
			_effName=value;
		}
		
		public function get arrangeID():int{
			return _arrangeID;
		}
		
		public function set arrangeID(value:int):void{
			_arrangeID=value;
		}
		
		public function get isHasData():Boolean{
			return _isHasData;
		}
		
		public function set isHasData(value:Boolean):void{
			_isHasData=value;
		}
		
		public function get isActived():Boolean{
			return _isActived;
		}
		
		public function set isActived(value:Boolean):void{
			_isActived=value;
			activedMC.visible=value;
		}
		
		public function get nameShowFlag():Boolean{
			return _nameShowFlag;
		}
		
		public function set nameShowFlag(value:Boolean):void{
			_nameShowFlag=value;
			if(value){
				//_effName=_data.@effectName;
				icon.visible=false;
				//nameTxt.visible=true;
				//nameTxt.text=_effName;
				loadImage(Root.assetsURL+_data.@effectImgUrl);
			}else{
				//_effName="";
				icon.visible=true;
				//nameTxt.visible=false;
				//nameTxt.text=_effName;
				if(imageContainer.numChildren>1){
					imageContainer.removeChildAt(1);
				}
			}
		}
		
		public function reset():void{
			nameShowFlag=false;
			isHasData=false;
		}
		
		override protected function addEvents():void{
			tiaoHuanBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			closeBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		override protected function removeEvents():void{
			tiaoHuanBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			closeBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function loadImage(url:String):void{
			imageLoading.visible=true;
			loader.load(new URLRequest(url),loaderContext);
		}
		
		private function loadErrorHandler(e:IOErrorEvent):void{
			//trace("图片加载出错:"+e.text);
		}
		
		private function loadProgressHandler(e:ProgressEvent):void{
			
		}
		
		private function loadCompleteHandler(e:Event):void{
			imageLoading.visible=false;
			
			//UI里面有个容器背景层
			if(imageContainer.numChildren>1){
				imageContainer.removeChildAt(1);
			}
			
			if(imageContainer&&loader.content){
				loader.content.width=imageContainer.width;
				loader.content.height=imageContainer.height;
				imageContainer.addChild(loader.content);
			}
		}
		
		private function btnClickHandler(e:MouseEvent):void{
			var btnName:String=e.currentTarget.name;
			switch(btnName){
				case "tiaoHuanBtn":
					var _idObj:Object=countID(arrangeID);
					sendNotification("tiaoHuanSelectedImageCommand",{panelName:"EditorPanel",updateType:"tiaoHuanImage",idObj:_idObj});
					break;
				case "closeBtn":
					if(!isHasData){
						return;
					}
					sendNotification("selectedEffectCommand",{panelName:"EditorPanel",updateType:"removeEffect",arrangeViewID:arrangeID,effData:data});
					break;
			}
		}	
		private function countID(id:int):Object{
			//trace(id+"******************************>");
			var _preID:int=id;
			var _nextID:int=id+1;
			var obj:Object={preID:_preID,nextID:_nextID};
			return obj;
		}
	}
}