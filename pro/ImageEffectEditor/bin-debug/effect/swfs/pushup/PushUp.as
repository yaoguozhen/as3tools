package  {
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class PushUp extends BaseEffect{

		private var tween1:TweenMax;
		private var tween2:TweenMax;
		private var image1:Bitmap;
		private var image2:Bitmap;
		private var maskSp:Sprite;
		
		public function PushUp() {
			// constructor code
			super();
			Security.allowDomain("*");
		}
		
		override protected function initSetDuration():void {
			duration = 2;
			effectStartPlay();
		}
		
		override protected function effectStartPlay():void {
			container.x=container.y=0;
			var bitmapData1:BitmapData=Bitmap(bitMapArr[0]).bitmapData.clone();
			var bitmapData2:BitmapData=Bitmap(bitMapArr[1]).bitmapData.clone();
			image1 = new Bitmap(bitmapData1);
			
			image2 = new Bitmap(bitmapData2);
			maxWidth=image1.width;
			maxHeight=image1.height;
			
			container.addChild(image1);
			container.addChild(image2);
			image2.y=image1.y+image1.height;
			
			maskSp=new Sprite();
			maskSp.graphics.clear();
			maskSp.graphics.beginFill(0x0,1);
			maskSp.graphics.drawRect(0,0,maxWidth,maxHeight);
			maskSp.graphics.endFill();
			this.addChild(maskSp);
			container.mask=maskSp;
			
			//updateCoord();
			
			tween1=TweenMax.to(container,PLAY_TIME,{y:image1.y-image1.height,onComplete:tween1Complete});
			
			
		}
		
		private function tween1Complete():void{
			if(tween1){
				tween1.pause();
				tween1=null;
			}
			destroy();
			playEnd();
		}
		
		override public function destroy():void{
			bitMapArr=[];
			while(container.numChildren>0){
				container.removeChildAt(0);
			}
			if(maskSp){
				this.removeChild(maskSp);
			    maskSp=null;
			}
			if(image1){
				image1.bitmapData.dispose();
				image1=null;
			}
			if(image2){
				image2.bitmapData.dispose();
				image2=null;
			}
			if(tween1){
				tween1.pause();
				tween1=null;
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
