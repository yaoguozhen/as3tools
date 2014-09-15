package transcode.view
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.ui.TempleComboBoxUI;
	
	import morn.core.components.Component;
	import morn.core.handlers.Handler;
	
	public class TempleComboBox extends TempleComboBoxUI
	{
		public var valueArray:Array=[];
		public var selectedItemIndexArray:Array=[];
		private var labelArray:Array=[];
		private var listInitY:Number;
		private var showScrollBar:Boolean;
		private var listMask:Sprite;
		private var isOpen:Boolean=false;
		private var moving:Boolean=false;
		
		public function TempleComboBox()
		{
			super(); 
			listInitY=list.y;
			//list.visible=false; 
			list.mc.init(5,200);
			enabled=false;
			btn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			list.addEventListener("itemClick",listChangeHandler);
			list.mc.addEventListener("scrollValueChanged",scrollValueChangedHandler);
			//scrollBar.visible=false;
			scrollBar.scrollSize=10;
			scrollBar.changeHandler=new Handler(scrollBarChanged);  
			
			selectedFilesLabel.text="";
			selectedFilesLabel.mouseEnabled=false;
			selectedFilesLabel.mouseChildren=false;
			
			listMask=creatMask();
			listMask.y=list.y-listMask.height;
			listMask.x=list.x;
			addChild(listMask);
			listBox.mask=listMask;
		}
		private function creatMask():Sprite
		{
			var sp:Sprite=new Sprite();
			sp.graphics.beginFill(0x0000ff);
			sp.graphics.drawRect(0,0,list.width+20,300);
			return sp;
		}
		private function scrollBarChanged(v:Number):void
		{
			trace("x!@#$%:",v)
			list.mc.scroll(v)
		}
		private function checkValueArray(array:Array, value:Object):void
		{
			var find:Boolean=false;
			var n:uint=array.length;
			for(var i:uint=0;i<n;i++)
			{
				if(array[i]==value)
				{
					find=true;
					
					break;
				}
			}
			if(find)
			{
				array.splice(i,1);
			}
			else
			{
				array.push(value);
			}
		}
		private function getFormatLabel(str:String):String
		{
			if(str.length>23)
			{
				return str.slice(0,23);
			}
			return str;
		}
		private function listChangeHandler(evn:Event):void
		{
			checkValueArray(valueArray, evn.target.value);
			checkValueArray(selectedItemIndexArray, list.mc.index);
			checkValueArray(labelArray, list.mc.fullLabel);
			trace("list.mc.fullLabel:",list.mc.fullLabel)
			var fullLabel:String=labelArray.toString();
			//btn.label=getFormatLabel(fullLabel);
			selectedFilesLabel.text=fullLabel;
			btn.toolTip=fullLabel;  
		}
		private function scrollValueChangedHandler(evn:Event):void
		{
			scrollBar.value=list.mc.currentV;
		}
		private function btnClickHandler(evn:MouseEvent):void
		{
			if(!moving)
			{
				moving=true;
				scrollBar.visible=showScrollBar;
				if(this.isOpen)
				{
					//trace("this.isOpen")
					
					//trace(showScrollBar)
					TweenMax.to(listMask,0.5,{y:list.y-listMask.height,onComplete:closeCompleteHandler});
				}
				else
				{
					scrollBar.value=0;
					TweenMax.to(listMask,0.5,{y:list.y,onComplete:openCompleteHandler});
				}
			}
		}
		private function openCompleteHandler():void
		{
			trace("openComplete")
			moving=false;
			isOpen=true
		}
		private function closeCompleteHandler():void
		{
			moving=false
			isOpen=false;
		}
		public function set enabled(b:Boolean):void
		{
			btn.disabled=!b;
		}
		override public function set dataSource(obj:Object):void
		{
			var n:uint=obj.length;
			for(var i:uint=0;i<n;i++)
			{
				obj[i].label=obj[i].template_name
				obj[i].value=obj[i].template_id
			}
			list.mc.setDataSource(obj);
			showScrollBar=list.mc.getShowScrollBar();
		}
		public function close():void
		{
			moving=true;
			TweenMax.to(listMask,0.5,{y:list.y-listMask.height,onComplete:closeCompleteHandler});
		}
	}
}