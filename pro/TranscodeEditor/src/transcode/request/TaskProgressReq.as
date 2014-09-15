package transcode.request
{
	import flash.events.IOErrorEvent;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class TaskProgressReq extends BaseRequest
	{
		public var data:String="";
		
		public function TaskProgressReq()
		{
			super();
			
			this.API=EditorConfig.callApi;
			this._type=RequestType.TASK_PROGRESS;
		}
		
		override public function send(search:Boolean=false):void
		{
			_request.url = EditorConfig.host+this.API;
			init();
			try
			{
				_urlloader.close();
			} 
			catch(error:Error) 
			{
				
			}
			_urlloader.load(_request);
		}
		
		override protected function init():void{
			var vars:URLVariables = new URLVariables();
			vars.data=data;
			vars.url=decodeURIComponent(EditorConfig.taskProgress);
			/*for(var str:String in vars){
			    trace(str,vars[str]);
			}*/
			_request.data=vars;
			_request.method=URLRequestMethod.POST;
			trace("请求进度>>>:"+_request.url+"参数:"+_request.data.toString());
		}
		
		override protected function onIoError(event:IOErrorEvent):void{
			App.log.error("请求转码进度接口 Error");
		}
	}
}