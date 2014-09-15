package game.ui.test
{
	import flash.text.TextField;
	
	import morn.core.components.View;
	
	public class ItemRender extends ItemUI
	{
		public function ItemRender()
		{
			super();
		}
		/*
		override protected function createChildren():void{
			super.createChildren();
			this.graphics.clear();
			this.graphics.beginFill(0xff0000);
			this.graphics.drawRect(0,0,73,71);
			this.graphics.endFill();
			this.addChild(txt);
			
		}
		*/
		override public function set dataSource(value:Object):void{
			super.dataSource=value;
			this.checkbox.label=value.toString();
		}
	}
}