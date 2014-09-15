package com.zqvideo.view.core
{
	import flash.display.Sprite;

	public class ComponentView extends View
	{
		protected var rootContainer:Sprite=new Sprite();
		
		public function ComponentView()
		{
			super();
			
			if(Root.stage){
				stageWidth=Root.stage.stageWidth;
				stageHeight=Root.stage.stageHeight;
				addToStageShow();
			}else{
				throw new Error("ComponentView 无法初始化舞台");
			}
		}
		
		protected function addToStageShow():void{
			
			addEvents();
		}
		
		protected function addEvents():void{
			
		}
		
		protected function removeEvents():void{
			
		}
		
		public function updateSizeHandler():void
		{
			
		}
		
		public function destory():void{
			
		}
	}
}