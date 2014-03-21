package zhen.guo.yao.component.ycheckbox
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author yaoguozhen
	 */
	public class YCheckBoxUI extends YCheckBox 
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
		public function creat(array:Array, dir:String=YCheckBoxUI.SHU, dis:Number=10):void
		{
			var n:uint = array.length;
			var lastCheckBox;
			for (var i:uint = 0; i < n; i++)
			{
				var item:CheckBoxUI = new CheckBoxUI();
				item.value = array[i][0];
				item.label.autoSize = "left";
				item.label.text = array[i][1];
				if (lastCheckBox)
				{
					if (dir == YCheckBoxUI.HENG)
					{
						item.y = 0;
						item.x = lastCheckBox.x + lastCheckBox.width + dis;
					}
					else
					{
						item.x = 0;
						item.y = lastCheckBox.y + lastCheckBox.height + dis;
					}
				}
				else
				{
					item.x = 0;
					item.y = 0;
				}
				lastCheckBox = item;
				addChild(item);
			}
			
			setComponent(this);
		}
	}
}