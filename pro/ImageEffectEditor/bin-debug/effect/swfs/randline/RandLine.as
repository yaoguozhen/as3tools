package  {
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.system.Security;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class RandLine extends BaseEffect{

		private var tween1:TweenMax;
		private var tween2:TweenMax;
		private var image1:Bitmap;
		private var image2:Bitmap;
		private var maskMC:MovieClip;
		
		public function RandLine() {
			// constructor code
			super();
			Security.allowDomain("*");
		}
		
		override protected function initSetDuration():void {
			duration = 2;
			effectStartPlay();
		}
		
		override protected function effectStartPlay():void {
			var bitmapData1:BitmapData=Bitmap(bitMapArr[0]).bitmapData.clone();
			var bitmapData2:BitmapData=Bitmap(bitMapArr[1]).bitmapData.clone();
			image1 = new Bitmap(bitmapData1);
			image1.width=maxWidth;
			image1.height=maxHeight;
			image2 = new Bitmap(bitmapData2);
			image2.width=maxWidth;
			image2.height=maxHeight;
			
			container.addChild(image1);
			//image1.cacheAsBitmap=true;
			container.addChild(image2);
			image2.cacheAsBitmap=true;
			maskMC=new ZhongJianFangDa();
			container.addChild(maskMC);
			maskMC.cacheAsBitmap=true;
			image2.mask=maskMC;
			image2.alpha=0;
			
			tween1=TweenMax.to(image2,1,{alpha:1});
			
			maskMC.addEventListener("MaskPlayEnd",maskPlayEndHandler);
		}
		
		private function maskPlayEndHandler(e:Event=null):void{
			maskMC.removeEventListener("MaskPlayEnd",maskPlayEndHandler);
			destroy();
			playEnd();
		}
		
		override public function destroy():void{
			bitMapArr=[];
			while(container.numChildren>0){
				container.removeChildAt(0);
			}
			image1.bitmapData.dispose();
			image2.bitmapData.dispose();
			image1=null;
			image2=null;
			maskMC.stop();
			maskMC=null;
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
