package 
{
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author 奋斗
	 */
	public class Conveyer extends BaseEffect 
	{
		private var tween1:TweenMax;
		private var tween2:TweenMax;
		private var image1:Bitmap;
		private var image2:Bitmap;
		private var imgCon:Sprite;
		public function Conveyer() {
			super();
		}
		override protected function effectStartPlay():void {
			var bitmapData1:BitmapData=Bitmap(bitMapArr[0]).bitmapData.clone();
			var bitmapData2:BitmapData=Bitmap(bitMapArr[1]).bitmapData.clone();
			image1 = new Bitmap(bitmapData1);			
			image2 = new Bitmap(bitmapData2);
			
			var rect:Rectangle=new Rectangle(0, 0, 300, 280);
			container.scrollRect = rect;
			this.transform.perspectiveProjection.projectionCenter = new Point(0,rect.height/2);
			
			//image1.width = image2.width = rect.width;
			//image1.height = image2.height = rect.height;
			image1.y = -rect.height / 2;
			image2.y = image1.y;
			image1.x = -rect.width*2;
			image2.x = -rect.width;
			
			imgCon = new Sprite();
			imgCon.addChild(image1);
			imgCon.addChild(image2);
			imgCon.y = rect.height / 2;
			imgCon.x = rect.width*2;
			
			container.addChild(imgCon);
			//imgCon.rotationY = 30;
			
			
			tween1 = TweenMax.to(imgCon, _duration/2, {rotationY:30, x:rect.width} );
			tween2=TweenMax.to(imgCon, _duration/2, { rotationY:0, onComplete:tween1Complete,delay:_duration/2  } );
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