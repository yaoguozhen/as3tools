
package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;


	public class YScrollBar2 extends EventDispatcher {

		public static const V:String = "v";//纵向滚动条
		public static const H:String = "h";//横向滚动条
		
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
		private var _ease:Number;//缓动系数，不可<1
		
		private var _count:uint;
		private var _index:uint=1;
		
		private var _scollType:String;//滚动模式（横向的还是纵向的）
        
		private function checkObject(scrollBar:Sprite)
		{
			_scrollBar=scrollBar;
			_btnLeftUp=_scrollBar.getChildByName("upLeftBtn") as Sprite;
			_btnRightDown=_scrollBar.getChildByName("downRightBtn") as Sprite;
			_block=_scrollBar.getChildByName("block") as Sprite;
			_path=_scrollBar.getChildByName("path") as Sprite;
			
			if (_btnLeftUp == null)
			{
				throw new Error("YScrollBar2组件中没有找到【upLeftBtn】元件");
			}
			if (_btnRightDown == null)
			{
				throw new Error("YScrollBar2组件中没有找到【downRightBtn】元件");
			}
			if (_block == null)
			{
				throw new Error("YScrollBar2组件中没有找到【block】元件");
			}
			if (_path == null)
			{
				throw new Error("YScrollBar2组件中没有找到【path】元件");
			}
		}
		private function  initObject()
		{			
			if (_scollType == YScrollBar2.V)
			{
				_x_y = "y";
				_width_height = "height";
			}
			else if (_scollType == YScrollBar2.H)
			{
				_x_y = "x";
				_width_height = "width";
			}
			
			_allDistance=_btnRightDown[_x_y]-_btnLeftUp[_x_y]-_btnLeftUp[_width_height];//计算滑道总长度
			_blockStartPosition = _btnLeftUp[_x_y] + _btnLeftUp[_width_height];
			_block[_x_y] = _blockStartPosition;
			
			_refresh();
			
			_btnLeftUp.addEventListener(MouseEvent.MOUSE_DOWN, leftUpBtnClickHandler);//点击左或上按钮
			_btnRightDown.addEventListener(MouseEvent.MOUSE_DOWN, rightDownBtnClickHandler);//点击右或下按钮
			_block.addEventListener(MouseEvent.MOUSE_DOWN, blockClickHandler);//点击滑块
			//_path.addEventListener(MouseEvent.MOUSE_DOWN, pathClickHandler);//点击滑道
		}
		private function _refresh(event : MouseEvent = null):void 
		{        
		        _block[_width_height]=_allDistance/_count;
				_rollDistance=_allDistance-_block[_width_height];
				_block[_x_y] =_btnLeftUp[_x_y]+_btnLeftUp[_width_height]
		}
		private function blockClickHandler(event : MouseEvent):void 
		{
			_block.stage.addEventListener(MouseEvent.MOUSE_UP, poleUp);	
			_block.stage.addEventListener(MouseEvent.MOUSE_MOVE, blockStageMouseMoveHandler);	
			var dragRect:Rectangle;
				if (_scollType == YScrollBar2.V)
				{
					dragRect = new Rectangle(_block.x, _blockStartPosition, 0, _rollDistance);
				}
				else if (_scollType == YScrollBar2.H)
				{
					dragRect = new Rectangle(_blockStartPosition, _block.y, _rollDistance, 0);
				}
				_block.startDrag(false, dragRect);
				//_scrollBar.addEventListener(Event.ENTER_FRAME, poleDown);

		}

		private function blockStageMouseMoveHandler(event : Event):void 
		{
			var dis=_block[_x_y]-(_btnLeftUp[_x_y]+_btnLeftUp[_width_height]);
			var per=int(_allDistance/_count);
			var n=int(dis/per)+1;
			if(_index!=n)
			{
				_index=n;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		private function poleUp(event : MouseEvent):void 
		{
			_block.stage.removeEventListener(MouseEvent.MOUSE_UP, poleUp);
			_block.stage.removeEventListener(MouseEvent.MOUSE_MOVE, blockStageMouseMoveHandler);	

			_block.stopDrag();
			
			refreshBlockPosition(_index);
		}
		private function refreshBlockPosition(index:uint):void
		{
			_block[_x_y]=_btnLeftUp[_x_y]+_btnLeftUp[_width_height]+(index-1)*(_allDistance/_count);
			dispatchEvent(new Event(Event.CHANGE));
		}
		private function rightDownBtnClickHandler(event : MouseEvent=null):void 
		{
			if(_index<_count)
			{
				_index++;
				refreshBlockPosition(_index);
			}
		}
		private function leftUpBtnClickHandler(event : MouseEvent=null):void
		{
			if(_index>1)
			{
				_index--;
				refreshBlockPosition(_index);
			}
		}
		/**
		 * 关联被滚动的内容和滚动组件
		 * @param	scollType 显示模式（横向或者纵向）
		 * @param	ease 缓动系数，不可<1
		 */
		public function init(count:uint,scrollBar:MovieClip,scollType:String = YScrollBar2.V, ease:Number = 0)
		{			
			_scollType = scollType;
			_count=count;
			
			_ease = ease;
			if (ease <= 1)
			{
				_ease = 1;
			}
			
			checkObject(scrollBar);
			initObject();
		}
		/**
		 * 重绘
		 */
		public function refresh():void
		{
			_refresh();
		}
		/**
		 * 释放对内容和滚动条对象的引用
		 */
		public function free():void
		{
			_btnLeftUp.removeEventListener(MouseEvent.MOUSE_DOWN, leftUpBtnClickHandler);//点击左或上按钮
			_btnRightDown.removeEventListener(MouseEvent.MOUSE_DOWN, rightDownBtnClickHandler);//点击右或下按钮
			_block.removeEventListener(MouseEvent.MOUSE_DOWN, blockClickHandler);//点击滑块
			//_path.removeEventListener(MouseEvent.MOUSE_DOWN, pathClickHandler);//点击滑道
			
			_scrollBar = null;
			
			_block = null;
			_path = null;
			_btnLeftUp = null;
			_btnRightDown = null;
		}
		public function scroll(dir:String):void
		{
			switch(dir)
			{
				case "up":
					rightDownBtnClickHandler();
					break;
				case "down":
					leftUpBtnClickHandler();
					break;
			}
		}
		public function get index():uint
		{
			return _index;
		}
	}
}