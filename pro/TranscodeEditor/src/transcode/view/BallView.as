package transcode.view
{
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.utils.Timer;
	
	import game.ui.BallUI;
	
	import org.osmf.events.TimeEvent;
	
	public class BallView extends BallUI
	{
		private var timer:Timer;
		
		public function BallView()
		{
			super();
			doing.stop();
			doing.interval=30
			doing.visible=false;
			times.visible=true
			times.alpha=0;
			doPer.text="";
            
			initTimer();
			timer.start();
			
			setFontFilter();
		}
		private function setFontFilter():void
		{
			videoDuration.font="Microsoft Yahei";
			videoDuration.filters=[new GlowFilter(0x03e2d0,.6,7,7,2,2)];
			
			useTime.font="Microsoft Yahei";
			useTime.filters=[new GlowFilter(0x03e2d0,.6,7,7,2,2)];
			
			//libDraLabel.font="Microsoft Yahei";
			//libDraLabel.filters=[new GlowFilter(0x03e2d0,.6,7,7,2,2)];
			
			//tranUseTimeLabel.font="Microsoft Yahei";
			//tranUseTimeLabel.filters=[new GlowFilter(0x03e2d0,.6,7,7,2,2)]; 
		}
		private function initTimer():void
		{
			timer=new Timer(1500,1);
			timer.addEventListener(TimerEvent.TIMER,timerHandler);
		}
		private function timerHandler(evn:TimerEvent):void
		{
			TweenMax.to(firstLabel,0.5,{alpha:0,onComplete:hideComplete});
		}
        private function hideComplete():void
		{
			dispatchEvent(new Event("labelHideFinish"));
			TweenMax.to(times,1.5,{alpha:1});
		}
		private function formatTime(time:String):String
		{
			var array:Array=time.split(":");
			var n:uint=array.length;
			for(var i:uint=0;i<n;i++)
			{
				if(array[i].length==1)
				{
					array[i]="0"+array[i];
				}
			}
			return array[0]+":"+array[1]+":"+array[2];
		}
		private function formatNumberTime(time:Number):String
		{
			var totalScend:Number=int(time/1000);
			var hour:uint=int(totalScend/60/60);
			var min:uint=int((totalScend-hour*60*60)/60);
			var second:uint=totalScend-hour*60*60-min*60;
			
			var strHour:String;
			var strMin:String;
			var strSecond:String;
			
			if(hour<10)
			{
				strHour="0"+hour
			}
			else
			{
				strHour=String(hour);
			}
			if(min<10)
			{
				strMin="0"+min
			}
			else
			{
				strMin=String(min);
			}
			if(second<10)
			{
				strSecond="0"+second
			}
			else
			{
				strSecond=String(second);
			}
            return strHour+":"+strMin+":"+strSecond;
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
		public function transcodePer(per:String,isAlert:Boolean=false):void
		{
			doPer.text=per;
			if(isAlert)
			{
				doPer.color=0xff0000;
			}
			else
			{
				doPer.color=0x99FF00;
			}
		}
		public function showDoing(b:Boolean):void
		{
			doing.visible=b;
			if(b)
			{
				doing.play();
			}
			else
			{
				doing.stop();
			}
		}
		public function setVideoDuration(duration:String):void
		{
			videoDuration.text=formatTime(duration);
		}
		public function setUseTime(time:Number):void
		{
			useTime.text=formatNumberTime(time);
		}
	}
}