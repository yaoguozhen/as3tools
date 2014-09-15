package transcode.view
{
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import game.ui.RightObjectUI;
	
	import morn.core.components.Box;
	import morn.core.components.Button;
	import morn.core.components.Label;
	import morn.core.utils.ObjectUtils;
	
	public class RightObjectView extends RightObjectUI
	{
		public var url:String
		
		private var videoArray:Array;
		private var lightNumMask:Sprite;
		private var targetShowBox:Box;
		
		public function RightObjectView()
		{
			super();
			
			light1.label="";
			light2.label="";
			light3.label="";
			light4.label="";
			light5.label="";
			
			//cannotPreviewLabel.font="Microsoft Yahei";
			cannotPreviewLabel.filters=[new GlowFilter(0x03e2d0,.6,7,7,2,2)];
			
			//videoPreviewLabel.font="Microsoft Yahei";
			videoPreviewLabel.filters=[new GlowFilter(0x03e2d0,.6,7,7,2,2)]; 
			
			//videoIndex.font="Microsoft Yahei";
			videoIndex.filters=[new GlowFilter(0x03e2d0,.6,7,7,2,2)];
			
			preBox.alpha=0;
			preBox.visible=false;
			cannotPreviewBox.alpha=0;
			cannotPreviewBox.mouseEnabled=false;
			cannotPreviewBox.mouseEnabled=false;
			var lightBtn:Button
			var lightNumLabel:Label; 
			for(var i:uint=1;i<=5;i++)
			{
				lightBtn=getChildByName("light"+i) as Button;
				lightBtn.disabled=true;
				
				lightNumLabel=this["lightNum"+i]; 
				lightNumLabel.visible=false;
				lightNumLabel.mouseEnabled=false;
			}
			
			//fullscreenBtn.disabled=true;
			//fullscreenBtn.addEventListener(MouseEvent.CLICK,fullscreenBtnClickHandler);
			preBox.addEventListener(MouseEvent.CLICK,fullscreenBtnClickHandler);
			
			downloadBtn.disabled=true;
			downloadBtn.addEventListener(MouseEvent.CLICK,downloadBtnClickHandler);
			
			lightNumMask=creatMask();
			lightNumMask.y=lightNumBox.y-lightNumMask.height;
			lightNumMask.x=lightNumBox.x;
			addChild(lightNumMask);
			lightNumBox.mask=lightNumMask;
			
			//this.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		/*
		private function clickHandler (e:Event):void
		{
			videoData=["a","b",'3','5']
		}
		*/
		private function creatMask():Sprite
		{
			var sp:Sprite=new Sprite();
			sp.graphics.beginFill(0x0000ff);
			sp.graphics.drawRect(0,0,lightNumBox.width,lightNumBox.height);
			return sp;
		}
		private function fullscreenBtnClickHandler(evn:MouseEvent):void
		{
			/*
			if(App.stage.displayState==StageDisplayState.NORMAL){
				//EditorConfig.fullscreen_target=EditorConfig.STAGE_FULL;
				App.stage.displayState=StageDisplayState.FULL_SCREEN;
			}
			else
			{
				App.stage.displayState=StageDisplayState.NORMAL;
			}
			*/
			dispatchEvent(new Event("playVideo"));
		}
		private function downloadBtnClickHandler(evn:MouseEvent):void
		{
			dispatchEvent(new Event("downloadVideo"));
		}
		private function lightBtnRollOverHandler(evn:MouseEvent):void
		{
			/*
			if(videoPlayer.visible==false)
			{
				var btn:Button=evn.currentTarget as Button;
				btn.addEventListener(MouseEvent.ROLL_OUT,lightBtnRollOutHandler);
				
				var index:uint=uint(String(btn.name).charAt(5));
				videoIndex.text="NO."+index;
				preBox.alpha=1;
			}
			*/
		}
		private function lightBtnRollOutHandler(evn:MouseEvent):void
		{
			//var btn:Button=evn.currentTarget as Button;
			//btn.removeEventListener(MouseEvent.ROLL_OUT,lightBtnRollOutHandler);
			
			//preBox.alpha=0;
		}
		private function lightBtnClickHandler(evn:MouseEvent):void
		{
			//var btn:Button=evn.currentTarget as Button;
			//var index:uint=uint(String(btn.name).charAt(5))-1;
			//playVideo(videoArray[index]);
			
			var btn:Button=evn.currentTarget as Button;
			btn.addEventListener(MouseEvent.ROLL_OUT,lightBtnRollOutHandler);
			
			var index:uint=uint(String(btn.name).charAt(5));
			url=videoArray[index-1];
			
			if(targetShowBox)
			{
				targetShowBox.alpha=0;
			}
			if(url.indexOf(".flv")>0||url.indexOf(".mp4")>0)
			{
				trace("===================")
				preBox.visible=true
				videoIndex.text="NO."+index;
				
				
				targetShowBox=preBox;
				targetShowBox.buttonMode=true; 
			}
			else
			{
				trace("!!!!!!!!!!!!!!!!")
				preBox.visible=false;
				targetShowBox=cannotPreviewBox;
			}
			targetShowBox.alpha=0;
			TweenMax.to(targetShowBox,0.5,{alpha:1});
			
			
			//fullscreenBtn.disabled=false;
			downloadBtn.disabled=false;
		}
		public function clear():void
		{
			url=null;
			if(videoArray)
			{
				var n:uint=videoArray.length;
				var lightBtn:Button
				for(var i:uint=1;i<=n;i++)
				{
					lightBtn=getChildByName("light"+i) as Button;
					lightBtn.removeEventListener(MouseEvent.ROLL_OVER,lightBtnRollOverHandler);
					lightBtn.removeEventListener(MouseEvent.CLICK,lightBtnClickHandler);
					lightBtn.disabled=true;
					
					var light:DisplayObject=this["lightNum"+i]; 
					light.visible=false;
				}
			}
			if(targetShowBox)
			{
				targetShowBox.alpha=0;
				targetShowBox.visible=false;
			}
			//fullscreenBtn.disabled=true;
			downloadBtn.disabled=true;
			
			videoArray=null;
		}
		public function set videoData(array:Array):void
		{
			videoArray=array;
			
			var lightBtn:Button;
			var n:uint=videoArray.length;
			var lightNumLabel:DisplayObject
			for(var i:uint=1;i<=n;i++)
			{
				lightBtn=getChildByName("light"+i) as Button;
				lightBtn.addEventListener(MouseEvent.ROLL_OVER,lightBtnRollOverHandler);
				lightBtn.addEventListener(MouseEvent.CLICK,lightBtnClickHandler);
				lightBtn.disabled=false;
				
				lightNumLabel=this["lightNum"+i];
				lightNumLabel.visible=true;
			}
			
			TweenMax.to(lightNumMask,1,{y:lightNumBox.y});
		}
	}
}