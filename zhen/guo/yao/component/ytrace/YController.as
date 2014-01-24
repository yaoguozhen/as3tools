package zhen.guo.yao.component.ytrace 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author yaoguozhen
	 */
	internal class YController extends Sprite 
	{		
		public const DIS:Number = 5;
		
		/**
		 * 构造函数
		 * @param	w 高度
		 * @param	h 宽度
		 */
		public function YController():void
		{
			var btn:YButton;
			var n:uint = YData.btnArray.length;
			for (var i:uint = 0; i < n; i++)
			{
				if (YData.btnArray[i][2])
				{
					btn = new YButton(YData.btnArray[i][0]);
				}
				else
				{
					btn = new YButton(YData.btnArray[i][0]+"[0]");
				}
				
				btn.btnType = YData.btnArray[i][1];
				//btn.selected = true;
				btn.addEventListener(MouseEvent.CLICK, btnClickHandler);
				YData.btnArray[i].push(btn);
				addChild(btn);
			}
			
			setBtnsPosition();
		}
		 //按钮点击事件侦听器
		private function btnClickHandler(evn:MouseEvent):void
		{
			var btn:YButton = YButton(evn.target);
			
			var event:YBtnClickEvent = new YBtnClickEvent(YBtnClickEvent.BTN_CLICK);
			event.btnType = btn.btnType;
			dispatchEvent(event);
		}
		private function setBtnsPosition():void
		{
			var lastBtn:YButton;
			var n:uint = YData.btnArray.length;
			for (var i:uint = 0; i < n; i++)
			{
				if (lastBtn == null)
				{
					YData.btnArray[i][3].x = DIS;
					lastBtn = YData.btnArray[i][3];
				}
				else
				{
					YData.btnArray[i][3].x = lastBtn.x + lastBtn.width + DIS;
					lastBtn = YData.btnArray[i][3];
				}
				YData.btnArray[i][3].y = YData.areaHeight - YData.btnArray[i][3].height - DIS;
			}
		}
		public function setCount(msgType:String, count:String ):void
		{
			var n:uint = YData.btnArray.length;
			for (var i:uint = 0; i < n; i++)
			{
				if (YData.btnArray[i][1] == msgType)
				{
					YData.btnArray[i][3].label = YData.btnArray[i][0] + "[" + count + "]";
					setBtnsPosition();
					break;
				}
				
			}
		}
		public function clearMsg():void
		{
			var n:uint = YData.btnArray.length;
			for (var i:uint = 0; i < n; i++)
			{
				switch(YData.btnArray[i][1])
				{
					case YTrace.ALERT:
					case YTrace.ERROR:
					case YTrace.ALL:
						YData.btnArray[i][3].label = YData.btnArray[i][0] + "[0]";
						break;
					case YTrace.CLEAR:
						YData.btnArray[i][3].label = YData.btnArray[i][0];
						break;	
				}
			}
		}
	}

}