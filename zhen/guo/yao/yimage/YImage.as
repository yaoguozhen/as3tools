package  zhen.guo.yao.yimage
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.display.DisplayObject
	import flash.display.Bitmap
	import flash.geom.Rectangle;

	/**
	 * 显示对象的注册点需在左上角
	 * @author yaoguozhen
	 */
	public class YImage 
	{
		/**
		 * 返回显示对象制定区域的bitmapdata数据
		 * @param	obj 显示对象
		 * @param	rect 要截取的矩形区域
		 * @return 显示对象制定区域的bitmapdata数据   
		 */
		public static function getBitmapData(obj:DisplayObject, rect:Rectangle=null):BitmapData
		{
			var allBmd:BitmapData=new BitmapData(obj.width,obj.height);
			allBmd.draw(obj);
			
			if(rect)
			{
				var newBitmapData:BitmapData = new BitmapData(rect.width, rect.height);
				newBitmapData.copyPixels(allBmd, rect, new Point(0,0));
				return newBitmapData;
			}
			
			return allBmd
		}
		/**
		 * 将显示对象的指定区域保存为jpg图片
		 * @param	obj 显示对象
		 * @param	rect 指定的矩形区域
		 * @param	quality 图片质量。0-100
		 * @param	fileName 文件名称。无需扩展名
		 */
		public static function saveToLocal(obj:DisplayObject, rect:Rectangle=null, quality:Number=70, fileName:String='image'):void
		{
			var jpgSource:BitmapData = getBitmapData(obj, rect)
					
			var encoder = new JPGEncoder(quality);
			var bytes:ByteArray = encoder.encode(jpgSource);

			fileName+=".jpg";
			 
			var file:FileReference=new FileReference();
			file.save(bytes,fileName);
		}
		/**
		 * 返回显示对象指定区域对应的的位图
		 * @param	obj 显示对象
		 * @param	rect 指定区域
		 * @param	smooth 是否光滑
		 * @return 显示对象指定区域对应的的位图
		 */
		public static function getBitmap(obj:DisplayObject, rect:Rectangle=null, smooth:Boolean=false):Bitmap
		{
			var newBitmapData:BitmapData = getBitmapData(obj, rect);
			return new Bitmap(newBitmapData, "auto", smooth);
		}
	}

}