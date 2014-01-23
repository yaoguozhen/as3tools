package zhen.guo.yao.ytrace 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class YTrace
	{
		public static const ALERT:String = "alert";
		public static const ERROR:String = "error";
		public static const ALL:String = "";
		internal static const CLEAR:String = "clear";
		internal static const NEXT_PAGE:String = "nextPage";
		internal static const PREV_PAGE:String = "prevPage";
		
		private static var _container:Sprite;//其中包含控制条，内容，边框
		
		private static var _data:YData;
		
		private static var _controller:YController;//控制条
		private static var _view:YView;//内容
		private static var _frame:Sprite;//边框
		
		private static var _stage:Stage;
		private static var _keyPressletterArray:Array;
		private static var _key:String;//秘籍
		private static var _currentType:String;//当前类型
		
		private static function btnClickHandler(evn:YBtnClickEvent):void
		{
			
			switch(evn.btnType)
			{
				case YTrace.ALERT:
				case YTrace.ERROR:
				case YTrace.ALL:
					_view.clear();
					_currentType = evn.btnType;
					var n:uint = YData.msgArray.length;
					
					for (var i:uint = 0; i < n; i++ )
					{
						if (evn.btnType == YTrace.ALL)
						{
							_view.add(YData.msgArray[i][0],YData.msgArray[i][1]);
						}
						else
						{
							if (YData.msgArray[i][1] == evn.btnType)
							{
								_view.add(YData.msgArray[i][0],evn.btnType);
							}
						}
					}
					break;
				case YTrace.CLEAR:
					_view.clear();
					_data.clearMsg();
					break;
				case YTrace.NEXT_PAGE:
					_view.rollDown();
					break;
				case YTrace.PREV_PAGE:
					_view.rollUp();
					break;
			}
		}
		private static function creatFrame(w:Number,h:Number):Sprite
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.lineStyle(1, 0x000000);
			sprite.graphics.moveTo(0, 0);
			sprite.graphics.lineTo(0, h);
			sprite.graphics.lineTo(w, h);
			sprite.graphics.lineTo(w, 0);
			sprite.graphics.lineTo(0, 0);
			return sprite;
		}
		private static function stageOnKeyDownHandler023(evn:KeyboardEvent):void
		{
			_keyPressletterArray.push(String.fromCharCode(evn.charCode));
			if (_keyPressletterArray.length > _key.length)
			{
				_keyPressletterArray.shift()
			}
			if (_keyPressletterArray.join("") == _key)
			{
				_stage.addChild(_container);
			}
			else
			{
				if (_container.stage != null)
				{
					_stage.removeChild(_container);
				}
			}
		}
		private static function dataChangeHandler(evn:Event):void
		{
			var msgType:String = YData.msgArray[YData.msgArray.length - 1][1];
			
			if (msgType == _currentType||_currentType==YTrace.ALL)
			{
				
				_view.add(YData.msgArray[YData.msgArray.length-1][0],msgType);
			}
			
			_controller.setCount(msgType, _data.getCount(msgType));
			if (msgType != "")
			{
				_controller.setCount("", _data.getCount(""));
			}
		}
		private static function clearMsgHandler(evn:Event):void
		{
			_controller.clearMsg();
		}
		
		/**
		 * 初始化
		 * @param	obj stage
		 * @param	key 密集
		 * @param	areaWidth 显示区域的宽度
		 * @param	areaHeight 显示区域的高度
		 */
		public static function init(obj:Stage,key:String,areaWidth:Number=500,areaHeight:Number=300) :void
		{
			YData.areaWidth = areaWidth;
			YData.areaHeight = areaHeight;
			
			_stage = obj;
			_key = key;
			
			_keyPressletterArray = [];
			
			_currentType = YTrace.ALL;
			
			_data = new YData();
			_data.addEventListener("dataChanged",dataChangeHandler);
			_data.addEventListener("clearMsg",clearMsgHandler);
			
			_container = new Sprite();
			
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0xffffff);
			bg.graphics.drawRect(0, 0, areaWidth, areaHeight);
			_container.addChild(bg);
			
			_frame = creatFrame(YData.areaWidth, YData.areaHeight);
			_container.addChild(_frame);
			
			_controller = new YController();
			_controller.addEventListener(YBtnClickEvent.BTN_CLICK, btnClickHandler);
			_container.addChild(_controller);
			
			_view = new YView();
			_container.addChild(_view);

			_stage.addEventListener(KeyboardEvent.KEY_DOWN, stageOnKeyDownHandler023);
		}
		/**
		 * 添加信息
		 * @param	type 信息类型
		 * @param	msg 信息内容
		 */
		public static function add(msgType:String,msg:String):void
		{
			_data.addMsg(msg, msgType);
		}
	}

}