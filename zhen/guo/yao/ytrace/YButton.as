package zhen.guo.yao.ytrace 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author yaoguozhen
	 */
	internal class YButton extends Sprite 
	{
		private var _label:TextField;//按钮文字
		private var _defaultBg:Sprite;//默认背景
		private var _currentBg:Sprite;//当前背景
		private var _selected:Boolean;//按钮是否被选中
		private var _btnName:String;//按钮名字
		private const DIS:Number = 5;
		
		/**
		 * 构造函数
		 * @param	label 按钮文字
		 */
		public function YButton(label:String) :void
		{
			_selected = false;
			
			//设置按钮文字
		    _label = new TextField();
			_label.autoSize = TextFieldAutoSize.LEFT;
			_label.text = label;
			_label.x = DIS;
			_label.y = DIS;
			
			//生成背景
			_defaultBg = getBtnBg(0x999999);
			_currentBg = getBtnBg(0xcccccc);
			changeBgSize(_label,new Array(_defaultBg,_currentBg));
			
			addChild(_defaultBg);
			addChild(_label);	
			
			this.mouseChildren = false;
			this.buttonMode = true;
		}
		/**
		 * 生成按钮背景
		 * @param	color 颜色
		 * @return 背景
		 */
		private function getBtnBg(color:uint):Sprite
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(color);
			sprite.graphics.drawRect(0, 0, 10, 10);
			return sprite;
		}
		/**
		 * 根据文字多少改变背景长度
		 * @param	text 文字
		 * @param	array 按钮数组
		 */
		private function changeBgSize(text:TextField,array:Array):void
		{
			var length:uint = array.length;
			for (var i:uint = 0; i < length; i++)
			{
				array[i].width = text.width + DIS * 2;
				array[i].height = text.height + DIS * 2;
			}
		}
		/**
		 * 按钮是否被选中
		 */
		public function get selected():Boolean
		{
		    return _selected;
		}
		public function set selected(b:Boolean):void
		{
			if (b)
			{
				if (!_selected)
				{
					_selected = true;
					addChild(_currentBg);
					removeChild(_defaultBg);
					this.buttonMode = false;
					
					addChild(_label);	
				}
			}
			else
			{
				if (_selected)
				{
					_selected = false;
					addChild(_defaultBg);
					removeChild(_currentBg);
					this.buttonMode = true;
					
					addChild(_label);	
				}
			}
		}
		/**
		 * 按钮显示文字
		 */
		public function set label(label:String):void
		{
			_label.text = label;
			changeBgSize(_label,new Array(_defaultBg,_currentBg));
		}
		/**
		 * 按钮名字
		 */
		public function get btnType():String
		{
			return _btnName;
		}
		public function set btnType(s:String):void
		{
			_btnName = s;
		}
	}

}