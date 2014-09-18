package zhen.guo.yao.component.ylist
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	internal class YListDefaultItem extends Sprite
	{
		private var _label:String=""
		private var _value:Object;
		
		private var _text:TextField;
		private var _thisItemSelected:Boolean=false;
		
		private var _selectedColor:Number = 0x0000ff;//选中颜色
		private var _defaultColor:Number = 0x000000;//默认颜色
		private var _rollOverColor:Number = 0x0000ff;//划过颜色
		
		private var _fontSize:Number = 12;
		
		public function YListDefaultItem():void
		{			
			_text=creatItem(120,19,_fontSize,_defaultColor);
			addChild(_text);
		}
		protected function rollOverHandler():void
		{
			setTextColor(_rollOverColor);
		}
		protected function rollOutHandler():void
		{
			if(_thisItemSelected)
			{
				setTextColor(_selectedColor);
			}
			else
			{
				setTextColor(_defaultColor);
			}
		}
		private function setTextColor(color:Number):void
		{
			var textFomat:TextFormat=new TextFormat(null,_fontSize,color);
			_text.setTextFormat(textFomat);
		}
		private function creatItem(w:Number,h:Number,fontSize:Number,color:Number):TextField
		{
			var text:TextField=new TextField();
			text.width=w
			text.height=h
			text.defaultTextFormat=new TextFormat(null,fontSize,color);
			return text;
		}
		private function _selected(b:Boolean):void
		{
			_thisItemSelected = b;
			if(_thisItemSelected)
			{
				setTextColor(_selectedColor);
			}
			else
			{
				setTextColor(_defaultColor);
			}
		}
		private function _dataSource(data:Object):void
		{
			if(data is Array)
			{
				_label = data[0];
				_value = data[1];
			}
			else if (data is XML)
			{
				_label = data.@label.toString();
				_value = data.@value.toString();
			}
			else
			{
				_label = data.label.toString();
				_value = data.value.toString();
			}
			_text.text = _label;
		}
        private function _mouseAction(action:String):void
		{
			switch(action)
			{
				case MouseEvent.ROLL_OVER:
					rollOverHandler();
					break;
				case MouseEvent.ROLL_OUT:
					rollOutHandler();
					break;
			}
		}
		private function _resize(w:Number):void
		{
			_text.width = w;
		}
		
		/*****************************  list组件调用  ******************************/
		/**
		 * 设置数据
		 */
		public function set dataSource(data:Object):void
		{
			_dataSource(data);
		}
		
		/**
		 * 设置选中状态
		 */
		public function set selected(b:Boolean):void
		{
			_selected(b);
		}
		/**
		 * 鼠标动作
		 * @param	action 动作名称。鼠标点击:MouseEvent.CLICK；鼠标划过:MouseEvent.MOUSE_OVER；鼠标离开:MouseEvent.MOUSE_OUT
		 */
		public function mouseAction(action:String):void
		{
			_mouseAction(action);
		}
		/**
		 * 重设item长度
		 * @param	w
		 */
		public function resize(w:Number):void
		{
			_resize(w);
		}
	}
}