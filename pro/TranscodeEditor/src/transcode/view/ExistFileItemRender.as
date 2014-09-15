package transcode.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.ui.LabelItemUI;
	
	public class ExistFileItemRender extends LabelItemUI
	{
		public var  value:Object
		public var itemType:String="existFileItem";
		
		public function ExistFileItemRender()
		{
			super();
		}
		private function itemClickHandler(evn:MouseEvent):void
		{
			dispatchEvent(new Event("itemClick",true));
		}
		private function getFormatLabel(str:String):String
		{
			if(str.length>13)
			{
				return str.slice(0,13);
			}
			return str;
		}
		override public function set dataSource(obj:Object):void{
			super.dataSource=obj; 
			value=obj
			this.item.toolTip=obj;
			this.item.text=value.toString();
			item.addEventListener(MouseEvent.CLICK,itemClickHandler);
		}
	}
}