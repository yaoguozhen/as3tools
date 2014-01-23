package zhen.guo.yao.ytrace 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author yaoguozhen
	 */
	internal class YBtnClickEvent extends Event 
	{
		public static const BTN_CLICK:String = "btnClick";
		public var btnType:String;
		
		public function YBtnClickEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new YBtnClickEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("BtnClickEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}