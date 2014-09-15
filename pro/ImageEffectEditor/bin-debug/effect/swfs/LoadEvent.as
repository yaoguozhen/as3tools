package 
{
	import flash.events.Event;

	/**
	 * 获取数据的事件
	 * @author .....Li灬Star
	 */
	public class LoadEvent extends Event
	{
		public var obj:Object;
		public static const XML_LOAD_COMPLETE:String="XmlLoadComplete";
		public static const XML_LOAD_ERROR:String="XmlLoadError";
		public static const IMAGE_LOAD_COMPLETE:String="ImageLoadComplete";
		public static const IMAGE_LOAD_ERROR:String="ImageLoadError";
		public static const IMAGE_ALL_COMPLETE:String="ImageAllComplete";
		public static const SWF_LOAD_COMPLETE:String="SwfLoadComplete";
		public static const SWF_LOAD_PROGRESS:String="SwfLoadProgress";
		public static const SWF_LOAD_ERROR:String="SwfLoadError";
		public static const SWF_ALL_COMPLTE:String="SwfAllComplete";


		public function LoadEvent(type:String, obj:Object=null)
		{
			super(type);
			this.obj=obj;
		}
	}
}
