package com.zqvideo.model.data
{
	import flash.events.Event;
	import flash.system.ApplicationDomain;

	/**
	 * 获取数据的事件
	 * @author .....Li灬Star
	 */
	public class DataEvent extends Event
	{
		public var obj:Object;
		public static const GET_HOME_PAGE_FENYE_DATA:String="GetHomePageFenYeData";
		
		public static const SELECT_POINT:String="Select_Point";
		
		public static const LOAD_ERROR:String="LoadError";

		public function DataEvent(type:String, obj:Object)
		{
			super(type);
			this.obj=obj;
		}
	}
}
