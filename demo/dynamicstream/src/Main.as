package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	
	/**
	 * ...
	 * @author t
	 */
	public class Main extends Sprite 
	{
		
		private var video:Video;
		private var nc:NetConnection; 
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			video = new Video();
			video.scaleX=video.scaleY=2
			addChild(video);
			
			nc = new NetConnection();
			nc.client = this;
			nc.addEventListener(NetStatusEvent.NET_STATUS, ncStatusChange);
			nc.connect("rtmp://video.xdf.cn/V3/");
		}
		private function ncStatusChange(evn:NetStatusEvent):void
		{
			switch(evn.info.code)
			{
				case "NetConnection.Connect.Success":
					var ds:DynamicStream = new DynamicStream(nc);
					ds.addEventListener(NetStatusEvent.NET_STATUS, nsStatusChange);
					
					var dsi:DynamicStreamItem = new DynamicStreamItem();
					
					dsi.addStream("mp4:video/201208/1343869686_1707399223", 350);
					dsi.addStream("mp4:video/201208/1343956941_621594703", 500);
					dsi.addStream("mp4:video/201207/1341461244_791189404", 800);

					ds.startPlay(dsi);
					
					video.attachNetStream(ds)
					break;
			}
		}
		private function nsStatusChange(evn:NetStatusEvent):void
		{
			/*
			 * NetStream.Play.Transition" "status" 
			 *     仅限 Flash Media Server 3.5 和更高版本。
			 *     服务器收到因比特率流切换而需要过渡到其他流的命令。
			 *     此代码指示用于启动流切换的 NetStream.play2() 调用的成功状态事件。
			 *     如果切换失败，则服务器将改为发送 NetStream.Play.Failed 事件。
			 *     当发生流切换时，将分派带有代码“NetStream.Play.TransitionComplete”的 onPlayStatus 事件。
			 *      用于 Flash Player 10 及更高版本。
			
			*/
			trace(evn.info.code);
		}
		public function onBWDone():void
		{
			
		}
	}
	
}