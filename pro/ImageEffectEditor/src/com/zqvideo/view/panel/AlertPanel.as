package com.zqvideo.view.panel
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.zqvideo.model.data.DataPoolManager;
	import com.zqvideo.utils.SkinManager;
	import com.zqvideo.view.LayerManager;
	import com.zqvideo.view.core.PanelView;
	import com.zqvideo.view.core.View;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class AlertPanel extends PanelView
	{
		private var alertTxt:TextField;
		private var alertSureBtn:SimpleButton;
		
		public function AlertPanel()
		{
			module=new MovieClip();
			layer=LayerManager.addToLayer(this,module);
			
			super();
		}
		
		override protected function addToStageShow():void{
			var alertMCCls:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info,"AlertMC");
			var alert:MovieClip=new alertMCCls();
			module.addChild(alert);
			alert.x=alert.width/2;
			alert.y=alert.height/2;
			
			var alertWarnMC:MovieClip=alert.getChildByName("alertWarnMC") as MovieClip;
			alertTxt=alertWarnMC.getChildByName("alertTxt") as TextField;
			alertSureBtn=alertWarnMC.getChildByName("alertSureBtn") as SimpleButton;
		}
		
		override public function initShowView():void{
			layer.visible=false;
		}
		
		override protected function addEvents():void{
			alertSureBtn.addEventListener(MouseEvent.CLICK,sureClickHandler);
		}
		
		override protected function removeEvents():void{
			alertSureBtn.removeEventListener(MouseEvent.CLICK,sureClickHandler);
		}
		
		private function sureClickHandler(e:MouseEvent):void{
			isShow=false;
		}
		
		/**
		 * 
		 * @param $content
		 */
		public function updateAlertContent($content:String):void{
			if($content){
				alertTxt.text=$content;
			}
		}
	}
}