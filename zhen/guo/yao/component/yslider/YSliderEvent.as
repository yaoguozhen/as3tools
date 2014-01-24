package zhen.guo.yao.component.yslider
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author yaoguozhen
	 */
	public class YSliderEvent extends Event 
	{
		public static const CHANGE:String = "valueChange";
		public static const BLOCK_PRESSED:String = "blockPressed";
		public static const BLOCK_RELEASED:String = "blockReleased";
		
		public var value:Object;
		
		public function YSliderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new YSliderEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("YSliderEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}