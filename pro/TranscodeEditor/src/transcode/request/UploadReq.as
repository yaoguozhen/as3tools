package transcode.request
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import transcode.EventManager;
	import transcode.event.NetEvent;
	import transcode.request.BaseRequest;

	
	public class UploadReq extends BaseRequest
	{
		private var file:FileReference;
		private var loadPer:int=0;
		private var ptimer:Timer=new Timer(500);
		
		public function UploadReq()
		{
			super();
			
			this.API=EditorConfig.upload;
			this._type=RequestType.UP_LOAD;
			ptimer.addEventListener(TimerEvent.TIMER,onTimerHandler);
		}
		
		override public function send(search:Boolean=false):void{
			_request.url = EditorConfig.host + this.API;
			open();
		}
		
		protected function open():void{
			file=null;
			file = new FileReference();
			file.addEventListener(Event.SELECT, selectHandler);
			file.addEventListener(Event.COMPLETE, completeHandler);
			//file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,loadCompleteDataHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			file.browse(getTypes());
		}
		
		private function getTypes():Array {
			var fileFilter:FileFilter=new FileFilter("文件格式(*.ts;*.mp4;*.mpeg;*.mpg;*.mkv;*.mov;*.avi;*.flv)","*.ts;*.mp4;*.mpeg;*.mpg;*.mkv;*.mov;*.avi;*.flv");
			var allTypes:Array = new Array(fileFilter);
			return allTypes;
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void{
			App.log.error("ioErrorHandler:"+e);
		}
		
		private function selectHandler(e:Event):void{
			//trace(file.data,'xxxx');
			App.log.echo("selectHandler: name=" + file.name);
			//			file.upload(uploadURL);
			file.load();
		}
		
		private function completeHandler(e:Event):void{
			//App.log.echo("completeHandler:"+e);
			trace(file.data.length,'aa');
			
			try
			{
				_urlloader.close();
			} 
			catch(error:Error) 
			{
				
			}
			
			var header:URLRequestHeader = new URLRequestHeader("Content-type","application/octet-stream");
			_request.requestHeaders.push(header);
			_request.method = URLRequestMethod.POST;
			_request.data=pack();
			_urlloader.load(_request);
		    
			ptimer.start();
			
		}
		public function pack(useCompress:Boolean = false):ByteArray
		{
			var strBytes:ByteArray = new ByteArray();
			strBytes.writeUTFBytes(file.name);
			var strLen:uint = strBytes.length;
			
			var res:ByteArray = new ByteArray();
			res.writeUnsignedInt(strLen);//name占的字节长度
			res.writeUTFBytes(file.name);//写入名字
			res.writeBytes(file.data);
			
			if(useCompress){
				res.compress();
			}
			return res;
		}
		
		protected function onTimerHandler(event:TimerEvent):void
		{
			// TODO Auto-generated method stub
			var num:int=Math.random()*8;
			if(loadPer<90){
				loadPer+=num;
			}
			//trace(loadPer);
			var evt:NetEvent = new NetEvent(RequestType.UP_LOAD_PROGRESS);
			evt.data=loadPer;
			EventManager.instance.dispatchEvent(evt);
			
		}
		
		public function stopTimer():void{
			try
			{
				ptimer.stop();
				loadPer=0;
			} 
			catch(error:Error) 
			{
				
			}
		}
	}
}