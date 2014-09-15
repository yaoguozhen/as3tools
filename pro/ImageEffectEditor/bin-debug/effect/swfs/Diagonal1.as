package 
{
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author 奋斗
	 */
	public class Diagonal1 extends BaseEffect
	{
		private var tween1:TweenMax;
		private var image1:Bitmap;
		private var image2:Bitmap;
		public function Diagonal1() {
			super();
		}
		override protected function effectStartPlay():void {
			var bitmapData1:BitmapData=Bitmap(bitMapArr[0]).bitmapData.clone();
			var bitmapData2:BitmapData=Bitmap(bitMapArr[1]).bitmapData.clone();
			image1 = new Bitmap(bitmapData1);			
			image2 = new Bitmap(bitmapData2);
			container.scrollRect = new Rectangle(0, 0, 300, 280);
			image2.x = -container.scrollRect.width;
			image2.y = container.scrollRect.height;
			container.addChild(image1);
			container.addChild(image2);
			
			
			tween1=TweenMax.to(image2,_duration,{x:0,y:0,onComplete:tween1Complete});
		}
		private function tween1Complete():void{
			if(tween1){
				tween1.pause();
				tween1=null;
			}
			
			destroy();
			playEnd();
		}
		override public function destroy():void {
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
			if(tween1){
				tween1.pause();
				tween1=null;
			}
		}
		override public function effPlay():void{
			if(tween1){
				tween1.paused=false;
			}
			
			trace("tween 播放");
		}
		
		override public function effPause():void{
			if(tween1){
				tween1.paused=true;
			}
			
			trace("tween 暂停");
		}
	}
	
}