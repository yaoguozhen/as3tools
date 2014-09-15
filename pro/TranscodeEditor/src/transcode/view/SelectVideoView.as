package transcode.view
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.ui.SelectVideoUI;
	
	public class SelectVideoView extends SelectVideoUI
	{
		public var selectExistFileName:String;
		
		private var line:Sprite;
		private var upLoadComplete:Boolean=false;
		private var hideUploadBarimer:Timer;
		private var hideComboBoxTimer:Timer;
		private var currentRollOverComboBox:Object;
		
		private var existComboBoxActived:Boolean;
		
		public function SelectVideoView()
		{
			super();
			
			radiogroup_0.addEventListener(MouseEvent.CLICK,valueChangeHandler);
			radiogroup_1.addEventListener(MouseEvent.CLICK,valueChangeHandler);
			existFileComboBox.addEventListener("itemClick",comboBoxChangeHandler);
			templeComboBox.addEventListener("itemClick",comboBoxChangeHandler);
			//stage.addEventListener("click",xxx)
			creatLine();
			
			setComboBoxMouseEvent(templeComboBox);
			setComboBoxMouseEvent(existFileComboBox);
			
			hideUploadBarimer=new Timer(1000,1);
			hideUploadBarimer.addEventListener(TimerEvent.TIMER,hideUploadBarimerHandler);
			
			hideComboBoxTimer=new Timer(100,1);
			hideComboBoxTimer.addEventListener(TimerEvent.TIMER,hideComboBoxTimerHandler);
			creatLine();
		}
		private function setComboBoxMouseEvent(obj:DisplayObject):void
		{
			obj.addEventListener(MouseEvent.ROLL_OVER,comboBoxRollOverHandler);
		}
		private function comboBoxRollOverHandler(evn:MouseEvent):void
		{
				//currentRollOverComboBox=evn.target;
			evn.target.addEventListener(MouseEvent.ROLL_OUT,comboBoxRollOutHandler);
			if(currentRollOverComboBox==evn.target)
			{
				hideComboBoxTimer.reset();
			}
			else
			{
				if(currentRollOverComboBox)
				{
					currentRollOverComboBox.close();
				}
				currentRollOverComboBox=evn.target;
			}
		}
		private function hideComboBoxTimerHandler(evn:TimerEvent):void
		{
			if(currentRollOverComboBox)
			{
				currentRollOverComboBox.close();
			}
			//currentRollOverComboBox=null;
		}
		private function comboBoxRollOutHandler(evn:MouseEvent):void
		{
			hideComboBoxTimer.start();
		}
		private function setLabelStroke(obj:Object,b:Boolean):void
		{
			if(b)
			{
				obj.labelStroke="0xffffff,0.5,8,8,4,2";
			}
			else
			{
				obj.labelStroke="";
			}
		}
		private function valueChangeHandler(evn:Event):void
		{
			switch(evn.currentTarget.value)
			{
				case "0":
					radiogroup_1.selected=false;
					existFileComboBox.close(true);
					existFileComboBox.enabled=false;
					
					setLabelStroke(radiogroup_0,true);
					setLabelStroke(radiogroup_1,false);
					
					dispatchEvent(new Event("selectFile"));
					break;
				case "1":
					radiogroup_0.selected=false;
					
					setLabelStroke(radiogroup_0,false);
					setLabelStroke(radiogroup_1,true);
					
					dispatchEvent(new Event("loadExistFile"));
					/*
					if(existFileComboBox.hasData)
					{
					existFileComboBox.enabled=true;
					}
					else
					{
					dispatchEvent(new Event("loadExistFile"));
					}
					*/
					break;
			}
		}
		private function comboBoxChangeHandler(evn:Event):void
		{
			checkReady()
			if(evn.currentTarget==existFileComboBox)
			{
				selectExistFileName=String(existFileComboBox.value);
				dispatchEvent(new Event("checkVideoMsg"));
			}
		}
		private function checkReady():void
		{
			if((upLoadComplete||existFileComboBox.value)&&templeComboBox.valueArray.length>0)
			{
				dispatchEvent(new Event("dataReady"));
			}
			else
			{
				dispatchEvent(new Event("dataNotReady"));
			}
		}
		private function creatLine():void
		{
			line=new Sprite();
			line.graphics.beginFill(0x08de03);
			line.graphics.drawRect(0,0,100,1);
			line.x=0;
			line.y=74
			line.width=0;
			App.stage.addChild(line);
		}
		private function hideUploadBarimerHandler(evn:TimerEvent):void
		{
			line.width=0;
		}
		
		/**
		 * 上传进度
		 **/
		public function set uploadPer(per:Number):void
		{
			line.width=EditorConfig.APP_WIDTH*per;
		}
		public function onUploadComplete():void
		{
			upLoadComplete=true;
			checkReady();
			hideUploadBarimer.start();
		}
		/**
		 * 设置已存在视频列表数据
		 **/
		public function set existFileList(obj:Object):void
		{
			existFileComboBox.dataSource=obj;
			existFileComboBox.enabled=true;
		}
		public function set templeList(obj:Object):void
		{
			templeComboBox.dataSource=obj; 
			templeComboBox.enabled=true;
		}
		public function get templeSelectedValues():Array
		{
			return templeComboBox.valueArray;
		}
		public function get templeSelectedItemIndexArray():Array
		{
			return templeComboBox.selectedItemIndexArray;
		}
		public function get existFileName():String
		{
			return String(existFileComboBox.value);
		}
		public function get isSection():Boolean
		{
			return sectionCheckBox.selected;
		}
		public function set actived(b:Boolean):void
		{
			if(b)
			{
				radiogroup_0.disabled=false;
				radiogroup_1.disabled=false;
				existFileComboBox.enabled=existComboBoxActived;
				templeComboBox.enabled=true;
				sectionCheckBox.disabled=false;
			}
			else
			{
				existComboBoxActived=!existFileComboBox.enabled;
				
				radiogroup_0.disabled=true; 
				radiogroup_1.disabled=true;
				existFileComboBox.enabled=false;
				templeComboBox.enabled=false;
				sectionCheckBox.disabled=true;
			}
		}
	}
}