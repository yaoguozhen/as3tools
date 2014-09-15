package  {
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.system.Security;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Wave extends BaseEffect{

		private var tween1:TweenMax;
		private var tween2:TweenMax;
		private var image1:Bitmap;
		private var image2:Bitmap;
		private var maskMC:MovieClip;
		
		public function Wave() {
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
			
			image2 = new Bitmap(bitmapData2);
			
			
			container.addChild(image1);
			image1.cacheAsBitmap=true;
			container.addChild(image2);
			image2.cacheAsBitmap=true;
			maskMC=new ZhongJianFangDa();
			container.addChild(maskMC);
			maskMC.scaleX=0.8;
			maskMC.scaleY=0.8;
			maskMC.y=20;
			maskMC.cacheAsBitmap=true;
			image2.mask=maskMC;
			
			maskMC.addEventListener("MaskPlayEnd",maskPlayEndHandler);
			
			//tween1=TweenMax.to(image1,5,{alpha:0,onComplete:tween1Complete});
		}
		
		private function tween1Complete():void{
			if(tween1){
				tween1.pause();
				tween1=null;
			}
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
			if(maskMC){
				maskMC.play();
			}
			
			trace("tween 播放");
		}
		
		override public function effPause():void{
			if(maskMC){
				maskMC.stop();
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
