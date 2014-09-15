/**
 * Morn UI Version 2.0.0526 http://code.google.com/p/morn https://github.com/yungzhu/morn
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package  com.zqvideo.view{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**拖动事件类*/
	public class YScrollBarEvent extends Event {
		public static const VALUE_CHANGE:String = "valueChange";
		
		//内容滚动方向
		public var contentMoveDir:String;
		//当前值，0到1之间
		public var value:Number

		public function YScrollBarEvent(type:String, dragInitiator:DisplayObject = null, data:Object = null, dropTarget:DisplayObject = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}