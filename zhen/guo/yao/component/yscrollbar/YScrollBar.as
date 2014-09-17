
package zhen.guo.yao.component.yscrollbar
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;


	public class YScrollBar extends EventDispatcher {

		public static const V:String = "v";//纵向滚动条
		public static const H:String = "h";//横向滚动条
		
		public static const UP_OR_LEFT:String = "up_left";
		public static const DOWN_OR_RIGHT:String = "down_right";
		
		private var _x_y:String; 
		private var _width_height:String; 
		
		private var _scrollBar:Sprite;//滚动条
		
		private var _btnLeftUp:Sprite;//左或上按钮
		private var _btnRightDown:Sprite;//右或下按钮
		private var _block:Sprite;//滑块
		private var _path:Sprite;//滑道
		
		private var _allDistance:Number;//滑道的长度（减去被两个按钮占用的后的长度）
		private var _rollDistance:Number;//(滑块可滑动的距离)
		private var _blockStartPosition:Number;//滑块初始位置
		
		private var _currentValue:Number=0;//当前value值
		private var _scollType:String;//滚动模式（横向的还是纵向的）
		
		private var _minValue:Number=0;//最小值
		private var _maxValue:Number = 1;//最大值
		private var _step:Number = 5;//点击按钮时，滚动的步值
		
		private var _fun:Function;//value值改变时调用的方法

		/**
		 * 判断滚动条元件是否齐全
		 * @param	scrollBar
		 */
		private function checkObject(scrollBar:Sprite):void
		{
			_scrollBar=scrollBar;
			_btnLeftUp=_scrollBar.getChildByName("upLeftBtn") as Sprite;
			_btnRightDown=_scrollBar.getChildByName("downRightBtn") as Sprite;
			_block=_scrollBar.getChildByName("block") as Sprite;
			_path=_scrollBar.getChildByName("path") as Sprite;
			
			if (_block == null)
			{
				throw new Error("YScrollBar组件中没有找到【block】元件");
			}
			if (_path == null)
			{
				throw new Error("YScrollBar组件中没有找到【path】元件");
			}
		}
		/**
		 * 初始化滚动条对象
		 */
		private function  initObject():void
		{
			_block.visible=false;
			_block.buttonMode = true;
			
			if (_scollType == YScrollBar.V)
			{
				_x_y = "y";
				_width_height = "height";
			}
			else if (_scollType == YScrollBar.H)
			{
				_x_y = "x";
				_width_height = "width";
			}
			
			/* 如果没有按钮，则生成两个空的按钮，这样其他地方的代码就不用改了 */
			if (_btnLeftUp)
			{
				_btnLeftUp.buttonMode = true;
			}
			else
			{
				_btnLeftUp = new MovieClip();
				_btnLeftUp.x = _path.x;
				_btnLeftUp.y = _path.y;
				_scrollBar.addChild(_btnLeftUp);
			}
			if (_btnRightDown)
			{
				_btnRightDown.buttonMode = true;
			}
			else
			{
				_btnRightDown = new MovieClip();
				_btnRightDown.x = _path.x+_path.width;
				_btnRightDown.y = _path.y + _path.height;
				_scrollBar.addChild(_btnRightDown);
			}
			
			_allDistance=_btnRightDown[_x_y]-_btnLeftUp[_x_y]-_btnLeftUp[_width_height];//计算滑道总长度
			_blockStartPosition = _btnLeftUp[_x_y] + _btnLeftUp[_width_height];
			_block[_x_y] = _blockStartPosition;
			
			_btnLeftUp.addEventListener(MouseEvent.MOUSE_DOWN, leftUpBtnClickHandler);//点击左或上按钮
			_btnRightDown.addEventListener(MouseEvent.MOUSE_DOWN, rightDownBtnClickHandler);//点击右或下按钮
			_block.addEventListener(MouseEvent.MOUSE_DOWN, blockDownHandler);//点击滑块
			_path.addEventListener(MouseEvent.MOUSE_DOWN, pathClickHandler);//点击滑道
		}
		private function _refresh(per:Number, maxValue:Number,minValue:Number=0):void 
		{			
			if (per > 1)
			{
				_maxValue = maxValue;
				_minValue = minValue;
				
				_block.visible=true;
				_scrollBar.mouseChildren=true;

				_block[_width_height]=_allDistance*(1/per);
				_rollDistance=_btnRightDown[_x_y]-_btnLeftUp[_x_y]-_btnLeftUp[_width_height]-_block[_width_height];
				refreshBlockPosiitonByValue();
			} 
			else 
			{
				_maxValue = 0;
				_minValue = 0;
				
				_block.visible=false;
				_scrollBar.mouseChildren=false;
			}
		}
		private function dispatch():void
		{			
			if (_fun!=null)
			{
				_fun(_currentValue);
			}
		}
		private function blockDownHandler(event : MouseEvent):void 
		{
			_block.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);	
			_block.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);	
			
			var dragRect:Rectangle;
			if (_scollType == YScrollBar.V)
			{
				dragRect = new Rectangle(_block.x, _blockStartPosition, 0, _rollDistance);
			}
			else if (_scollType == YScrollBar.H)
			{
				dragRect = new Rectangle(_blockStartPosition, _block.y, _rollDistance, 0);
			}
			_block.startDrag(false, dragRect);
		}
        private function mouseMoveHandler(evn:MouseEvent):void
		{
			getValueByBlockPosition();
			dispatch();
		}
		private function mouseUpHandler(event : MouseEvent):void 
		{
			_block.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);	
			_block.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);	
			
			_block.stopDrag();
		}
		private function pathClickHandler(event : MouseEvent):void
		{
			var mousePosition:Number;
			var nowPosition:Number;
			
			if (_scollType == YScrollBar.H)
			{
				mousePosition = _scrollBar.mouseX; 
			}
			else if (_scollType == YScrollBar.V)
			{
				mousePosition = _scrollBar.mouseY; 
			}
			if (mousePosition <= _block[_x_y]&& mousePosition > _btnLeftUp[_x_y]+_btnLeftUp[_width_height])
			{
				nowPosition = mousePosition;
			}
			else if (mousePosition > _block[_x_y] + _block[_width_height] && mousePosition < _btnRightDown[_x_y])
			{
				if (mousePosition + _block[_width_height] > _btnRightDown[_x_y])
				{
					nowPosition = _btnRightDown[_x_y] - _block[_width_height];
				}
				else
				{
					nowPosition = mousePosition;
				}
			}	
			_block[_x_y] = nowPosition;
			getValueByBlockPosition();
			dispatch();
		}
		private function rightDownBtnClickHandler(event : MouseEvent):void 
		{
			blockScrollDown();
		}
		private function leftUpBtnClickHandler(event : MouseEvent):void
		{
			blockScrollUp();
		}
		//滑块向上滚
		private function blockScrollUp():void
		{
			if (_currentValue > _minValue)
			{
				if (_currentValue-_step > _minValue)
				{
					_currentValue-= _step;
				}
				else 
				{
					_currentValue = _minValue;
				}
				refreshBlockPosiitonByValue();
				dispatch();
			}
		}
		//滑块向下滚
		private function blockScrollDown():void
		{
			if (_currentValue < _maxValue)
			{
				if (_currentValue+_step < _maxValue)
				{
					_currentValue += _step;
				}
				else 
				{
					_currentValue = _maxValue;
				}
				refreshBlockPosiitonByValue();
				dispatch();
			}
		}
		/**
		 * 根据value值刷新滑块的位置
		 */
		private function refreshBlockPosiitonByValue():void
		{
			var per:Number = (_currentValue-_minValue) / (_maxValue-_minValue);
			_block[_x_y]=_btnLeftUp[_x_y] + _btnLeftUp[_width_height] + _rollDistance * per;
		}
		/**
		 * 根据滑块位置计算value值
		 */
		private function getValueByBlockPosition():void
		{
			_currentValue=(_block[_x_y]-(_btnLeftUp[_x_y]+_btnLeftUp[_width_height]))/_rollDistance*(_maxValue-_minValue)+_minValue;
		}
		
		/**
		 * 滚动滚动条
		 * @param	dir block滚动方向。向上(左)：YScrollBar.UP_OR_LEFT,向下（右）：YScrollBar.DOWN_OR_RIGHT
		 */
		public function scrollTo(dir:String):void
		{
		    if (dir == UP_OR_LEFT)
			{
				blockScrollUp();
			}
			else
			{
				blockScrollDown();
			}
		}
		/**
		 * 初始化滚动条
		 * @param	scrollBar 滚动条组件
		 * @param	scollType 显示模式（横向或者纵向）
		 */
		public function init(scrollBar:Sprite, scollType:String = YScrollBar.V):void
		{
			_scollType = scollType;
			
			checkObject(scrollBar);
			initObject();
		}
	    /**
	     * 重绘滚动条
	     * @param	per 显示区域（即遮罩）和内容的宽（高）比例
	     * @param	maxValue 最大值（即内容的高（宽）度和遮罩的高（宽）度的差值）
	     */
		public function refresh(per:Number, maxValue:Number,minValue:Number=0):void
		{
			_refresh(per,maxValue,minValue);
		}
		/**
		 * 释放对内容和滚动条对象的引用
		 */
		public function free():void
		{
			_btnLeftUp.removeEventListener(MouseEvent.MOUSE_DOWN, leftUpBtnClickHandler);//点击左或上按钮
			_btnRightDown.removeEventListener(MouseEvent.MOUSE_DOWN, rightDownBtnClickHandler);//点击右或下按钮
			_block.removeEventListener(MouseEvent.MOUSE_DOWN, blockDownHandler);//点击滑块
			_path.removeEventListener(MouseEvent.MOUSE_DOWN, pathClickHandler);//点击滑道
			
			_scrollBar = null;
			
			_block = null;
			_path = null;
			_btnLeftUp = null;
			_btnRightDown = null;
			_fun = null;
		}
		/**
		 * 即遮罩的纵（横）坐标值和内容的纵（横）坐标的差值
		 */
		public function get value():Number
		{
			return _currentValue;
		}
		public function set value(v:Number):void
		{
			if (v >= _minValue && v <= _maxValue)
			{
				_currentValue=v;
				refreshBlockPosiitonByValue();
				dispatch();
			}
			else
			{
				throw new Error("value 值小于了最小值，或者大于了最大值");
			}
		}
		/**
		 * value值改变时调用的方法
		 */
		public function set valueChangeHandler(fun:Function):void
		{
			_fun = fun;
		}
		/**
		 * 点击按钮时滚动的步值
		 */
		public function set step(n:Number):void
		{
			_step = n;
		}
		public function get step():Number
		{
			return _step;
		}
		/**
		 * 最大值
		 */
		public function set maxValue(n:Number):void
		{
			_maxValue = n;
			refreshBlockPosiitonByValue();
		}
		public function get maxValue():Number
		{
			return _maxValue;
		}
		/**
		 * 最小值
		 */
		public function set minValue(n:Number):void
		{
			_minValue = n;
			refreshBlockPosiitonByValue();
		}
		public function get minValue():Number
		{
			return _minValue;
		}
	}
}