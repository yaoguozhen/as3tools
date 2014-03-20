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
				var radio:RadioUI = new RadioUI();
				radio.value = array[i][0];
				radio.label.autoSize = "left";
				radio.label.text = array[i][1];
				if (lastRadio)
				{
					if (dir == YRadioUI.HENG)
					{
						radio.y = 0;
						radio.x = lastRadio.x + lastRadio.width + dis;
					}
					else
					{
						radio.x = 0;
						radio.y = lastRadio.y + lastRadio.height + dis;
					}
				}
				else
				{
					radio.x = 0;
					radio.y = 0;
				}
				lastRadio = radio;
				addChild(radio);
			}
			
			setRadios(this);
		}
	}
}