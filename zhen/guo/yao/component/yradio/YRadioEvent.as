package zhen.guo.yao.component.yradio
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author yaoguozhen
	 */
	public class YRadioEvent extends Event 
	{
		public static const CHANGE:String = "valueChange";
		public var data:Object
		
		public function YRadioEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new YRadioEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("YRadioEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}