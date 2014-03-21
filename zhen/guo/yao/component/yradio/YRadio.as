package zhen.guo.yao.component.yradio
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class YRadio extends Sprite
	{
		private var _currentItem:MovieClip
		
		public function YRadio():void 
		{
			
		}
		private function clickHandler(evn:MouseEvent):void
		{
			var item:MovieClip = evn.target as MovieClip;
			if (_currentItem)
			{
				if (_currentItem != item)
				{
					_currentItem.btn.gotoAndStop(1);
				}
			}
			_currentItem = item;
			_currentItem.btn.gotoAndStop(2);
			
			var obj:Object = new Object();
			obj.value = _currentItem.value;
			obj.label = _currentItem.label.text;
			var event:YRadioEvent = new YRadioEvent(YRadioEvent.CHANGE);
			event.data = obj
			dispatchEvent(event);
		}
		/********************** 公共方法 ***************************/
		/**
		 * 设置按钮
		 * @param	container 单选按钮容器
		 */
		public function setComponent(container:DisplayObjectContainer):void
		{
			var n:uint = container.numChildren;
			
			for (var i = 0; i < n; i++ )
			{
                var item:MovieClip = container.getChildAt(i) as MovieClip;
				item.btn.gotoAndStop(1)
				item.buttonMode = true;
				item.mouseChildren = false;
				container.addEventListener(MouseEvent.CLICK,clickHandler)
			}
		}

	}
	
}