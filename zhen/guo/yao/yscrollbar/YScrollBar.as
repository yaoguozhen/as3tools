package zhen.guo.yao.yscrollbar
{
	/**
	 * 构建滚动条
	 * @author LOLO
	 */
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.geom.Rectangle;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	
	
	
	public class YScrollBar
	{
		private var _component:MovieClip;
		private var _mask:DisplayObject;//遮罩(滚动区域)
		private var _scrollBar:DisplayObjectContainer;//滚动条容器
		private var _content:DisplayObject;//需要进行滚动的对象
		private var _track:DisplayObject//轨道
		private var _thumb:Sprite//滑块
		private var _arrowUp:DisplayObject//向上按钮
		private var _arrowDown:DisplayObject//向下按钮
		private var _direction:String;//滚动条是水平滚动还是垂直滚动
		
		private var _rThumb:Rectangle;//滑块拖动范围
		private var _info:Object;//滚动条信息{wh:"width" or "height", xy:"x" or "y"}
		private var _content_a:int;//内容初始位置
		private var _isThumbMoveUp:Boolean;//当前是否向上移动滑块 
		
		private var _moveContentTimer:Timer;//鼠标按下滑块时，更新移动content
		private var _repeatDelayTimer:Timer;//鼠标按下arrowUp或arrowDown而未释放，500毫秒后不断进行滚动
		private var _moveThumbTimer:Timer;//按紧arrowUp或arrowDown时，Thumb不断进行滚动
		
		private var _contentTween:Tween;//
		private var _enabled:Boolean;//当前是否可以滚动
		
		private var _hideThumb:Boolean;//是否在不能滚动时，自动隐藏滑块
		private var _thumbScrollSize:uint;//按紧arrowUp或arrowDown时，滑块滚动的增量
		
		
		
		/**
		 * 构造函数
		 * @param	p_component 滚动条组件
		 * @param	p_content 需要进行滚动的对象(被滚动、遮罩的内容)
		 * @param	p_direction 指示滚动条是水平滚动还是垂直滚动。 有效值为水平:"heng", 垂直:"shu"
		 * @param	p_hideThumb 是否在不能滚动时，自动隐藏滑块
		 * @param	p_thumbScrollSize 设置垂直滚动条滑块 [滑轮滚动一次、按钮点击一次、按钮按紧未释放]，滚动多少像素
		 * @return 
		 */
		public function init(
									p_component:MovieClip,
									p_content:DisplayObject,
									p_direction:String,
									p_hideThumb:Boolean = false,
									p_thumbScrollSize:uint = 10
									)
		{
			_component = p_component;
			_mask      = p_component.mask_mc;
			_content   = p_content;
			_scrollBar = p_component.scrollBar;
			_track     = _scrollBar.getChildByName("track");
			_thumb     = _scrollBar.getChildByName("thumb") as Sprite;
			_arrowUp   = _scrollBar.getChildByName("arrowUp");
			_arrowDown = _scrollBar.getChildByName("arrowDown");
			_hideThumb = p_hideThumb;
			_thumbScrollSize = p_thumbScrollSize;
			
			_direction="vertical";
			if (p_direction == "heng")
			{
				_direction="horizontal"
			}
			
			_content.x = _mask.x;
			_content.y = _mask.y;
			_component.addChild(_content);
			
			_content.mask = _mask;
			
			_rThumb = new Rectangle(int(_thumb.x), int(_thumb.y));
			
			_info = new Object();
			_info = (_direction == "vertical") ? {wh:"height", xy:"y"} : {wh:"width", xy:"x"};
			
			_content_a = (_direction == "vertical") ? int(_content.y) : int(_content.x);
			
			_moveContentTimer = new Timer(35);
			_moveContentTimer.addEventListener(TimerEvent.TIMER, moveContentTimerHandler);
			
			_repeatDelayTimer = new Timer(500);
			_repeatDelayTimer.addEventListener(TimerEvent.TIMER, repeatDelayTimerHandler);
			
			_moveThumbTimer = new Timer(100);
			_moveThumbTimer.addEventListener(TimerEvent.TIMER, moveThumbTimerHandler);
			
			//addListeners();
			change();
		}
		
		
		//侦听事件
		private function addListeners():void
		{
			if (_direction == "vertical") _content.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);//内容
			
			_thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbMouseDown);//滑块
			_track.addEventListener(MouseEvent.MOUSE_DOWN, trackMouseDown);//轨道
			_scrollBar.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);//滚动条容器
			_track.stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp);//舞台
			
			if (_arrowUp) _arrowUp.addEventListener(MouseEvent.MOUSE_DOWN, arrowMouseDown);
			if (_arrowDown) _arrowDown.addEventListener(MouseEvent.MOUSE_DOWN, arrowMouseDown);
		}
		
		//移除事件
		private function removeListeners():void
		{
			if (_direction == "vertical") _content.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			
			_thumb.removeEventListener(MouseEvent.MOUSE_DOWN, thumbMouseDown);
			_track.removeEventListener(MouseEvent.MOUSE_DOWN, trackMouseDown);
			_scrollBar.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			_track.stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
			
			if (_arrowUp) _arrowUp.removeEventListener(MouseEvent.MOUSE_DOWN, arrowMouseDown);
			if (_arrowDown) _arrowDown.removeEventListener(MouseEvent.MOUSE_DOWN, arrowMouseDown);
		}
		
		
		//滑块，鼠标按下
		private function thumbMouseDown(event:MouseEvent):void
		{
			_rThumb.width  = (_direction == "vertical") ? 0 : _track[_info.wh] - _thumb[_info.wh];
			_rThumb.height = (_direction == "vertical") ? _track[_info.wh] - _thumb[_info.wh] : 0;
			_thumb.startDrag(false, _rThumb);
			_moveContentTimer.start();
		}
		
		//滑块，鼠标按紧未释放时，更新移动content
		private function moveContentTimerHandler(event:TimerEvent):void
		{
			moveContent();
			event.updateAfterEvent();
		}
		
		
		
		//轨道，鼠标按下
		private function trackMouseDown(event:MouseEvent):void
		{
			moveThumb(_scrollBar[(_direction == "vertical") ? "mouseY" : "mouseX"]);
		}
		
		
		
		//arrowUp或arrowDown，鼠标按下
		private function arrowMouseDown(event:MouseEvent):void
		{
			_isThumbMoveUp = (event.currentTarget == _arrowUp);
			moveThumbTimerHandler();
			_repeatDelayTimer.start()
		}
		
		//鼠标按下arrowUp或arrowDown未释放
		private function repeatDelayTimerHandler(event:TimerEvent = null):void
		{
			_repeatDelayTimer.reset();
			_moveThumbTimer.start();
		}
		
		
		//按下arrowUp或arrowDown而未释放，不断进行滚动
		private function moveThumbTimerHandler(event:TimerEvent = null):void
		{
			//如果向上
			if(_isThumbMoveUp){
				moveThumb(_thumb[_info.xy] - _thumbScrollSize);
			
			}else{
				moveThumb(_thumb[_info.xy] + _thumb[_info.wh] + _thumbScrollSize);
			}
			if(event) event.updateAfterEvent();
		}
		
		
		//滑轮滚动
		private function mouseWheelHandler(event:MouseEvent):void
		{
			//如果是向下滚动
			if(event.delta < 0){
				moveThumb(_thumb[_info.xy] + _thumb[_info.wh] + _thumbScrollSize);
			//如果向上滚动
			}else{
				moveThumb(_thumb[_info.xy] - _thumbScrollSize);
			}
		}
		
		
		
		//更新移动content
		private function moveContent():void
		{
			//算出每个百分点移动的距离
			var percent:Number = (_content[_info.wh] - _mask[_info.wh]) / 100;
			//算出移动了多少个百分点
			var pmove:Number = (_thumb[_info.xy] - _rThumb[_info.xy]) / (_track[_info.wh] - _thumb[_info.wh]) * 100;
			
			var propValue:int = _enabled ? - (int(pmove * percent - _content_a)) : _content_a;
			
			//不使用缓动，直接改变content位置
			//_content[_info.xy] = propValue;
			
			//使用缓动
			if (_contentTween) _contentTween.stop();
			_contentTween = new Tween(_content, _info.xy, Strong.easeOut, _content[_info.xy], propValue, 0.5, true);
		}
		
		
		
		//移动滑块
		private function moveThumb(scroll:int):void
		{
			var propValue:int;
			
			//如果向下移动
			if(scroll > _thumb[_info.xy]){
				scroll = int(scroll -_thumb[_info.wh]);
				//5像素内，自动吸附到底端
				propValue = ((scroll + _thumb[_info.wh] + 5) > (_track[_info.xy] + _track[_info.wh]))
											? int(_track[_info.xy] + _track[_info.wh] - _thumb[_info.wh])
											: scroll;
				
			
			}else{
				//5像素内，自动吸附到顶端
				propValue = (scroll < (_track[_info.xy] + 5))
											? _track[_info.xy]
											: scroll;
			}
			
			
			//不使用缓动，直接改变thumb位置
			_thumb[_info.xy] = propValue;
			
			
			moveContent();
		}
		
		
		//舞台，松开鼠标
		private function stageMouseUp(event:MouseEvent):void
		{
			clearTimer();
			_thumb.stopDrag();
			moveContent();
		}
		
		
		//清除计时器
		private function clearTimer():void
		{
			if (_moveContentTimer.running) _moveContentTimer.reset();
			if (_repeatDelayTimer.running) _repeatDelayTimer.reset();
			if (_moveThumbTimer.running)   _moveThumbTimer.reset();
		}
		
		
		
		
		
		/**
		 * 设置按下arrowUp或arrowDown时，滑块滚动的增量(默认为10)
		 */
		public function set thumbScrollSize(value:uint):void 
		{
			_thumbScrollSize = value;
		}
		
		
		/**
		 * 显示区域有改变时，请调用该方法，更新滚动显示
		 */
		public function change():void
		{
			if(_content[_info.wh] <= _mask[_info.wh]){
				_enabled = false;
				removeListeners();
				
				//滑块位置还原
				_thumb[_info.xy] = _rThumb[_info.xy];
				
			}else {
				_enabled = true;
				addListeners();
			}
			
			moveContent();
			
			if(_hideThumb) _scrollBar.visible = _enabled;
		}
		
		
		
		/**
		 * 清除事件，以及对其他元件的引用
		 */
		public function clear():void
		{
			_moveContentTimer.removeEventListener(TimerEvent.TIMER, moveContentTimerHandler);
			_repeatDelayTimer.removeEventListener(TimerEvent.TIMER, repeatDelayTimerHandler);
			_moveThumbTimer.removeEventListener(TimerEvent.TIMER, moveThumbTimerHandler);
			removeListeners();
			clearTimer();
			
			
			_scrollBar = null;
			_content = null;
			_track = null;
			_thumb = null;
			_arrowUp = null;
			_arrowDown = null;
		}
		//
	}
	
}