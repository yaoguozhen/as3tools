package com.zqvideo.model.request
{
	import com.zqvideo.event.NetEvent;
	import com.zqvideo.model.data.EventManager;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class DeleteReq 
	{
		protected var _urlloader:URLLoader;
		protected var _request:URLRequest;
		protected var _result:*;
		protected var _data:Object;
		public var API:String;
		/**
		 * 协议类型
		 */
		protected var _type:String;
		
		public var targetName:String;
		public var id:String="";
		
		
		public function DeleteReq()
		{
			_request = new URLRequest();
			_urlloader = new URLLoader();
			_urlloader.addEventListener(Event.COMPLETE, onComplete);
			_urlloader.addEventListener(Event.OPEN, onOpen);
			_urlloader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			_urlloader.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			_urlloader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			//this.API = EditorConfig.GetList;
			this._type = RequestType.DELETE_CATALOG;
		}
		
		public function get result():*
		{
			return _result;
		}
		
		protected function validateResult():void
		{
			_result = _data;
		}
		
		private function onSecurityError(event:SecurityErrorEvent):void
		{
			trace(event);
		}
		
		private function onProgress(event:ProgressEvent):void
		{
		}
		
		protected function onIoError(event:IOErrorEvent):void
		{
			trace(event);
		}
		
		private function onHttpStatus(event:HTTPStatusEvent):void
		{
			trace(event);
		}
		
		private function onOpen(event:Event):void
		{
		}
		
		private function onComplete(event:Event):void
		{
			var str:String = _urlloader.data;
			_data=str;
			
			validateResult();
			if(_type == null){
				throw new Error("事件类型未定义");
			}
			var evt:NetEvent = new NetEvent(_type);
			evt.targetName=targetName;
			evt.data = _result;
			EventManager.instance.dispatchEvent(evt);
			
			reset();
		}
		
		protected function init():void
		{
			var vars:URLVariables = new URLVariables();
			vars.id=id;
			_request.data = vars;
			_request.method = URLRequestMethod.POST;
		}
		
		public function get request():URLRequest{
			return _request;
		}
		
		public function get type():String{
			return _type;
		}
		
		public function send(search:Boolean=false):void
		{
			init();
			_urlloader.load(_request);
		}
		
		public function reset():void{
			try
			{
				_urlloader.close();
			} 
			catch(error:Error) 
			{
				trace(error);
			}
		}
	}
}