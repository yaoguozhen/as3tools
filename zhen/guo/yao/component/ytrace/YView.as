package zhen.guo.yao.component.ytrace 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author yaoguozhen
	 */
	internal class YView extends Sprite
	{
		private var _mask:Sprite;//遮罩
		private const BTN_HEIGHT:Number = 40;//按钮区域高度
		private var _content:TextField;
		private var _index:uint = 0;
		/**
		 * 构造函数
		 * @param	w 宽度
		 * @param	h 高度
		 */
		public function YView() :void
		{
			_content = new TextField();
			
			_content = new TextField();
			_content.width = YData.areaWidth;
			_content.height = YData.areaHeight-BTN_HEIGHT;
            _content.multiline = true;
			_content.wordWrap = true; 
			addChild(_content);
			
			_mask = getMask(YData.areaWidth, YData.areaHeight - BTN_HEIGHT);
			_content.mask = _mask;
			addChild(_mask);
			
		}
		/**
		 * 生成遮罩
		 * @param	w 高度
		 * @param	h 宽度
		 * @return 遮罩
		 */
		private function getMask(w:Number,h:Number):Sprite
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0x0000ff);
			sprite.graphics.drawRect(0, 0, w, h);
			return sprite;
		}
		/**
		 * 添加信息
		 * @param	type 信息类型
		 * @param	msg 信息内容
		 */
		public function add(msg:String,msgType:String):void
		{
			var newMsg:String;
			_index++;
			switch(msgType)
			{
				case YTrace.ALERT:
					newMsg= "<font color='#0000ff'>"+_index+". "+msg+"</font><br>";
					break;
				case YTrace.ERROR:
					newMsg= "<font color='#FF0000'>"+_index+". "+msg+"</font><br>";
					break;
				case YTrace.ALL:
					newMsg="<font color='#000000'>"+_index+". "+msg+"</font><br>";
					break;
			}
			_content.htmlText += newMsg;
		}
		public function rollUp():void
		{
			_content.scrollV -= 1;
		}
		public function rollDown():void
		{
			_content.scrollV += 1;
		}
		/**
		 * 清空信息
		 * @param	type "alert":清空警告信息 "error":清除错误信息 "":清除全部信息
		 */
		public function clear(type:String = ""):void
		{
			_index = 0;
			_content.htmlText="";
		}
	}

}