package com.zqvideo.view.panel
{
	import com.greensock.TweenMax;
	import com.zqvideo.model.data.DataPoolManager;
	import com.zqvideo.utils.HideOnClickOtherPlace;
	import com.zqvideo.utils.SkinManager;
	import com.zqvideo.view.ListItem;
	import com.zqvideo.view.YScrollBar;
	import com.zqvideo.view.YScrollBarEvent;
	import com.zqvideo.view.core.PanelView;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 *音乐列表 
	 * @author yaoguozhen
	 * 
	 */	
	public class SoundListPanel extends PanelView
	{
		private const DIS:Number=6;//列表item的间隔
		private const SHOW_X:Number=835;//音频列表显示时的横坐标
		
		private var theMask:Sprite;
		private var itemContainer:Sprite;//所有item的容器
        private var _yscrollBar:YScrollBar;//滚动条
		private var currentItem:ListItem;//当前选中item
		private var _scrollBarUI:MovieClip;//滚动条mc
		private var _soundListBG:MovieClip;//音乐列表背景mc
		private var _dataSource:XMLList;//音乐数据
		private var _soundListTitle:MovieClip;//音乐列表title
        private var _visible:Boolean=false;
		
		public function SoundListPanel()
		{
			super();
			init();
		}
		//鼠标滚轮监听器
		private function mouseWheelHandler(evn:MouseEvent):void
		{
			if(evn.delta<0)
			{
				_yscrollBar.scroll("up");
			}
			else
			{
				_yscrollBar.scroll("down");
			}
		}
		
		private function setDataSource(xmlList:XMLList):void
		{
			var itemCount:uint=xmlList.length();
			var item:MovieClip;
			var itemHeight:Number
			for(var i:uint=0;i<itemCount;i++)
			{
				item=new ListItem(xmlList[i].@label); 
				itemHeight=item.height;
				item.buttonMode=true;
				item.mouseChildren=false;
				item.buttonMode=true;
				item.index=i;
				item.y=i*itemHeight;
				item.value=xmlList[i].@value
				itemContainer.addChild(item);
			}	
		}
		private function creatMask():void
		{
			theMask=new Sprite();
			theMask.graphics.beginFill(0x0000ff);
			theMask.graphics.drawRect(0,0,128,266);
			addChild(theMask);
		}
		
		private function init():void
		{
			var ScrollBarCls:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info, "ScrollBar");
			_scrollBarUI=new ScrollBarCls();
			
			var SoundListBGCls:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info, "SoundListBG");
			_soundListBG=new SoundListBGCls();
			
			var SoundListTitleCls:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info, "SoundListTitle");
			_soundListTitle=new SoundListTitleCls();
			_soundListTitle.y=0-_soundListTitle.height+4;
			addChild(_soundListBG)
			addChild(_soundListTitle);
			
			itemContainer=new Sprite();
			itemContainer.addEventListener(MouseEvent.CLICK,containerClickHandler);
			itemContainer.y=DIS;
			itemContainer.x=14;
			addChild(itemContainer);
			
			creatMask();
			theMask.x=itemContainer.x;
			theMask.y=itemContainer.y;
			theMask.width=_soundListBG.width;
			itemContainer.mask=theMask;
			
			this.x=SHOW_X+_soundListBG.width;
			
			//点击音乐列表其他地方的时候，列表消失
			var hideOnClickOtherPlace:HideOnClickOtherPlace=new HideOnClickOtherPlace();
			//hideOnClickOtherPlace.setObject(Root.stage,this,hideList);
		}
		
		protected function containerClickHandler(event:MouseEvent):void
		{
			var item:ListItem=event.target as ListItem;
			if(currentItem)
			{
				if(currentItem==item)
				{
					
				}
				else
				{
					currentItem.selected=false;
					currentItem=item;
					currentItem.selected=true;
					creatFullURL(currentItem.value)
					sendNotification("soundListChangeCommand",{soundURL:Root.soundPlayURL});
				}
			}
			else
			{
				currentItem=item;
				currentItem.selected=true;
				creatFullURL(currentItem.value)
				sendNotification("soundListChangeCommand",{soundURL:Root.soundPlayURL});
			}
		}
		private function creatFullURL(value:String):void
		{
			Root.soundPlayURL=encodeURI(Root.soundHttpHost+value);
			Root.soundTranscodeURL=Root.soundTranscodeHost+value;
		}
		private function hideList():void
		{
			this.visible=false;
		}
		private function scrollBarChangeHandler(event:YScrollBarEvent):void
		{
			trace(event.contentMoveDir,event.value);
		}
		public function get dataSource():XMLList
		{
			return _dataSource
		}
		/**
		 *设置音乐数据 
		 * @param data 音乐的xmlList数据
		 * 
		 */		
		public function set dataSource(data:XMLList):void
		{
			/*
			var xml:XML=new XML("<a><sound label='1' value='1'/>"+
				"<sound label='1' value='1'/>"+
				"<sound label='1' value='1'/>"+
				"<sound label='1' value='1'/>"+
				"<sound label='1' value='1'/>"+
				"<sound label='1' value='1'/>"+
				"<sound label='1' value='1'/>"+
				"<sound label='1' value='1'/>"+
				"<sound label='1' value='1'/>"+
				"<sound label='1' value='1'/>"+
				"<sound label='1' value='1'/>"+
				"<sound label='1' value='1'/>"+
				"<sound label='1' value='1'/>"+
				"<sound label='1' value='1'/>"+
				"<sound label='1' value='1'/></a>")
			data=xml.sound
			*/
			_dataSource=data;
			setDataSource(_dataSource);

			if(itemContainer.height>theMask.height)//如果音乐列表的高度超出了显示区域的高度
			{
				addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler);
				_yscrollBar=new YScrollBar();
				_yscrollBar.addEventListener(YScrollBarEvent.VALUE_CHANGE,scrollBarChangeHandler);
				addChild(_scrollBarUI);
				_scrollBarUI.x=_soundListBG.x+_soundListBG.width-_scrollBarUI.width-3;
				_scrollBarUI.y=10;
				//_soundListBG.height=theMask.height+DIS+DIS;
				_yscrollBar.init(itemContainer,_scrollBarUI,theMask.x,theMask.y,theMask.width,theMask.height);
			}
			else
			{
				removeEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler);
				//_soundListBG.height=itemContainer.height+DIS+DIS;
			}
		}
        //重写visible属性为带缓动效果的消失
		override public function set visible(b:Boolean):void
		{
			_visible=b;
			if(b)
			{
				TweenMax.to(this,0.3,{x:SHOW_X});
			}
			else
			{
				TweenMax.to(this,0.3,{x:SHOW_X+_soundListBG.width});
			}
		}
		override public function get visible():Boolean
		{
			return _visible;
		}
		//音乐列表的高度为背景图片的高度
		override public function get height():Number
		{
			return _soundListBG.height
		}
		/*public function clear():void
		{
			if(currentItem)
			{
				currentItem.selected=false;
				currentItem=null;
			}
		}*/
		
	}
}