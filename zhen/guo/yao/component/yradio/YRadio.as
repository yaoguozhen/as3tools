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
		private var _data:Object
		private var _container:DisplayObjectContainer
		
		public function YRadio():void 
		{
			
		}
		private function clickHandler(evn:MouseEvent):void
		{
			var item:MovieClip = evn.target as MovieClip;
			selectItem(item);
		}
		private function selectItem(item:MovieClip, dispatch:Boolean=true):void
		{
			if (_currentItem != item)
			{
				if (_currentItem)
				{
					_currentItem.btn.gotoAndStop(1);
				}
				
				_currentItem = item;
				_currentItem.btn.gotoAndStop(2);
				
				_data = new Object();
				_data.value = _currentItem.value;
				_data.label = _currentItem.label.text;
				
				if (dispatch)
				{
					var event:YRadioEvent = new YRadioEvent(YRadioEvent.CHANGE);
					event.data = _data
					dispatchEvent(event);
				}
			}
		}
		/********************** 公共方法 ***************************/
		/**
		 * 设置按钮
		 * @param	container 单选按钮容器
		 */
		public function setComponent(container:DisplayObjectContainer):void
		{
			_container = container;
			var n:uint = _container.numChildren;
			
			for (var i = 0; i < n; i++ )
			{
                var item:MovieClip = _container.getChildAt(i) as MovieClip;
				item.btn.gotoAndStop(1)
				item.buttonMode = true;
				item.mouseChildren = false;
				_container.addEventListener(MouseEvent.CLICK,clickHandler)
			}
		}
        
		/**
		 * 当前选中的数据
		 */
		public function get data():Object
		{
			return _data
		}
		
		/**
		 * 根据value值选则某个
		 * @param	value value值
		 */
		public function select(value:Object):void
		{
			var n:uint = _container.numChildren;
			
			for (var i = 0; i < n; i++ )
			{
                var item:MovieClip = _container.getChildAt(i) as MovieClip;
				if (item.value == value)
				{
					selectItem(item, false);
					break;
				}
			}
		}
	}
	
}