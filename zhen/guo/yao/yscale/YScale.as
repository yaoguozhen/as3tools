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
		 * @param   type 缩放类型
         * @param	dis 对象据边框的距离
         */
		public static function scale(obj:DisplayObject,rect:Rectangle,type:String="1",dis:Number=0):void
		{
			switch(type)
			{
				case "1"://等比缩放
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
				    break;
				case "2"://拉伸缩放
				    obj.width = rect.width-dis*2;
					obj.height = rect.height-dis*2;
					obj.x = rect.x+dis;
					obj.y = rect.y+dis;
				    break;
			}
		}
	}
}
