package transcode.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.ui.CheckBoxItemUI;
	
	public class TempleComboBoxItemRender extends CheckBoxItemUI
	{
		public var  value:Object
		public var fullLabel:String;
		public var itemType:String="templeComboBoxItem";
		
		public function TempleComboBoxItemRender()
		{
			super();
			//label.text="";
		}
		private function itemClickHandler(evn:MouseEvent):void
		{
			//btn.selected=!btn.selected
			//Object(item).mc.gotoAndStop(3)
			dispatchEvent(new Event("itemClick",true));
		}
		private function getFormatLabel(str:String):String
		{
			if(str.length>23)
			{
				return str.slice(0,23);
			}
			return str;
		}
		public function set selected(b:Boolean):void
		{
			//btn.selected=b;
		}
		override public function set dataSource(obj:Object):void{
			super.dataSource=obj.template_name;
			value=obj.template_id;
			fullLabel=obj.template_name.toString();
			this.toolTip=fullLabel;
			
			Object(item).mc.setDataSource(obj);
			trace(Object(item).mc)
			//Object(item).mc.label.text=getFormatLabel(fullLabel)
			//item.label=getFormatLabel(fullLabel);
			//Object(item).addEventListener(MouseEvent.CLICK,itemClickHandler);
		}
	}
}