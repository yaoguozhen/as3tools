package transcode.request
{
	import flash.events.IOErrorEvent;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class TemplateReq extends BaseRequest
	{
		public var data:String="";
		
		private var objArr:Array=[];
		
		public function TemplateReq()
		{
			super();
			
			//this.API=EditorConfig.query;
			this.API=EditorConfig.callApi;
			this._type=RequestType.TEMPLATE;
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
			vars.url=decodeURIComponent(EditorConfig.query);
			/*for(var str:String in vars){
				trace(str,vars[str]);
			}*/
			//_request.data=data;
			_request.data=vars;
			_request.method=URLRequestMethod.POST;
			trace("获取模板>>>:"+_request.url+"参数:"+_request.data.toString());
		}
		
		override protected function validateResult():void{
			//trace(_data.info.items.length);
			if(_data.result==false){
				return;
			}
			objArr=[];
			for(var i:int=0;i<_data.info.items.length;i++){
				var obj:Object=_data.info.items[i];
				//trace(">>>模板:"+obj.format,obj.template_name,obj.template_id);
				objArr.push(obj);
			}
			_result=objArr;
		}
		
		private function getTempleObj(obj:Object):Array
		{
			var array:Array=[];
			var list:Object=obj.info.items;
			var n:uint=list.length;
			var item:Object;
			for(var i:int=0;i<n;i++)
			{
				item=new Object();
				item.label=list[i].template_name;
				item.value=list[i].template_id;
				array.push(item);
			}
			return array;
		}
		
		override protected function onIoError(event:IOErrorEvent):void{
			App.log.error("获取模板接口数据 Error");
		}
	}
}