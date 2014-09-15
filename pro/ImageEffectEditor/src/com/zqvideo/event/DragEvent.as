/**
 * Morn UI Version 2.0.0526 http://code.google.com/p/morn https://github.com/yungzhu/morn
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package com.zqvideo.event{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**拖动事件类*/
	public class DragEvent extends Event {
		public static const DRAG_START:String = "dragStart";
		public static const DRAG_DROP:String = "dragDrop";
		public static const DRAG_COMPLETE:String = "dragComplete";
		public static const GLOBAL_DRAG_ING:String = "global_drag_ing";
		public static const GLOBAL_DRAG_END:String = "global_drag_end";
		public static const GLOBAL_DRAG_OTHER:String="global_drag_other";
		
		protected var _data:Object;
		protected var _dragInitiator:DisplayObject;
		protected var _dropTarget:DisplayObject;
		public function DragEvent(type:String, dragInitiator:DisplayObject = null, data:Object = null, dropTarget:DisplayObject = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			_dragInitiator = dragInitiator;
			_data = data;
			this._dropTarget = dropTarget;
		}
		
		public function get dropTarget():DisplayObject
		{
			return _dropTarget;
		}

		public function set dropTarget(value:DisplayObject):void
		{
			_dropTarget = value;
		}

		/**拖动的源对象*/
		public function get dragInitiator():DisplayObject {
			return _dragInitiator;
		}
		
		public function set dragInitiator(value:DisplayObject):void {
			_dragInitiator = value;
		}
		
		/**拖动传递的数据*/
		public function get data():Object {
			return _data;
		}
		
		public function set data(value:Object):void {
			_data = value;
		}
		
		override public function clone():Event {
			return new DragEvent(type, _dragInitiator, _data,_dropTarget, bubbles, cancelable);
		}
	}
}