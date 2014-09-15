package zhen.guo.yao.ydrag
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**拖动事件类*/
	public class YDragEvent extends Event {
		public static const STATUS_CHANGE:String = "statusChange";
		
		public var data:Object;
		public var dragTarget:DisplayObject;
		public var dragImage:DisplayObject;
		public var status:String;
		
		
		public function YDragEvent(type:String,bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

		override public function clone():Event {
			return new YDragEvent(type, bubbles, cancelable);
		}
	}
}