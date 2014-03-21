package zhen.guo.yao.component.yradio
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author yaoguozhen
	 */
	public class YRadioUI extends YRadio 
	{
		/** 按钮排列方向 **/
		public static const HENG:String = "heng"; //横着排
		public static const SHU:String = "shu"; //竖着排
		
		/**
		 * 生成按钮
		 * @param	array 格式[[value，label], [value，label], [value，label]]
		 * @param	dir 排列方向
		 * @param	dis 间距
		 */
		public function creat(array:Array, dir:String=YRadioUI.SHU, dis:Number=10):void
		{
			var n:uint = array.length;
			var lastRadio;
			for (var i:uint = 0; i < n; i++)
			{
				var item:RadioUI = new RadioUI();
				item.value = array[i][0];
				item.label.autoSize = "left";
				item.label.text = array[i][1];
				if (lastRadio)
				{
					if (dir == YRadioUI.HENG)
					{
						item.y = 0;
						item.x = lastRadio.x + lastRadio.width + dis;
					}
					else
					{
						item.x = 0;
						item.y = lastRadio.y + lastRadio.height + dis;
					}
				}
				else
				{
					item.x = 0;
					item.y = 0;
				}
				lastRadio = item;
				addChild(item);
			}
			
			setComponent(this);
		}
	}
}