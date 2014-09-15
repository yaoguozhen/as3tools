package com.zqvideo.view.panel
{
	import com.zqvideo.model.data.DataLoader;
	import com.zqvideo.model.data.DataPoolManager;
	import com.zqvideo.utils.SkinManager;
	import com.zqvideo.view.LayerManager;
	import com.zqvideo.view.component.EditorImageAndEffectBox;
	import com.zqvideo.view.core.PanelView;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	public class ShengChengPanel extends PanelView
	{
		private var inputBigMC:MovieClip;
		private var inputTxt:TextField;
		private var shengChengBtn:SimpleButton;
		private var closeBtn:SimpleButton;
		private var chengGongBigMC:MovieClip;
		private var countTxt:TextField;
		private var qianWangBtn:SimpleButton;
		private var loseMC:MovieClip;
		private var closeBtn1:SimpleButton;
		private var shengChengZhongMC:MovieClip;
		private var countTxt1:TextField;
		private var _editorImageAndEffectBox:EditorImageAndEffectBox;
		private var warnStr:String="请输入文件名！";
		private var timer:Timer;
		private var count:int=5;
		private var initCountStr:String="5";
		
		public function ShengChengPanel()
		{
			module=new MovieClip();
			layer=LayerManager.addToLayer(this,module);
			
			super();
		}
		
		override protected function addToStageShow():void{
			var alertMCCls:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info,"ShengChengInput");
			var alert:MovieClip=new alertMCCls();
			module.addChild(alert);
			alert.x=alert.width/2;
			alert.y=alert.height/2;
			inputBigMC=alert.getChildByName("InputBigMC") as MovieClip;
			inputTxt=inputBigMC.getChildByName("InputTxt") as TextField;
			shengChengBtn=inputBigMC.getChildByName("ShengChengBtn") as SimpleButton;
			closeBtn=inputBigMC.getChildByName("CloseBtn") as SimpleButton;
			
			chengGongBigMC=alert.getChildByName("ChengGongBigMC") as MovieClip;
			countTxt=chengGongBigMC.getChildByName("CountTxt") as TextField;
			qianWangBtn=chengGongBigMC.getChildByName("QianWangBtn") as SimpleButton;
			qianWangBtn.visible=false;
			
			loseMC=alert.getChildByName("LoseMC") as MovieClip;
			closeBtn1=loseMC.getChildByName("CloseBtn1") as SimpleButton;
			
			shengChengZhongMC=alert.getChildByName("ShengChengZhongMC") as MovieClip;
			countTxt1=shengChengZhongMC.getChildByName("CountTxt1") as TextField;
			
			timer=new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER,timerHandler);
		}
		
		public function get editorImageAndEffectBox():EditorImageAndEffectBox{
			return _editorImageAndEffectBox;
		}
		
		public function set editorImageAndEffectBox(value:EditorImageAndEffectBox):void{
			_editorImageAndEffectBox=value;
		}
		
		override public function initShowView():void{
			layer.visible=false;
		}
		
		override protected function addEvents():void{
			shengChengBtn.addEventListener(MouseEvent.CLICK,sureClickHandler);
			closeBtn.addEventListener(MouseEvent.CLICK,sureClickHandler);
			qianWangBtn.addEventListener(MouseEvent.CLICK,sureClickHandler);
			closeBtn1.addEventListener(MouseEvent.CLICK,sureClickHandler);
		}
		
		override protected function removeEvents():void{
			shengChengBtn.removeEventListener(MouseEvent.CLICK,sureClickHandler);
			closeBtn.removeEventListener(MouseEvent.CLICK,sureClickHandler);
			qianWangBtn.removeEventListener(MouseEvent.CLICK,sureClickHandler);
			closeBtn1.removeEventListener(MouseEvent.CLICK,sureClickHandler);
		}
		
		public function showElement(type:String):void{
			if(timer.running){
				timer.stop();
				count=5;
			}
			var mcType:String=type;
			switch(mcType){
				case "inputBigMC":
					inputBigMC.visible=true;
					chengGongBigMC.visible=false;
					loseMC.visible=false;
					shengChengZhongMC.visible=false;
					inputTxt.text=editorImageAndEffectBox.imageVec[0].data.@Name;
					break;
				case "chengGongBigMC":
					inputBigMC.visible=false;
					chengGongBigMC.visible=true;
					loseMC.visible=false;
					shengChengZhongMC.visible=false;
					countTxt.text=initCountStr;
					if(!timer.running){
						timer.start();
					}else{
						timer.stop();
						count=5;
						timer.start();
					}
					sendNotification("updateDataCommand",{dataType:"GENERATE_FENYE",Page:0});
					break;
				case "loseMC":
					inputBigMC.visible=false;
					chengGongBigMC.visible=false;
					loseMC.visible=true;
					shengChengZhongMC.visible=false;
					break;
				case "shengChengZhongMC":
					inputBigMC.visible=false;
					chengGongBigMC.visible=false;
					loseMC.visible=false;
					shengChengZhongMC.visible=true;
					countTxt1.text=initCountStr;
					if(!timer.running){
						timer.start();
					}else{
						timer.stop();
						count=5;
						timer.start();
					}
					break;
			
			}
		}
		
		private function timerHandler(e:TimerEvent):void{
			count--;
			if(chengGongBigMC.visible){
				countTxt.text=String(count);
			}
			if(shengChengZhongMC.visible){
				countTxt1.text=String(count);
			}
			
			if(count<=0){
				try
				{
					timer.stop();
					count=5;
					isShow=false;
				} 
				catch(error:Error) 
				{
					trace(error);
				}
			}
		}
		
		private function sureClickHandler(e:MouseEvent):void{
			var btnName:String=e.currentTarget.name;
			switch(btnName){
				case "ShengChengBtn":
					if(inputTxt.text.length<=0){
						inputTxt.text=warnStr;
					}else{
						showElement("shengChengZhongMC");
						sendNotification("creatInputDataCommand",{panelName:"EditorPanel",inputName:inputTxt.text,inputView:editorImageAndEffectBox});
					}
					break;
				case "CloseBtn":
					isShow=false;
					break;
				case "CloseBtn1":
					isShow=false;
					break;
				case "QianWangBtn": 
					//navigateToURL(new URLRequest(DataLoader.getInstance().qwGenerateUrl),"_self");
					break;
			}
		}
	}
}