﻿package zhen.guo.yao.component.ycheckbox
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class YCheckBox extends Sprite
	{
		private var _container:DisplayObjectContainer
		private var _data:Array;
		
		public function YCheckBox():void 
		{
			
		}
		private function selectItem(item:MovieClip, dispatch:Boolean=true):void
		{
			if (item.selected)
			{
				item.btn.gotoAndStop(1);
			}
			else
			{
				item.btn.gotoAndStop(2);
			}
			item.selected = !item.selected;
			
			_data = getSelectedArray();
			
			if (dispatch)
			{
				var changedData:Object = new Object();
				changedData.value = item.value;
				changedData.label = item.label.text;
				changedData.selected = item.selected;
				
				var event:YCheckBoxEvent = new YCheckBoxEvent(YCheckBoxEvent.CHANGE);
				event.allData = _data
				event.changedDate = changedData;
				dispatchEvent(event);
			}
		}
		private function clickHandler(evn:MouseEvent):void
		{
			var item:MovieClip = evn.target as MovieClip;
			selectItem(item);
		}
		//获取选中的数据
		private function getSelectedArray():Array
		{
			var selectedArray:Array = [];
			var obj:Object = new Object();
			var n:uint = _container.numChildren;
			for (var i = 0; i < n; i++ )
			{
				var item:MovieClip = _container.getChildAt(i) as MovieClip;
				if (item.selected)
				{
					obj.value = item.value;
					obj.label = item.value;
					selectedArray.push(obj);
				}
			}
			return selectedArray;
		}
		/********************** 公共方法 ***************************/
		/**
		 * 设置按钮
		 * @param	container 按钮容器
		 */
		public function setComponent(container:DisplayObjectContainer):void
		{
			_container = container;
			
			var n:uint = _container.numChildren;
			for (var i = 0; i < n; i++ )
			{
                var item:MovieClip = _container.getChildAt(i) as MovieClip;
				item.selected = false;
				item.btn.gotoAndStop(1);
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