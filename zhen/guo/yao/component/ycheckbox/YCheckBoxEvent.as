package zhen.guo.yao.component.ycheckbox
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author yaoguozhen
	 */
	public class YCheckBoxEvent extends Event 
	{
		public static const CHANGE:String = "valueChange";
		public var allData:Array;
		public var changedDate:Object;
		
		public function YCheckBoxEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new YCheckBoxEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("YCheckBoxEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}