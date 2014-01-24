package zhen.guo.yao.component.yslider
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.engine.GroupElement;
	import flash.ui.Mouse;
	
	public class YSlider extends EventDispatcher
	{
		private var _path:Sprite;
		private var _block:Sprite;
		private var _respondPathClick:Boolean=true;//是否支持滑条点击
		private var _blockPressed:Boolean=false;
		private var _consecutiveDispatch:Boolean = true;//是否持续调用change事件
		private var _minValue:Number = 0;//最小值
		private var _maxValue:Number = 1;//最大值
		private var _enabled:Boolean = true;//是否可用
		
		public function YSlider():void 
		{
			
		}
		//检查对象是否存在
		private function checkObject(obj:Sprite):void
		{
			_path = obj.getChildByName("path") as Sprite;
			_block = obj.getChildByName("block") as Sprite;
			//检查‘path’元件是否存在
			if (_path == null)
			{
				throw new Error("slider组件中没有找到【path】元件");
			}
			if (_block == null)
			{
				throw new Error("slider组件中没有找到【block】元件");
			}
		}
		private function initObject():void
		{
			_block.x = _path.x-_block.width/2;
			_block.buttonMode = true;	
			_path.buttonMode = true;
			
			if (_enabled)
			{
				_path.addEventListener(MouseEvent.CLICK, pathClickHandler);
				_block.addEventListener(MouseEvent.MOUSE_DOWN, blockMouseDownHandler);
			}
		}
		//检查边界值
		private function checkBoundaryValue(minValue:Number=0,maxValue:Number=1):void
		{
			if (minValue < maxValue)
			{
				_minValue = minValue;
				_maxValue = maxValue;
			}
			else
			{
				throw new Error("minValue 必须小于 maxValue");
			}
		}
		//滑条点击事件
		private function pathClickHandler(evn:MouseEvent):void
		{
			if (_enabled)
			{
				if (_respondPathClick)
				{
					_block.x = _path.mouseX - _block.width / 2;
					_dispatchEvent(YSliderEvent.CHANGE);
				}
			}
		}
		//按下滑块，并拖动
		private function sliderCursorMouseMoveHandler(evn:MouseEvent):void
		{						
			if (_consecutiveDispatch)//如果不是持续调度‘change’事件
			{
				_dispatchEvent(YSliderEvent.CHANGE);
			}
		}
		//根据滑块位置获得当前值
		private function getCurrentValue():Number
		{
			var per:Number = (_block.x+_block.width/2-_path.x) / _path.width;
			return _minValue + per * (_maxValue - _minValue);
		}
		private function _dispatchEvent(eventType:String):void
		{
			var event:YSliderEvent = new YSliderEvent(eventType);
			event.value = { "value":currentValue, "per":currentPercent }
			dispatchEvent(event);
		}
		//鼠标在滑块上按下
		private function blockMouseDownHandler(evn:MouseEvent):void
		{
			if (_enabled)
			{
				_block.startDrag(false, new Rectangle(_path.x - _block.width / 2, _block.y, _path.width, 0));
				
				_blockPressed = true;
				_block.removeEventListener(MouseEvent.MOUSE_DOWN, blockMouseDownHandler);
				_block.stage.addEventListener(MouseEvent.MOUSE_MOVE, sliderCursorMouseMoveHandler);
				_block.stage.addEventListener(MouseEvent.MOUSE_UP, sliderCursorMouseUpHandler);
				_dispatchEvent(YSliderEvent.BLOCK_PRESSED);
			}
		}
		//鼠标松开滑块
		private function sliderCursorMouseUpHandler(evn:MouseEvent):void
		{
			if (_blockPressed)
			{
				_block.stopDrag();
				
				if (!_consecutiveDispatch)//如果不是持续调度‘change’事件
				{
					_dispatchEvent(YSliderEvent.CHANGE);
				}
				_block.addEventListener(MouseEvent.MOUSE_DOWN, blockMouseDownHandler);
				_block.stage.removeEventListener(MouseEvent.MOUSE_MOVE, sliderCursorMouseMoveHandler);
				_block.stage.removeEventListener(MouseEvent.MOUSE_UP, sliderCursorMouseUpHandler);
				_dispatchEvent(YSliderEvent.BLOCK_RELEASED);
			}
			_blockPressed = false;
		}
		//根据值获得百分比
		private function getPercent(value:Number):Number
		{
			if (value > _maxValue || value < _minValue)
			{
				throw new Error("设置的值超过范围");
			}
			else
			{
				return (value-_minValue)/(_maxValue-_minValue);
			}
			return 0;
		}
		//根据百分比设置滑块位置
		private function setBlockPosition(per:Number):void
		{
			_block.x = _path.x + per * _path.width - _block.width / 2;
		}
		
		/********************** 公共方法 ***************************/
		
		/**
		 * 初始化slider组件
		 * @param	content 组件对象
		 * @param	minValue 最小值。默认0
		 * @param	maxValue 最大值。默认1
		 * @param	consecutiveDispatch 是否连续出发change事件
		 * @param	respondPathClick 滑条是否支持点击。默认true
		 */
		public function init(content:MovieClip,minValue:Number=0,maxValue:Number=1,consecutiveDispatch:Boolean=true,respondPathClick:Boolean=true):void
		{
			if (_block)
			{
				throw new Error("只允许绑定一个组件");
			}
			else
			{
				checkObject(content);
				checkBoundaryValue(minValue, maxValue);
				initObject();
				
				_consecutiveDispatch = consecutiveDispatch;
				_respondPathClick = respondPathClick;
			}
		}
		/********************** 公共属性 ***************************/
		//获取最小值。
		public function get minValue():Number
		{
			return _minValue;
		}
		//获取最大值。
		public function get maxValue():Number
		{
			return _maxValue;
		}
		//获取当前值。
		public function get currentValue():Number
		{
			return getCurrentValue();
		}
		//设置当前值
		public function set currentValue(n:Number):void
		{
			if (_enabled)
			{
				if (n < _minValue||n > _maxValue)
				{
					throw new Error("设置的 currentValue 值超过范围");
				}
				else
				{
				    var per:Number = getPercent(n);
					setBlockPosition(per);
				}
			}
		}
		
		//当前百分比
		public function get currentPercent():Number
		{
			return getPercent(getCurrentValue());
		}
		public function set currentPercent(n:Number):void
		{
			if (_enabled)
			{
				if (n<=1&&n>=0)
				{
					setBlockPosition(n);
				}
				else
				{
					throw new Error("设置的'currentPercent'值应该<=1并且>=0");
				}
			}
		}

		//组件是否被激活
		public function get active():Boolean
		{
			return _enabled;
		}
		public function set active(b:Boolean):void
		{			
			_enabled = b;
			if (_enabled)
			{
				_block.addEventListener(MouseEvent.MOUSE_DOWN, blockMouseDownHandler);
				_path.addEventListener(MouseEvent.CLICK, pathClickHandler);
			}
			else
			{
				_block.removeEventListener(MouseEvent.MOUSE_DOWN, blockMouseDownHandler);
				_path.removeEventListener(MouseEvent.CLICK, pathClickHandler);
			}
			_block.buttonMode = _enabled;
			_path.buttonMode=_enabled
		}
		//block是否被按下
		public function get blockPressed():Boolean
		{
			return _blockPressed
		}
	}
	
}