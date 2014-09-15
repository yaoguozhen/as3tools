package  {
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.system.Security;
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.vj.fx.Pixelator;
	
	
	public class Mosaic extends BaseEffect{

		private var tween1:TweenMax;
		private var tween2:TweenMax;
		private var image1:Bitmap;
		private var image2:Bitmap;
		private var px:Pixelator;
		
		public function Mosaic() {
			// constructor code
			super();
			Security.allowDomain("*");
		}
		
		override protected function initSetDuration():void {
			duration = PLAY_TIME;
			effectStartPlay();
		}
		
		override protected function effectStartPlay():void {
			var bitmapData1:BitmapData=Bitmap(bitMapArr[0]).bitmapData.clone();
			var bitmapData2:BitmapData=Bitmap(bitMapArr[1]).bitmapData.clone();
			image1 = new Bitmap(bitmapData1);
			
			image2 = new Bitmap(bitmapData2);
			
			
			px = new Pixelator(image1, image2, 20);
			px.addEventListener(Pixelator.PIXEL_TRANSITION_COMPLETE, onComplete);
			container.addChild(px);
			px.startTransition(Pixelator.PIXELATION_FAST);
		}
		
		private function onComplete(e:Event):void {
			if(px&&px.hasEventListener(Pixelator.PIXEL_TRANSITION_COMPLETE)){
				px.removeEventListener(Pixelator.PIXEL_TRANSITION_COMPLETE, onComplete);
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
			if(image2){
				image2.bitmapData.dispose();
				image2=null;
			}
			if(px&&px.hasEventListener(Pixelator.PIXEL_TRANSITION_COMPLETE)){
				px.removeEventListener(Pixelator.PIXEL_TRANSITION_COMPLETE, onComplete);
			}
			if(px){
				px=null;
			}
		}
		
		override public function effPlay():void{
			px.pixelPlay();
			
			trace("tween 播放");
		}
		
		override public function effPause():void{
			px.pixelPause();
			
			trace("tween 暂停");
		}
		
		override protected function updateCoord():void{
			if(this.parent){
				this.x=(this.parent.width-this.width)/2;
				this.y=(this.parent.height-this.height)/2;
			}
		}
	}
	
}
