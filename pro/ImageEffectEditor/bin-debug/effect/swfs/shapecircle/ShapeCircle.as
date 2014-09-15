package  {
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.system.Security;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class ShapeCircle extends BaseEffect{

		private var tween1:TweenMax;
		private var tween2:TweenMax;
		private var image1:Bitmap;
		private var image2:Bitmap;
		private var maskMC:MovieClip;
		
		public function ShapeCircle() {
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
			
			image1.cacheAsBitmap=true;
			image2 = new Bitmap(bitmapData2);
			
			image2.cacheAsBitmap=true;
			
			maskMC=new ZhongJianFangDa();
			maskMC.cacheAsBitmap=true;
			
			container.addChild(image1);
			container.addChild(image2);
			container.addChild(maskMC);
			image2.mask=maskMC;
			//trace(">>>ShapeCircle:"+container.numChildren);
			
			maskMC.addEventListener("MaskPlayEnd",maskPlayEndHandler);
		}
		
		private function maskPlayEndHandler(e:Event):void{
			maskMC.removeEventListener("MaskPlayEnd",maskPlayEndHandler);
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
			if(maskMC){
				maskMC.stop();
			    maskMC=null;
			}
		}
		
		override public function effPlay():void{
			if(tween1){
				tween1.paused=false;
			}
			
			if(tween2){
				tween2.paused=false;
			}
			
			trace("tween 播放");
		}
		
		override public function effPause():void{
			if(tween1){
				tween1.paused=true;
			}
			
			if(tween2){
				tween2.paused=true;
			}
			
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
