package com.zqvideo.utils
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author ..yufeng5259 功能：公共属性：公共方法


	 */
	public class YufengMath
	{
		/**
		 * 计算自动缩放后的大小
		 * @param	contentW
		 * @param	contentH
		 * @param	maxW
		 * @param	maxH
		 * @return  Point
		 */
		public static function autoScaleMath(contentWH:Point,maxWH:Point=null):Point {			
			var w:Number = contentWH.x;
			var h:Number = contentWH.y;
			if (contentWH.x > maxWH.x) {
				w = maxWH.x;
				h = h * w / contentWH.x;
			}
			
			if (h > maxWH.y) {					
				var h1:Number = h;
				h = maxWH.y;
				w = w * h / h1;
			}
			return new Point(w,h);
		}
		/**
		 * 按最大尺寸缩放
		 * 
		 * */
		public static function getMaxSize(contentWH:Point,maxWH:Point):Point{
			var sc:Number=1;
			var w:Number;
			var h:Number;
			w=maxWH.x;				
			sc=maxWH.x/contentWH.x;
			h=contentWH.y*sc;
			if(h> maxWH.y){
				h=maxWH.y;
				sc=maxWH.y/contentWH.y;
				w=contentWH.x*sc;
			}
			return new Point(w,h);
		}
		/**
		 * 获取最大缩放比例
		 * 
		 * */
		public static function getMaxScale(contentWH:Point,maxWH:Point):Number{
			var sc:Number;
			var p1:Point=getMaxSize(contentWH,maxWH);
			sc=Math.max(p1.x/maxWH.x,p1.y/maxWH.y);
			return sc;
		}
		/**
		 * 按最小尺寸缩放
		 * 
		 * */
		public static function getMinSize(contentWH:Point,maxWH:Point):Point{
			var s1:Number=contentWH.x*contentWH.y;
			var s2:Number=maxWH.x*maxWH.y;			
			if(s1> s2){///
				return getMaxSize(maxWH,contentWH);
			}else{
				return contentWH;
			}
		}
		public static function getMinScale(contentWH:Point,maxWH:Point):Number{
			var sc:Number;
			var p1:Point=getMinSize(contentWH,maxWH);
			sc=Math.min(p1.x/maxWH.x,p1.y/maxWH.y);
			return sc;
		}
		
	}

}