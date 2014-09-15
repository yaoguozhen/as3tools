package zhen.guo.yao.ydrag
{

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**拖动管理类*/
	public class YDrag extends EventDispatcher 
	{
		private var _dragTarget:DisplayObject;
		private var _dragImage:Sprite;
		private var _data:Object;
		private var _stage:Stage;
		private static var _instance:YDrag;
		
		
		public function YDrag():void
		{
			if (_instance)
			{
				throw new Error("此为单例类，请使用 YDragManager.instance 属性来获取实例");
			}
		}
		/**
		 * 开始拖动
		 * @param dragTarget 拖动的源对象
		 * @param dragImage 显示拖动的图片，如果为null，则是源对象本身
		 * @param data 拖动传递的数据
		 */
		public function doDrag(dragTarget:DisplayObject, dragImage:Sprite = null, data:Object = null):void 
		{
			_stage = dragTarget.stage;
			if (_stage)
			{
				_dragTarget = dragTarget;
				_dragImage = dragImage ? dragImage : _dragTarget as Sprite;
				_data = data;
				if (_dragImage != _dragTarget) 
				{
					var p:Point = _dragTarget.localToGlobal(new Point());
					_dragImage.x = p.x;
					_dragImage.y = p.y;
					_stage.addChild(_dragImage);
				}
				_dragImage.startDrag();
				dispatch(YDragStatus.DRAG_START);
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
				_stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			}
			else 
			{
				trace("调用YDragManager的doDrag方法时，dragTarget的stage不可为null");
			}
		}
		public static function get instance():YDrag
		{
			if (_instance)
			{
				return _instance
			}
			return new YDrag();
		}
		private function dispatch(status:String):void
		{
			var event:YDragEvent = new YDragEvent(status);
			event.status = status;
			event.data = _data;
			event.dragTarget = _dragTarget;
			event.dragImage = _dragImage;
			dispatchEvent(event);
		}
		/**放置把拖动条拖出显示区域*/
		private function onStageMouseMove(e:MouseEvent):void 
		{
			if (e.stageX <= 0 || e.stageX >= _stage.stageWidth || e.stageY <= 0 || e.stageY >= _stage.stageHeight) 
			{
				_dragImage.stopDrag();				
			} 
			else 
			{
				_dragImage.startDrag();
				dispatch(YDragStatus.DRAGING);
			}
		}
		
		private function onStageMouseUp(e:Event):void 
		{
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			_dragImage.stopDrag();
			
			dispatch(YDragStatus.DRAG_DROP);
			
			if (_dragTarget != _dragImage) 
			{
				if (_stage.contains(_dragImage)) 
				{
					_stage.removeChild(_dragImage);
				}
			}
			_dragTarget = null;
			_data = null;
			_dragImage = null;
		}
	}
}