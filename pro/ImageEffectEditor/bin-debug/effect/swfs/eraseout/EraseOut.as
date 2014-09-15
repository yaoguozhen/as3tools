package  {
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.system.Security;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class EraseOut extends BaseEffect{

		private var tween1:TweenMax;
		private var tween2:TweenMax;
		private var image1:Bitmap;
		private var image2:Bitmap;
		private var maskMC:MovieClip;
		private var flag:Boolean=true;
		
		public function EraseOut() {
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
			maskMC=new ZhongJianCaChu();
			container.addChild(image1);
			container.addChild(image2);
			container.addChild(maskMC);
			maskMC.addEventListener("MaskPlayEnd",maskPlayEndHandler);
			image2.mask=maskMC;
			
		}
		
		private function maskPlayEndHandler(e:Event):void{
			maskMC.removeEventListener("MaskPlayEnd",maskPlayEndHandler);
			maskMC.stop();
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
				maskMC=null;
			}
			
		}
		
		override public function effPlay():void{
			maskMC.play();
			
			trace("tween 播放");
		}
		
		override public function effPause():void{
			maskMC.stop();
			
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
