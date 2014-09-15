package 
{
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author 奋斗
	 */
	public class Flyover extends BaseEffect 
	{
		private var tween1:TweenMax;
		private var tween2:TweenMax;
		private var image1:Bitmap;
		private var image2:Bitmap;
		private var img1Con:Sprite;
		private var img2Con:Sprite;
		public function Flyover() {
			super();
		}
		override protected function effectStartPlay():void {
			var bitmapData1:BitmapData=Bitmap(bitMapArr[0]).bitmapData.clone();
			var bitmapData2:BitmapData=Bitmap(bitMapArr[1]).bitmapData.clone();
			image1 = new Bitmap(bitmapData1);			
			image2 = new Bitmap(bitmapData2);
			
			container.scrollRect = new Rectangle(0, 0, 300, 280);
			image1.y = -container.scrollRect.height / 2;
			image1.x = -container.scrollRect.width / 2;
			
			image2.y = -container.scrollRect.height / 2;
			image2.x = -container.scrollRect.width / 2;
			
			img1Con = new Sprite();
			img1Con.addChild(image1);
			img2Con = new Sprite();
			img2Con.addChild(image2);
			img2Con.scaleX = img2Con.scaleY = 0;
			img2Con.alpha = 0;
			
			img1Con.x = container.scrollRect.width/2;
			img1Con.y = container.scrollRect.height/2;
			img2Con.x = container.scrollRect.width/2;
			img2Con.y = container.scrollRect.height/2;
			
			
			container.addChild(img2Con);	
			container.addChild(img1Con);
			
			tween2=TweenMax.to(img2Con,_duration,{scaleX:1,scaleY:1,alpha:1});
			tween1=TweenMax.to(img1Con,_duration,{scaleX:2,scaleY:2,alpha:0,onComplete:tween1Complete});
		}
		private function tween1Complete():void{
			if(tween1){
				tween1.pause();
				tween1=null;
			}
			
			if(tween2){
				tween2.pause();
				tween2=null;
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
			if(tween2){
				tween2.pause();
				tween2=null;
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
	}
	
}