package com.zqvideo.event
{
	import flash.events.Event;
	
	public class NetEvent extends Event
	{
		public var data:*;
		
		public var targetName:String="";
		
		public function NetEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}