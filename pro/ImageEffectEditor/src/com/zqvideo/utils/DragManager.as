/**
 * Morn UI Version 2.0.0526 http://code.google.com/p/morn https://github.com/yungzhu/morn
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package com.zqvideo.utils {
	import com.zqvideo.event.DragEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**拖动管理类*/
	public class DragManager {
		private var _dragInitiator:DisplayObject;
		private var _dragImage:Sprite;
		private var _data:Object;
		
		/**
		 * 开始拖动
		 * @param dragInitiator 拖动的源对象
		 * @param dragImage 显示拖动的图片，如果为null，则是源对象本身
		 * @param data 拖动传递的数据
		 */
		public function doDrag(dragInitiator:DisplayObject, dragImage:Sprite = null, data:Object = null):void {
			_dragInitiator = dragInitiator;
			_dragImage = dragImage ? dragImage : dragInitiator as Sprite;
			_data = data;
			if (_dragImage != _dragInitiator) {
				var p:Point = _dragInitiator.localToGlobal(new Point());
				_dragImage.x = p.x;
				_dragImage.y = p.y;
				Root.stage.addChild(_dragImage);
			}
			_dragImage.startDrag();
			_dragInitiator.dispatchEvent(new DragEvent(DragEvent.DRAG_START, dragInitiator, data));
			Root.stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			Root.stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
		
		/**放置把拖动条拖出显示区域*/
		private function onStageMouseMove(e:MouseEvent):void {
			var dropTarget:DisplayObject = null;
			if (e.stageX <= 0 || e.stageX >= Root.stage.stageWidth || e.stageY <= 0 || e.stageY >= Root.stage.stageHeight) {
				_dragImage.stopDrag();				
			} else {
				_dragImage.startDrag();
				dropTarget = this.getDropTarget(this._dragImage.dropTarget);
				
				if (dropTarget)
				{
					Root.stage.dispatchEvent(new DragEvent(DragEvent.GLOBAL_DRAG_ING, this._dragInitiator, this._data, dropTarget));
				}else{
					Root.stage.dispatchEvent(new DragEvent(DragEvent.GLOBAL_DRAG_OTHER));
				}
			}
		}
		
		private function onStageMouseUp(e:Event):void {
			Root.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			Root.stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			_dragImage.stopDrag();
			var dropTarget:DisplayObject = getDropTarget(_dragImage.dropTarget);
			
			if (dropTarget) {
				dropTarget.dispatchEvent(new DragEvent(DragEvent.DRAG_DROP, _dragInitiator, _data,dropTarget));
			}
			_dragInitiator.dispatchEvent(new DragEvent(DragEvent.DRAG_COMPLETE, _dragInitiator, _data,dropTarget));
			Root.stage.dispatchEvent(new DragEvent(DragEvent.GLOBAL_DRAG_END, this._dragInitiator, this._data, dropTarget));
			if (_dragInitiator != _dragImage) {
				if (Root.stage.contains(_dragImage)) {
					Root.stage.removeChild(_dragImage);
				}
			}
			_dragInitiator = null;
			_data = null;
			_dragImage = null;
		}
		
		private function getDropTarget(value:DisplayObject):DisplayObject {
			while (value) {
				if (value.hasEventListener(DragEvent.DRAG_DROP)) {
					return value;
				}
				value = value.parent;
			}
			return null;
		}
	}
}