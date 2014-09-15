package transcode.view
{
	import flash.display.Sprite;
	import com.greensock.TweenMax;
	import game.ui.LeftObjectUI;
	
	public class LeftObjectView extends LeftObjectUI
	{
		private var msgMask:Sprite;
		
		public function LeftObjectView()
		{
			super();
			 
			videoDuration.text="";
			videoRate.text="";
			videoRatio.text="";
			videoCodeType.text="";
			audioCodeType.text="";
			
			msgMask=creatMask();
			msgMask.y=msgMask.height*-1;
			addChild(msgMask);
			msg.mask=msgMask;
		}
		private function buQuan(strTime:String):String
		{
			var array:Array=strTime.split(":");
			if(array[0].length==1)
			{
				array[0]="0"+array[0];	
			}
			if(array[1].length==1)
			{
				array[1]="0"+array[1];	
			}
			if(array[2].length==1)
			{
				array[2]="0"+array[2];	
			}
			return array[0]+":"+array[1]+":"+array[2];
		}
		private function creatMask():Sprite
		{
			var sp:Sprite=new Sprite();
			sp.graphics.beginFill(0x0000ff);
			sp.graphics.drawRect(0,0,this.width,this.height);
			return sp;
		}
		public function set videoData(obj:Object):void
		{
			/**
			 * 时长 infoObj.duration
			 * 码率 infoObj.malv
			 * 分辨率 infoObj.fenBianLv
			 * 视频编码 infoObj.videoMa
			 * 音频编码 infoObj.audioMa
			 */
			
			videoDuration.text=buQuan(obj.duration);
			videoRate.text=obj.malv;
			videoRatio.text=obj.fenBianLv;
			videoCodeType.text=obj.videoMa;
			audioCodeType.text=obj.audioMa;
			TweenMax.to(msgMask,1,{y:0});
		}
		public function clear():void
		{
			msgMask.y=msgMask.height*-1;
			videoDuration.text="";
			videoRate.text="";
			videoRatio.text="";
			videoCodeType.text="";
			audioCodeType.text="";
		}
	}
}