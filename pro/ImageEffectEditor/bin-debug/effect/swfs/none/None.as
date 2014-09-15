package  {
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.system.Security;
	import com.greensock.TweenMax;
	import flash.display.BitmapData;
	
	public class None extends BaseEffect {
        
		private var image1:Bitmap;
		private var tween:TweenMax;
		private var _nonePlayTime:Number=1;
		
		public function None() {
			// constructor code
			super();
			Security.allowDomain("*");
		}
		
		public function get nonePlayTime():Number{
			return _nonePlayTime;
		}
		
		public function set nonePlayTime(value:Number):void{
			_nonePlayTime=value;
		}
		
		override protected function initSetDuration():void {
			duration = nonePlayTime;
			effectStartPlay();
		}
		
		override protected function effectStartPlay():void {
			var bitmapData:BitmapData=Bitmap(bitMapArr[0]).bitmapData.clone();
			image1 = new Bitmap(bitmapData);
			container.addChild(image1);
			image1.alpha=1;
			image1.visible=true;
			
			//updateCoord();
			//trace(">>>none effect:"+image1.alpha+"//"+image1.visible+"//"+image1.x+"||"+image1.y+"||"+image1.width+"//"+image1.height);
			tween=TweenMax.delayedCall(duration,tweenComplete);
		}
		
		private function tweenComplete():void{
			if(tween){
				tween.pause();
				tween=null;
			}
			destroy();
			playEnd();
			
		}
		
		override public function destroy():void{
			bitMapArr=[];
			while(container.numChildren>0){
				container.removeChildAt(0);
			}
			if(image1){
				image1.bitmapData.dispose();
			    image1=null;
			}
			if(tween){
				tween.pause();
				tween=null;
			}
			trace(">>>none destroy");
		}
		
		override public function effPlay():void{
			if(tween){
				tween.paused=false;
				trace("tween 播放");
			}
			
			if(image1){
				image1.x=0;
				image1.y=0;
			}
		}
		
		override public function effPause():void{
			if(tween){
				tween.paused=true;
				trace("tween 暂停");
			}
			
			if(image1){
				image1.x=0;
				image1.y=0;
			}
		}
		
		override protected function updateCoord():void{
			if(this.parent){
				this.x=(this.parent.width-this.width)/2;
				this.y=(this.parent.height-this.height)/2;
			}
		}
	}
	
}
