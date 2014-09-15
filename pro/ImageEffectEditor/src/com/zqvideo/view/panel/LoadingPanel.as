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
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class LoadingPanel extends PanelView
	{
		private var loading:MovieClip;
		
		public function LoadingPanel()
		{
			module=new MovieClip();
			layer=LayerManager.addToLayer(this,module);
			
			super();
		}
		
		override protected function addToStageShow():void{
			var loadingCls:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info, "LoadingMC");
			loading=new loadingCls();
			module.addChild(loading);
			loading.x=loading.width/2;
			loading.y=loading.height/2;
		}
		
		override public function initShowView():void{
			layer.visible=false;
		}
		
		override public function set isShow(value:Boolean):void{
			_isShow=value;
			
			if(tween){
				tween.pause();
				tween=null;
			}
			
			if(value){
				layer.visible=true;
				layer.width=stageWidth;
				layer.height=stageHeight;
				tween=TweenMax.from(layer, 0.5, {alpha: 0, ease: Back.easeInOut, onComplete: tweenClose});
			}else{
				tween=TweenMax.to(layer, 0.5, {alpha: 0, ease: Back.easeInOut, onComplete: tweenClose});
			}
		}
	}
}