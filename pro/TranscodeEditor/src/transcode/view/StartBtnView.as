package transcode.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.ui.StartBtnUI;
	
	public class StartBtnView extends StartBtnUI
	{
		public function StartBtnView()
		{
			super();
			
			changeState("2");
			startBtn.addEventListener(MouseEvent.CLICK,startBtnClickHandler);
		}
		private function startBtnClickHandler(evn:MouseEvent):void
		{
			changeState("3");
			dispatchEvent(new Event("startBtnClick"));
		}
		public function changeState(state:String):void
		{
			switch(state)
			{
				case "1"://startBtn可用
					pointBtn.visible=false;
					startBtn.visible=true;
					startBtn.disabled=false;
					break;
				case "2"://startBtn不可用
					pointBtn.visible=false;
					startBtn.visible=true;
					startBtn.disabled=true;
					break;
				case "3"://显示三个点
					pointBtn.visible=true;
					//pointBtn.disabled=true;
					pointBtn.buttonMode=false;
					pointBtn.mouseChildren=false;
					startBtn.visible=false;
					break;
			}
		}
	}
}