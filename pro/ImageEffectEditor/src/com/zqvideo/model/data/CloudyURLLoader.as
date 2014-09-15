package com.zqvideo.model.data
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 *
	 * @author .....Li灬Star
	 */
	public class CloudyURLLoader extends URLLoader
	{
		public var requestType:String;
		public var argObj:Object;

		public function CloudyURLLoader(request:URLRequest, rType:String="", arg:Object=null):void
		{
			super(request);
			requestType=rType;
			argObj=arg;
		}
	}
}
