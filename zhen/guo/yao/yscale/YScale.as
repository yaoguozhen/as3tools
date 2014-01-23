package zhen.guo.yao.yscale
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	public class YScale 
	{
        /**
         * 等比缩放
         * @param	obj 被缩放对象
         * @param	rect 矩形区域
         * @param	dis 对象据边框的距离
         */
		public static function scale(obj:DisplayObject,rect:Rectangle,dis:Number=0):void
		{
			var rectPer:Number=rect.height/rect.width;
			var objPer:Number=obj.height/obj.width;
	
			if (objPer >= rectPer)
			{
				obj.height = rect.height-dis;
				obj.width = obj.height/objPer;
			}
			else
			{
				obj.width = rect.width-dis;
				obj.height = obj.width*objPer;
			}
			obj.x = rect.x+(rect.width - obj.width) / 2;
			obj.y = rect.y+(rect.height - obj.height) / 2;
		}
	}
}
