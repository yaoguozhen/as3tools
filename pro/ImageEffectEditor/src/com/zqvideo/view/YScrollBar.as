
package  com.zqvideo.view
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;


	public class YScrollBar extends EventDispatcher {

		public static const V:String = "v";//纵向滚动条
		public static const H:String = "h";//横向滚动条
		
		private var _x_y:String; 
		private var _width_height:String; 
		
		private var _area_width_height:Number;
		private var _area_x_y:Number;
		
		private var _content:Sprite;//内容
		private var _scrollBar:Sprite;//滚动条
		
		private var _btnLeftUp:Sprite;//左或上按钮
		private var _btnRightDown:Sprite;//右或下按钮
		private var _block:Sprite;//滑块
		private var _path:Sprite;//滑道
		
		private var _allDistance:Number;//滑道的长度（减去被两个按钮占用的后的长度）
		private var _rollDistance:Number;//(滑块可滑动的距离)
		private var _blockStartPosition:Number;//滑块初始位置
		private var _ease:Number;//缓动系数，不可<1
		
		private var _putTime:Number;
		
		private var _areaWidth:Number;//显示区域的宽度
		private var _areaHeight:Number;//显示区域的高度
		private var _areaX:Number;//显示区域的横坐标
		private var _areaY:Number;//显示区域的纵坐标
		private var _currentValue:Number=0;
		private var _scollType:String;//滚动模式（横向的还是纵向的）

		private function checkObject(content:Sprite, scrollBar:Sprite):void
		{
			_content = content;
			
			_scrollBar=scrollBar;
			_btnLeftUp=_scrollBar.getChildByName("upLeftBtn") as Sprite;
			_btnRightDown=_scrollBar.getChildByName("downRightBtn") as Sprite;
			_block=_scrollBar.getChildByName("block") as Sprite;
			_path=_scrollBar.getChildByName("path") as Sprite;
			_block.buttonMode=true;
			_btnLeftUp.buttonMode=true;
			_btnRightDown.buttonMode=true;
			if (_btnLeftUp == null)
			{
				throw new Error("YScrollBar组件中没有找到【upLeftBtn】元件");
			}
			if (_btnRightDown == null)
			{
				throw new Error("YScrollBar组件中没有找到【downRightBtn】元件");
			}
			if (_block == null)
			{
				throw new Error("YScrollBar组件中没有找到【block】元件");
			}
			if (_path == null)
			{
				throw new Error("YScrollBar组件中没有找到【path】元件");
			}
		}
		private function  initObject():void
		{
			_block.visible=false;
			
			if (_scollType == YScrollBar.V)
			{
				_x_y = "y";
				_width_height = "height";
				_area_width_height = _areaHeight;
				_area_x_y = _areaY;
			}
			else if (_scollType == YScrollBar.H)
			{
				_x_y = "x";
				_width_height = "width";
				_area_width_height = _areaWidth;
				_area_x_y = _areaX;
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
			var per:Number;
			
			if (_content[_width_height] > _area_width_height)
			{
				_block.visible=true;
				per=_area_width_height/_content[_width_height]
				_block[_width_height]=_allDistance*per;
				_rollDistance=_btnRightDown[_x_y]-_btnLeftUp[_x_y]-_btnLeftUp[_width_height]-_block[_width_height];
				_block[_x_y] = PoleNewY(_content[_x_y]);
				if (_block[_x_y] + _block[_width_height] > _btnRightDown[_x_y])
				{
					_block[_x_y] =  _btnRightDown[_x_y] - _block[_width_height] ;
				}
			} 
			else 
			{
				_content[_x_y] = _area_x_y;
				_block.visible=false;
			}
		}
		//以拖动条的位置计算来MC的位置
		private function ConNewY(nowPosition:Number):Number 
		{
			return -(_content[_width_height] - _area_width_height) * (nowPosition - _blockStartPosition) / _rollDistance +_area_x_y;
		}
		//以MC的位置来计算拖动条的位置
		private function PoleNewY(nowPosition:Number):Number 
		{
			return _rollDistance * (_area_x_y - nowPosition) / (_content[_width_height] - _area_width_height) +_blockStartPosition;
		}
		private function dispatch(dir:String,value:Number):void
		{
			if(_currentValue!=value)
			{
				_currentValue=value;
				
				var event:YScrollBarEvent=new YScrollBarEvent(YScrollBarEvent.VALUE_CHANGE);
				event.contentMoveDir=dir;
				event.value=value;
				dispatchEvent(event);
			}
		}
		private function blockClickHandler(event : MouseEvent):void 
		{
			_block.stage.addEventListener(MouseEvent.MOUSE_UP, poleUp);	
			_block.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);	
			
			var dragRect:Rectangle;
			if (_content[_width_height]>_area_width_height )
			{
				_scrollBar.stage.addEventListener(MouseEvent.MOUSE_UP, poleUp);
				if (_scollType == YScrollBar.V)
				{
					dragRect = new Rectangle(_block.x, _blockStartPosition, 0, _rollDistance);
				}
				else if (_scollType == YScrollBar.H)
				{
					dragRect = new Rectangle(_blockStartPosition, _block.y, _rollDistance, 0);
				}
				_block.startDrag(false, dragRect);
				//_scrollBar.addEventListener(Event.ENTER_FRAME, poleDown);
			}
		}

		private function poleDown(event : Event=null):void 
		{
			var nowPosition:Number;
			var newY:Number;
			if (_content[_width_height]>_area_width_height )
			{
				nowPosition=_block[_x_y];
				newY=ConNewY(nowPosition);
				var targetPosition:Number=(newY - _content[_x_y]) / 1;
				var dir:String;
				if(int(targetPosition*10)>0)
				{
					dir="down"
				}
				else if(int(targetPosition*10)<0)
				{
					dir="up";
				}
				//trace(_block[_x_y]+_block[_width_height]-_btnRightDown[_x_y])
				_content[_x_y] += targetPosition;
				if(dir)
				{
					//trace(_block[_x_y],_btnLeftUp[_x_y],_btnLeftUp[_width_height],_rollDistance)
					var value:Number=(_block[_x_y]-(_btnLeftUp[_x_y]+_btnLeftUp[_width_height]))/_rollDistance;
					dispatch(dir,value);
				}
			}
		}
        private function mouseMoveHandler(evn:MouseEvent):void
		{
			poleDown();
		}
		private function poleUp(event : MouseEvent):void 
		{
			_block.stage.removeEventListener(MouseEvent.MOUSE_UP, poleUp);
			_block.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);	
			var nowPosition:Number;
			if (_content[_width_height]>_area_width_height )
			{
				nowPosition=_block[_x_y];
				_content[_x_y]=ConNewY(nowPosition);
			}
			_block.stopDrag();
			_scrollBar.removeEventListener(Event.ENTER_FRAME, poleDown);
		}
		private function pathClickHandler(event : MouseEvent):void
		{
			var nowPosition:Number;
			var mousePosition:Number;
			if (_scollType == YScrollBar.H)
			{
				mousePosition = _scrollBar.mouseX; 
			}
			else if (_scollType == YScrollBar.V)
			{
				mousePosition = _scrollBar.mouseY; 
			}
			if (_content[_width_height]>_area_width_height )
			{
				if (mousePosition < _block[_x_y]&& mousePosition > _btnLeftUp[_x_y]+_btnLeftUp[_width_height])
				{
					nowPosition = mousePosition;
				}
				else if (mousePosition > _block[_x_y] + _block[_width_height] && mousePosition < _btnRightDown[_x_y])
				{
					nowPosition = mousePosition - _block[_width_height];
				}	
				_block[_x_y]=nowPosition;
				_content[_x_y] = ConNewY(nowPosition);
			}
		}
		private function rightDownBtnClickHandler(event : MouseEvent=null):void 
		{
			_btnRightDown.stage.addEventListener(MouseEvent.MOUSE_UP, downBtnUp);
			
			var nowPosition:Number;
			var dir:String;
			if (_content[_width_height]>_area_width_height )
			{
				//trace(_content[_x_y] , _area_x_y + _area_width_height - _content[_width_height])
				if (_content[_x_y] > (_area_x_y + _area_width_height - _content[_width_height])) 
				{
					if(_content[_x_y]+_content[_width_height]>_area_x_y+_area_width_height)
					{
						dir="up";
					}
					_content[_x_y]-=10;
					if(_content[_x_y]+_content[_width_height]<_area_x_y + _area_width_height)
					{
						_content[_x_y]=_area_x_y + _area_width_height-_content[_width_height];
						_block[_x_y]=_btnRightDown[_x_y]-_block[_width_height];
					}
					else
					{
						nowPosition=_content[_x_y];
						_block[_x_y]=PoleNewY(nowPosition);
					}
					
					if(dir)
					{
						var value:Number=(_block[_x_y]-(_btnLeftUp[_x_y]+_btnLeftUp[_width_height]))/_rollDistance;
						dispatch(dir,value);
					}
				}
			}
			
			_putTime=getTimer();
			//_scrollBar.addEventListener(Event.ENTER_FRAME, downBtnDown);
		}

		private function downBtnDown(event : Event=null):void 
		{
			var nowPosition:Number;
			if (_content[_width_height]>_area_width_height )
			{
				if (getTimer()-_putTime>500) {
					if (_content[_x_y] > (_content[_x_y] + _area_width_height - _content[_area_width_height])) 
					{
						_content[_x_y]-=1;
						nowPosition=_content[_x_y];
						_block[_x_y]=PoleNewY(nowPosition);
					}
				}
			}
		}

		private function downBtnUp(event : MouseEvent=null):void 
		{
			_btnRightDown.stage.removeEventListener(MouseEvent.MOUSE_UP, downBtnUp);
			_scrollBar.removeEventListener(Event.ENTER_FRAME, downBtnDown);
		}
		private function leftUpBtnClickHandler(event : MouseEvent=null):void
		{
			_btnLeftUp.stage.addEventListener(MouseEvent.MOUSE_UP, upBtnUp);
			var nowPosition:Number;
			var dir:String
			if (_content[_width_height]>_area_width_height )
			{
				if (_content[_x_y] < _area_x_y ) {
					if(_content[_x_y]<_area_x_y)
					{
                        dir="down";
					}
					_content[_x_y]+=10;
					if(_content[_x_y]>_area_x_y)
					{
						_content[_x_y]=_area_x_y; 
					}
					nowPosition = _content[_x_y];
					_block[_x_y]=PoleNewY(nowPosition);
					
					if(dir)
					{
						var value:Number=(_block[_x_y]-(_btnLeftUp[_x_y]+_btnLeftUp[_width_height]))/_rollDistance;
						dispatch(dir,value);
					}
				}
			}
			
			_putTime=getTimer();
			//_scrollBar.addEventListener(Event.ENTER_FRAME, upBtnDown);
		}

		private function upBtnDown(event : Event=null):void {
			var nowPosition:Number;
			if (_content[_width_height]>_area_width_height )
			{
				if (getTimer() - _putTime > 500) 
				{
					if (_content[_x_y] < _area_x_y) 
					{
						_content[_x_y]+=1;
						nowPosition=_content[_x_y];
						_block[_x_y]=PoleNewY(nowPosition);
					}
				}
			}
		}
		private function upBtnUp(event : MouseEvent=null):void
		{
			_btnLeftUp.stage.removeEventListener(MouseEvent.MOUSE_UP, upBtnUp);
			_scrollBar.removeEventListener(Event.ENTER_FRAME, upBtnDown);
		}
		
		/**
		 * 关联被滚动的内容和滚动组件
		 * @param	content 被滚动的内容
		 * @param	scrollBar 滚动条组件
		 * @param	areaX 显示区域的横坐标
		 * @param	areaY 显示区域的纵坐标
		 * @param	areaWidth 显示区域的宽度
		 * @param	areaHeight 显示区域的高度
		 * @param	scollType 显示模式（横向或者纵向）
		 * @param	ease 缓动系数，不可<1
		 */
		public function init(content:Sprite, scrollBar:Sprite , areaX:Number, areaY:Number, areaWidth:Number, areaHeight:Number, scollType:String = YScrollBar.V, ease:Number = 0):void
		{
			_areaHeight=areaHeight;
			_areaWidth = areaWidth;
			_areaX = areaX;
			_areaY = areaY;
			
			_scollType = scollType;
			
			_ease = ease;
			if (ease <= 1)
			{
				_ease = 1;
			}
			
			checkObject(content, scrollBar);
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
			_path.removeEventListener(MouseEvent.MOUSE_DOWN, pathClickHandler);//点击滑道
			
			_content = null;
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
			upBtnUp();
			downBtnUp()
		}
		public function get value():Number
		{
			return _currentValue;
		}
		
		public function set value(per:Number):void
		{
			if(per>=0&&per<=1)
			{
					if (_content[_width_height]>_area_width_height )
					{
						var dir:String;
						if(per>_currentValue)
						{
							dir="up";
						}
						else if(per<_currentValue)
						{
							dir="down" 
						}
                        trace("per:",per)
						_content[_x_y]=_area_x_y-(_content[_width_height]-_area_width_height)*per;
						_block[_x_y]=_btnLeftUp[_x_y]+_btnLeftUp[_width_height]+_rollDistance*per;
						dispatch(dir,per);
						
						_currentValue=per;
					}
			}
		}
	}
}