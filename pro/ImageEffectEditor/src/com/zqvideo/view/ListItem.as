package com.zqvideo.view
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class ListItem extends MovieClip
	{
		public var index:uint;
		public var value:String;
		
		private var label:TextField;
		private var _selected:Boolean=false;
		
		private const SELECTED_COLOE:Number=0x00eaff
		
		public function ListItem(s:String):void
		{
			super();
			label=creatItem(120,19,12,0x999999);
			addChild(label);
			label.text=s;
			addEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
		}
		protected function rollOverHandler(event:MouseEvent):void
		{
			addEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
			var textFomat:TextFormat=new TextFormat(null,12,0xffffff);
			label.setTextFormat(textFomat);
		}
		
		protected function rollOutHandler(event:MouseEvent):void
		{
			removeEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
			
			var textFomat:TextFormat
			if(selected)
			{
                textFomat=new TextFormat(null,12,SELECTED_COLOE);
				label.setTextFormat(textFomat);
			}
			else
			{
				textFomat=new TextFormat(null,12,0x999999);
				label.setTextFormat(textFomat);
			}
		}
		private function creatItem(w:Number,h:Number,fontSize:Number,color:Number):TextField
		{
			var text:TextField=new TextField();
			text.width=w
			text.height=h
			text.defaultTextFormat=new TextFormat(null,fontSize,color);
			return text;
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			var textFomat:TextFormat;
			if(_selected)
			{
				textFomat=new TextFormat(null,12,SELECTED_COLOE);
				label.setTextFormat(textFomat);
			}
			else
			{
				textFomat=new TextFormat(null,12,0x999999);
				label.setTextFormat(textFomat);
			}
		}
	}
}