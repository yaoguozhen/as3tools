package  {
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import ImageLoader;
	import LoadEvent;
	
	/**
	 * 特效基类
	 * @author .....Li灬Star
	 */
	public class BaseEffect extends MovieClip {
        
		protected var _arrangeID:int=0;
		protected var _bitMapArr:Array = [];
		protected var _duration:Number=0.6;
		protected var container:Sprite;
		protected var maxWidth:Number=390;
		protected var maxHeight:Number=260;
		protected var imageLoader:ImageLoader;
		protected const PLAY_TIME:Number=0.6;
		
		public function BaseEffect() {
			// constructor code
			//init();
			container = new Sprite();
			this.addChild(container);
			init();
		}
		
		public function get arrangeID():int {
			return _arrangeID;
		}
		
		public function set arrangeID(value:int):void {
			_arrangeID = value;
		}
		
		public function get bitMapArr():Array {
			return _bitMapArr;
		}
		
		public function set bitMapArr(value:Array):void {
			_bitMapArr = value;
		}
		
		public function get duration():Number {
			return _duration;
		}
		
		public function set duration(value:Number):void {
			_duration = value;
		}
		
		public function init():void {
			if (bitMapArr.length > 0) {
				
				initSetDuration();
			}else{
				//imageLoader=new ImageLoader();
				//imageLoader.imageUrlArr=["1.jpg","2.jpg"];
				//imageLoader.loadImgData();
				//imageLoader.addEventListener(LoadEvent.IMAGE_ALL_COMPLETE,imageAllLoadComplete);
				//imageLoader.addEventListener(LoadEvent.IMAGE_LOAD_ERROR,imageLoadError);
			}
		}
		
		private function imageAllLoadComplete(e:LoadEvent):void{
			bitMapArr=imageLoader.allBitmapData;
			initSetDuration();
		}
		
		private function imageLoadError(e:LoadEvent):void{
			trace(e.obj.errTxt);
		}
		
		protected function initSetDuration():void {
			effectStartPlay();
		}
		
		protected function effectStartPlay():void {
			
		}
		
		protected function playEnd():void {
			this.dispatchEvent(new Event("ending"));
		}
		
		public function destroy():void{
			
		}
		
		public function effPlay():void{
			
		}
		
		public function effPause():void{
			
		}
		
		protected function updateCoord():void{
			
		}
	}
	
}
