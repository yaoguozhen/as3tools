package zhen.guo.yao.component.yradio
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.engine.GroupElement;
	import flash.ui.Mouse;
	
	public class YRadio extends Sprite
	{
		private var _currentRadio:MovieClip
		
		public function YRadio():void 
		{
			
		}
		private function clickHandler(evn:MouseEvent):void
		{
			var radio:MovieClip = evn.target as MovieClip;
			if (_currentRadio)
			{
				if (_currentRadio != radio)
				{
					_currentRadio.btn.gotoAndStop(1);
				}
			}
			_currentRadio = radio;
			_currentRadio.btn.gotoAndStop(2);
			
			var event:YRadioEvent = new YRadioEvent(YRadioEvent.CHANGE);
			event.value = _currentRadio.value;
			event.label = _currentRadio.label.text;
			dispatchEvent(event);
		}
		/********************** 公共方法 ***************************/
		/**
		 * 设置单选按钮
		 * @param	radioContainer 单选按钮容器
		 */
		public function setRadios(radioContainer:DisplayObjectContainer):void
		{
			var n:uint = radioContainer.numChildren;
			for (var i = 0; i < n; i++ )
			{
                var radio:MovieClip = radioContainer.getChildAt(i) as MovieClip;
				radio.btn.gotoAndStop(1)
				radio.buttonMode = true;
				radio.mouseChildren = false;
				radioContainer.addEventListener(MouseEvent.CLICK,clickHandler)
			}
		}

	}
	
}