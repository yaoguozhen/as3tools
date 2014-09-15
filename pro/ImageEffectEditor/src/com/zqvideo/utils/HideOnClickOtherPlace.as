package com.zqvideo.utils
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 *鼠标点击目标之外的地方时，调用传入的方法 
	 * @author yaoguozhen
	 * 
	 */    
	public class HideOnClickOtherPlace
	{
		private var _target:DisplayObject;
		private var _fun:Function;
		private var _rollOver:Boolean=false;
		private var _stage:Stage;
		
		public function HideOnClickOtherPlace():void
		{
			
		}
		private function stageMouseDownHandler1(e:MouseEvent):void
		{
			if(_rollOver)
			{
				
			}
			else
			{
				_fun();
			}
		}
		
		private function rollOverHandler(event:Event):void
		{
			_rollOver=true;
			_target.addEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
		}
		
		private function rollOutHandler(event:Event):void
		{
			_rollOver=false
			_target.removeEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
		}
		public function setObject(s:Stage,obj:DisplayObject,fun:Function):void
		{
			_stage=s;
			_fun=fun;
			_target=obj;
			
			_stage.addEventListener(MouseEvent.MOUSE_DOWN,stageMouseDownHandler1);
			_target.addEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
		}
	}
}