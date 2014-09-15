package com.zqvideo.view.core
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.MovieClip;

	public class PanelView extends View
	{
		protected var layer:MovieClip;
		protected var module:MovieClip;
		
		protected var _isShow:Boolean=false;
		protected var tween:TweenMax=null; 
		
		public function PanelView()
		{
			super();
			
			if(Root.stage){
				stageWidth=Root.stage.stageWidth;
				stageHeight=Root.stage.stageHeight;
				addToStageShow();
			}else{
				throw new Error("PanelView 无法初始化舞台");
			}
		}
		
		protected function addToStageShow():void{
			
		}
		
		/**
		 * 
		 * @param updateObj
		 */
		public function updatePanel(updateObj:Object):void{
			
		}
		
		protected function addEvents():void{
			
		}
		
		protected function removeEvents():void{
			
		}
		
		public function initShowView():void{
			
		}
		
		public function resetShowView():void{
			
		}
		
		public function destory():void{
			
		}
		
		
		/**
		 * 
		 * @return 
		 */
		public function get isShow():Boolean{
			return _isShow;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set isShow(value:Boolean):void{
			_isShow=value;
			
			if(tween){
				tween.pause();
				tween=null;
			}
			
			if(value){
				
				addEvents();
				layer.visible=true;
				layer.width=Root.stage.stageWidth;
				layer.height=Root.stage.stageHeight;
				tween=TweenMax.from(layer,0.5,{alpha:0,ease:Back.easeInOut,onComplete:tweenClose});
			}else{
				removeEvents();
				tween=TweenMax.to(layer,0.5,{alpha:0,ease:Back.easeInOut,onComplete:tweenClose});
			}
			
		}
		
		protected function tweenClose():void{
			if(tween){
				tween.pause();
				tween=null;
			}
			
			if(_isShow==false){
				layer.width=stageWidth;
				layer.height=stageHeight;
				layer.alpha=1;
				layer.visible=false;
			}
		}
		
		/**
		 * 
		 * @param widthNum
		 * @param heightNum
		 */
		public function updateSize(widthNum:Number, heightNum:Number):void
		{
			stageWidth=widthNum;
			stageHeight=heightNum;
			updateSizeHandler();
		}
		
		public function updateSizeHandler():void
		{
			
		}
	}
}