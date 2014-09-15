package transcode.view
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.ui.ExistFileUI;
	
	public class ExistFileComboBox extends ExistFileUI
	{
		public var value:Object;
		public var hasData:Boolean=false;
		public var selectedItemIndex:uint; 
		
		private var listMask:Sprite;
		private var isOpen:Boolean=false;
		private var moving:Boolean=false;
			
		public function ExistFileComboBox()
		{
			super();  
			//close()
			enabled=false;
			
			btn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			list.addEventListener("itemClick",listChangeHandler);
			
			selectedFilesLabel.text="";
			selectedFilesLabel.mouseEnabled=false;
			selectedFilesLabel.mouseChildren=false;
			
			listMask=creatMask();
			listMask.y=list.y-listMask.height;
			listMask.x=list.x-10;
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
		private function listChangeHandler(evn:Event):void
		{
			value=evn.target.value;
			selectedItemIndex=list.selectedIndex;
			selectedFilesLabel.text=String(value);
			btn.toolTip=value;
			close()
		}
		private function getFormatLabel(str:String):String
		{
			if(str.length>13)
			{
				return str.slice(0,13);
			}
			return str;
		}
		private function setListBGHeight(n:uint):void
		{
			var count:uint;
			if(n<=5)
			{
				count=n
			}
			else
			{
				count=5;
			}
			listBG.height=count*27;
		}
		private function btnClickHandler(evn:MouseEvent):void
		{
			/*
			list.visible=!list.visible
			if(list.visible)
			{
				setListBGHeight(list.length)
			}
			else
			{
				setListBGHeight(0)
			}
			*/
			
			if(!moving)
			{
				moving=true;
				if(this.isOpen)
				{
					TweenMax.to(listMask,0.5,{y:list.y-listMask.height,onComplete:closeCompleteHandler});
				}
				else
				{
					list.scrollBar.value=0;
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
		public function get enabled():Boolean
		{
			return btn.disabled;
		}
		override public function set dataSource(obj:Object):void
		{
			hasData=true;
			//obj=["1","2","3","4","2","3","4","2","3","4","2","3","4"]
			list.dataSource=obj;
			if(obj.length>5)
			{
				listBG.height=5*(25);
			}
			else
			{
				listBG.height=obj.length*(25);
			}
			
		}
		public function close(clearSelectData:Boolean=false):void
		{
			//list.visible=false;
			//setListBGHeight(0);
			moving=true;
			TweenMax.to(listMask,0.5,{y:list.y-listMask.height,onComplete:closeCompleteHandler});
			if(clearSelectData)
			{
				value=null;
				btn.label="";
				selectedFilesLabel.text="";
			}
		}
	}
}