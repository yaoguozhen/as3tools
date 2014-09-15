package com.zqvideo.model.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * 数据加载类
	 * @author .....Li灬Star
	 */
	public class DataLoader extends EventDispatcher
	{
		private static var instance:DataLoader=new DataLoader();
		public static const HOME_PAGE_FENYE:String="HOME_PAGE_FENYE";
		public static const EDITOR_PAGE_FENYE:String="EDITOR_PAGE_FENYE";
		public static const GENERATE_FENYE:String="GENERATE_FENYE";
		public static const SEND_IMAGE:String="SEND_IMAGE";
		public static const LOADERROR:String="LOADERROR";
		public static var errorWarn:String="";
		public var getGeneratesUrl:String="";
		public var pageImageUrl:String=""; // http://192.168.0.131:8080/povs2.1/material/getImages/
		public var sendImageUrl:String=""; // http://172.16.3.133:8080/povs2.1/material/saveImagers/
		public var qwGenerateUrl:String=""; //http://172.16.3.176:8080/povs2.1/mainTab/?tab=generate
		
		private var cloudyURLLoader:CloudyURLLoader;
		private var generateURLLoader:CloudyURLLoader;

		public function DataLoader()
		{
			if (instance)
			{
				throw new Error("DataLoader.getInstance()获取实例");
				return;
			}
		}

		public function loadXML(type:String, argObj:Object=null):void
		{
			var urlVariables:URLVariables=new URLVariables();
			var xmlURL:String="";
			var urlRequest:URLRequest;
			
			switch(type){
				
				case GENERATE_FENYE:
					disposeUrlLoader(generateURLLoader);
//					xmlURL="localData/"+"generate"+String(argObj.Page+1)+".xml";
					xmlURL=getGeneratesUrl;
					urlRequest=new URLRequest(xmlURL);
					urlRequest.method=URLRequestMethod.POST;
					urlVariables.CatalogType = EditConfig.TYPE_CREATE;
					urlVariables.Page = argObj.Page;
					trace(GENERATE_FENYE+">>"+argObj.Page);
					urlRequest.data=urlVariables;
					errorWarn=Root.LANGUAGE_DATA.sucaiPublishGetLose[0];
					generateURLLoader=new CloudyURLLoader(urlRequest, type, argObj);
					generateURLLoader.load(urlRequest);
					generateURLLoader.addEventListener(Event.COMPLETE, completeHandler);
					generateURLLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
					generateURLLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
					return;
					break;
				case EDITOR_PAGE_FENYE:
//					xmlURL="localData/"+String(argObj.pageNum)+".xml";
					xmlURL=pageImageUrl;
					urlRequest=new URLRequest(xmlURL);
					urlRequest.method=URLRequestMethod.POST;
					trace(argObj.pageNum+"//"+argObj.imgNum);
					urlVariables.pageNum=argObj.pageNum;
					urlVariables.imgNum=argObj.imgNum;
					urlRequest.data=urlVariables;
					errorWarn=Root.LANGUAGE_DATA.editorPageImageGetLose[0];
					break;
				case SEND_IMAGE:
					xmlURL=sendImageUrl;
					urlRequest=new URLRequest(xmlURL);
					urlRequest.method=URLRequestMethod.POST;
					urlVariables.inputName=encodeURI(argObj.inputName);
					urlVariables.sendXml=argObj.sendXml;
					trace("inputName*****>"+argObj.inputName);
					trace("send*****>"+argObj.sendXml.toXMLString());
					urlRequest.data=urlVariables;
					errorWarn=Root.LANGUAGE_DATA.sendShiBai[0];
					break;
			}

			try
			{
				cloudyURLLoader.removeEventListener(Event.COMPLETE, completeHandler);
				cloudyURLLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				cloudyURLLoader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				cloudyURLLoader.close();
				cloudyURLLoader=null;
			}
			catch (e:Error)
			{
				
			}
			
			cloudyURLLoader=new CloudyURLLoader(urlRequest, type, argObj);
			cloudyURLLoader.load(urlRequest);
			cloudyURLLoader.addEventListener(Event.COMPLETE, completeHandler);
			cloudyURLLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			cloudyURLLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			

		}

		private function disposeUrlLoader(cloudyURLLoader:CloudyURLLoader):void{
			try
			{
				cloudyURLLoader.removeEventListener(Event.COMPLETE, completeHandler);
				cloudyURLLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				cloudyURLLoader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				cloudyURLLoader.close();
				cloudyURLLoader=null;
			}
			catch (e:Error)
			{
				
			}
		}
		
		/**
		 * 数据加载完成
		 * @param e
		 */
		private function completeHandler(e:Event):void
		{
			var receiveXml:XML=new XML();
			var target:CloudyURLLoader=CloudyURLLoader(e.target);
			var requestType:String=target.requestType;
			var argObj:Object=target.argObj;
			receiveXml.ignoreWhitespace=true;
            
			try
			{
				receiveXml=XML(e.target.data);
			}
			catch (error:Error)
			{
				trace(error.message);
			}
            
			trace(requestType+">>>"+receiveXml.toString()+"===========================");
			
			var obj:Object=new Object();

			var dataEvent:DataEvent;
			switch (requestType)
			{
				case GENERATE_FENYE:
					obj.panelName="Editor_GENERATE";
					obj.dataType=requestType;
					obj.xml=receiveXml;
					dataEvent=new DataEvent(GENERATE_FENYE, obj);
					break;
				case EDITOR_PAGE_FENYE:
					obj.panelName="EditorPanel";
					obj.dataType=requestType;
					obj.xml=receiveXml;
					dataEvent=new DataEvent(EDITOR_PAGE_FENYE, obj);
					break;
				case SEND_IMAGE:
					obj.panelName="SendPanel";
					obj.dataType=requestType;
					obj.xml=receiveXml;
					dataEvent=new DataEvent(SEND_IMAGE, obj);
					break;
				
			}
			if(!dataEvent){
				return;
			}
			DataCenter.getInstance().dispatchEvent(dataEvent);
		}

		/**
		 * 数据加载错误(弹出提示)
		 * @param e
		 */
		private function ioErrorHandler(e:IOErrorEvent):void
		{
			var errorObj:Object=new Object();
			errorObj.errorTxt=errorWarn;
			var dataEvent:DataEvent=new DataEvent(LOADERROR, errorObj); 
			DataCenter.getInstance().dispatchEvent(dataEvent);
		}

		/**
		 * 数据加载过程
		 * @param e
		 */
		private function progressHandler(e:ProgressEvent):void
		{
			//trace(int(e.bytesLoaded / e.bytesTotal * 100) + "%");
			//trace(Math.floor(e.bytesLoaded / e.bytesTotal * 100) + "%");
		}

		public static function getInstance():DataLoader
		{
			return instance;
		}
	}
}
