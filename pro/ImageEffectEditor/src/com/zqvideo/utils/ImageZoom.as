package com.zqvideo.utils{

	/**
	 * ...
	 * @author .....Li灬Star
	 * @contact...QQ:168527720
	 */

	public class ImageZoom {

		private var isZoom:Boolean;//是否缩放
		private var srcWidth:Number;//原始宽
		private var srcHeight:Number;//原始高
		private var maxWidth:Number;//限制宽
		private var maxHeight:Number;//限制高
		private var newWidth:Number;//新宽
		private var newHeight:Number;//新高

		public function ImageZoom(srcWidth:Number,srcHeight:Number,maxWidth:Number,maxHeight:Number):void {

			this.srcWidth=srcWidth;
			this.srcHeight=srcHeight;
			this.maxWidth=maxWidth;
			this.maxHeight=maxHeight;
			if (this.srcWidth>0&&this.srcWidth>0) {
				this.isZoom=true;
			} else {
				this.isZoom=false;
			}
			conductimg();
		}

		public function width():Number {
			return Number(this.newWidth.toFixed(2));
		}

		public function height():Number {
			return Number(this.newHeight.toFixed(2));
		}

		private function conductimg():void {
			if (this.isZoom) {
				if (this.srcWidth/this.srcHeight>=this.maxWidth/this.maxHeight) {
					if (this.srcWidth>this.maxWidth) {
						this.newWidth=this.maxWidth;
						this.newHeight=(this.srcHeight*this.maxWidth)/this.srcWidth;
					} else {
						this.newWidth=this.srcWidth;
						this.newHeight=this.srcHeight;
					}
				} else {
					if (this.srcHeight>this.maxHeight) {
						this.newHeight=this.maxHeight;
						this.newWidth=(this.srcWidth*this.maxHeight)/this.srcHeight;
					} else {
						this.newWidth=this.srcWidth;
						this.newHeight=this.srcHeight;
					}
				}
			} else {
				this.newWidth=0;
				this.newHeight=0;
			}
		}
	}
}