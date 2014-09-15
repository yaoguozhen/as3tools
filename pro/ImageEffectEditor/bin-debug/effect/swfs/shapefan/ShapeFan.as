package 
{
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.system.Security;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;

	public class ShapeFan extends BaseEffect
	{

		private var tween1:TweenMax;
		private var tween2:TweenMax;
		private var image1:Bitmap;
		private var image2:Bitmap;
		private var maskMC:MovieClip;
		private var index:int = 0;
		private var timer:Timer;
		
		private var xx:Number

		public function ShapeFan()
		{
			// constructor code
			super();
			Security.allowDomain("*");
		}

		override protected function initSetDuration():void
		{
			duration = 2;
			effectStartPlay();
		}

		override protected function effectStartPlay():void
		{
			var bitmapData1:BitmapData = Bitmap(bitMapArr[0]).bitmapData.clone();
			var bitmapData2:BitmapData = Bitmap(bitMapArr[1]).bitmapData.clone();
			image1 = new Bitmap(bitmapData1);
			image1.width = 300;
			image1.height = 280;
			image2 = new Bitmap(bitmapData2);
			image2.width = 300;
			image2.height = 280;

			container.addChild(image1);
			//image1.cacheAsBitmap=true;
			container.addChild(image2);
			image2.cacheAsBitmap = true;
			maskMC=new MovieClip();
			container.addChild(maskMC);
			maskMC.x = image2.width / 2;
			maskMC.y = image2.height / 2;
			maskMC.cacheAsBitmap = true;
			image2.mask = maskMC;

            xx=getTimer();

			index = 0;
			timer = new Timer(40);
			timer.addEventListener(TimerEvent.TIMER,timerHandler);
			timer.start();
			
		}
        private function addMask():void
		{
			var zhuanQuan:MovieClip=new ZhuanQuan();
			maskMC.addChild(zhuanQuan);
			zhuanQuan.rotation = index * 3;

			var zhuanQuan1:MovieClip=new ZhuanQuan();
			maskMC.addChild(zhuanQuan1);
			zhuanQuan1.rotation =  -  index * 3;
			
			index+=3;
		}
		private function timerHandler(e:TimerEvent):void
		{
			for(var i:uint=0;i<3;i++)
			{
				addMask()
				if(checkFinish(index))
				{
					return ;
				}
			}
		}
        private function checkFinish(index:uint):Boolean
		{
			if (index>90)
			{
				try
				{
					timer.removeEventListener(TimerEvent.TIMER,timerHandler);
					timer.stop();
					timer = null;
					playEnd();
					trace((getTimer()-xx)/1000)
					return true;

				}
				catch (error:Error)
				{
					trace(error);
				}
			}
			return false;
		}
		override public function destroy():void
		{
			bitMapArr = [];
			if(timer){
				try
				{
					timer.removeEventListener(TimerEvent.TIMER,timerHandler);
					timer.stop();
					timer = null;
				}
				catch (error:Error)
				{
					trace(">>>ShapeClock:"+error);
				}
			}
			
			while (container.numChildren>0)
			{
				container.removeChildAt(0);
			}
			while(maskMC.numChildren>0){
				maskMC.removeChildAt(0);
			}
			if(image1){
				image1.bitmapData.dispose();
				image1=null;
			}
			if(image2){
				image2.bitmapData.dispose();
				image2=null;
			}
			if(maskMC){
				maskMC=null;
			}
		}

		override public function effPlay():void
		{
			try{
				timer.start();
			}catch(error:Error){
				trace(error);
			}

			trace("tween 播放");
		}

		override public function effPause():void
		{
			try{
				timer.stop();
			}catch(error:Error){
				trace(error);
			}

			trace("tween 暂停");
		}

		override protected function updateCoord():void
		{
			if (this.parent)
			{
				this.x=(this.parent.width-this.width)/2;
				this.y=(this.parent.height-this.height)/2;
			}
		}
	}

}