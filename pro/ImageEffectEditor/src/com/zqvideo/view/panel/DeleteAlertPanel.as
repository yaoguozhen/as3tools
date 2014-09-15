package com.zqvideo.view.panel
{
	import com.zqvideo.model.data.DataPoolManager;
	import com.zqvideo.utils.SkinManager;
	import com.zqvideo.view.LayerManager;
	import com.zqvideo.view.core.PanelView;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class DeleteAlertPanel extends PanelView
	{
		private static var instance:DeleteAlertPanel
		
		private var sureBtn:SimpleButton;
		private var noBtn:SimpleButton;
		private var _data:Object={};
		private var _bg:Sprite;
		private var deletPanel:MovieClip;
		
		public function DeleteAlertPanel()
		{
			module=new MovieClip();
			layer=LayerManager.addToLayer(this,module);
			
			super();
		}
		/*private function creatBg():Sprite
		{
			var sp:Sprite=new Sprite();
			sp.graphics.beginFill(0x000000,0.7);
			sp.graphics.drawRect(0,0,stageWidth,stageHeight);
			return sp;
		}*/
		override protected function addToStageShow():void{
			_bg=new Sprite();
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x000000,0.7);
			_bg.graphics.drawRect(0,0,stageWidth,stageHeight);
			_bg.graphics.endFill();
			module.addChild(_bg);
			
			var deletMCCls:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info,"DeleteAlert");
			deletPanel=new deletMCCls();
			module.addChild(deletPanel);
			
			
			sureBtn=deletPanel["sureBtn"];
			noBtn=deletPanel["noBtn"];
			
			sureBtn.addEventListener(MouseEvent.CLICK,onBtnClick);
			noBtn.addEventListener(MouseEvent.CLICK,onBtnClick);
			
			updateSizeHandler();
		}
		private function onBtnClick(e:MouseEvent):void{
			//var obj:Object=new Object();
			if(e.currentTarget==sureBtn){
//				obj.btn="sure";
//				obj.data=_data;
				isShow=false;
                sendNotification("deletPanelBtnClickCommand",data);
			}else if(e.currentTarget==noBtn){
				isShow=false;

			}
//			Root.stage.removeChild(_bg);
//			Root.stage.removeChild(this);
		}
		public static function getInstance():DeleteAlertPanel{
			if (instance){
				return instance;
			}
			instance=new DeleteAlertPanel()
			return instance;
		}
		
		override public function initShowView():void{
			layer.visible=false;
		}
		
		/*public function show():void
		{
			if(!_bg)
			{
				_bg=creatBg();
				_bg.width=Root.stage.stageWidth;
				_bg.height=Root.stage.stageHeight;
			}
			Root.stage.addChild(_bg);
			Root.stage.addChild(this);
			
		}*/
		public function get data():Object{
			return _data;
		}
		
		public function set data(value:Object):void{
			_data=value;
		}
		
		override public function updateSizeHandler():void{
			_bg.width=stageWidth;
			_bg.height=stageHeight;
			deletPanel.x=(stageWidth-deletPanel.width)/2;
			deletPanel.y=(stageHeight-deletPanel.height)/2;
		}
	}
}