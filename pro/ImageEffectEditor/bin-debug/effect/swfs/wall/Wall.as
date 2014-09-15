package  {
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.system.Security;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Wall extends BaseEffect{

		private var tween1:TweenMax;
		private var tween2:TweenMax;
		private var image1:Bitmap;
		private var image2:Bitmap;
		private var maskMC:MovieClip;
		
		
		public function Wall() {
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
			maxWidth=image1.width;
			maxHeight=image1.height;
			
			maskMC=new Qiang();
			container.addChild(image1);
			image1.cacheAsBitmap=true;
			container.addChild(image2);
			image2.cacheAsBitmap=true;
			container.addChild(maskMC);
			//maskMC.x=(maxWidth-130)/2;
			//maskMC.y=(maxHeight-130)/2;
			maskMC.cacheAsBitmap=true;
			maskMC.addEventListener("MaskPlayEnd",maskPlayEndHandler);
			image2.mask=maskMC;
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
