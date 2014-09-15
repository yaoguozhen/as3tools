package com.zqvideo.view.component
{
	import com.greensock.TweenMax;
	import com.zqvideo.model.data.DataPoolManager;
	import com.zqvideo.utils.SkinManager;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class EffectArrangeBox extends Sprite
	{
		private var _data:XML;
		private var _xmlNodeName:String="";
		private var arrangeImageNum:int=7;
		private var upBtn:SimpleButton;
		private var downBtn:SimpleButton;
		private var container:Sprite;
		private var maskSp:Sprite;
		private var imageMCCls:Class;
		private var imageVec:Vector.<EffectImage>=new Vector.<EffectImage>();
		private var _effTransitionVec:Vector.<EffTransitionElement>=new Vector.<EffTransitionElement>();
		private var tween:TweenMax;
		
		private var maskWidth:Number=510;
		private var maskHeight:Number=265;
		
		public function EffectArrangeBox()
		{
			super();
			container=new Sprite();
			this.addChild(container);
			/*maskSp=new Sprite();
			this.addChild(maskSp);
			maskSp.graphics.clear();
			maskSp.graphics.beginFill(0x000000,1);
			maskSp.graphics.drawRect(0,0,maskWidth,maskHeight);
			maskSp.graphics.endFill();
			maskSp.x=container.x;
			maskSp.y=container.y;
			container.mask=maskSp;*/
			
			var upBtnCls:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info,"ZuoBtn");
			upBtn=new upBtnCls();
			//this.addChild(upBtn);
			upBtn.rotation=90;
			upBtn.name="upBtn";
			
			downBtn=new upBtnCls();
			//this.addChild(downBtn);
			downBtn.rotation=-90;
			downBtn.name="downBtn";
			
			upBtn.visible=downBtn.visible=false;
			
			imageMCCls=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info,"EffImageContainer");
			
			upBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			downBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			
		}
		
		public function get xmlNodeName():String{
			return _xmlNodeName;
		}
		
		public function set xmlNodeName(value:String):void{
			_xmlNodeName=value;
		}
		
		public function get data():XML{
			return _data;
		}
		
		public function set data(value:XML):void{
			_data=value;
			
			if(!xmlNodeName){
				return;
			}
			
			while(container.numChildren>0){
				container.removeChildAt(0);
			}
			
			var arrangeIndex:int=0;
			var yUpdateNum:Number=0;
			var xDistance:Number=10;
			var yDistance:Number=25;
			
			var xmlList:XMLList=data.child(xmlNodeName);
			
			var totalXML:XML=<data></data>;
			for(var j:int=1;j<xmlList.children().length();j++){
				var xml:XML=xmlList.children()[j];
				totalXML.appendChild(xml);
			}
			
			for (var i:int=0; i < totalXML.children().length(); i++)
			{
				var imageMC:MovieClip=new imageMCCls();
				var img:EffectImage=new EffectImage();
				img.ui=imageMC;
				//trace(">>>"+xmlList.children()[i].toXMLString());
				img.data=totalXML.children()[i];
				img.sordID=i;
				img.effTransitionVec=effTransitionVec;
				img.x=arrangeIndex * (img.width + xDistance);
				img.y=yUpdateNum;
				arrangeIndex++;
				if ((i + 1) % arrangeImageNum == 0)
				{
					arrangeIndex=0;
					yUpdateNum+=(img.height + yDistance);
				}
				container.addChild(img);
				imageVec.push(img);
				
				img.addEventListener("eff_complete",onNextEff);
				//				trace(img.sordID,pageIndex);
				if(i==0){
					img.startLoad();
				}
			}
			
			//DataPoolManager.getInstance().moRenEffectData=imageVec[0].data;
			
			/*if(container.height<maskHeight){
				upBtn.visible=downBtn.visible=false;
			}else{
				upBtn.visible=downBtn.visible=true;
				upBtn.x=container.x+container.width+upBtn.width+22;
				upBtn.y=(265-upBtn.height)/2-upBtn.height;
				
				downBtn.x=upBtn.x-upBtn.width;
				downBtn.y=upBtn.y+upBtn.height*2+25;
				
				restContainerMask();
			}*/	
		}
		protected function onNextEff(event:Event):void
		{
			// TODO Auto-generated method stub
			var img:EffectImage=event.currentTarget as EffectImage;
			img.removeEventListener("eff_complete",onNextEff);
			var sid:int=img.sordID+1;
			var effCount:uint=data.effects[0].effect.length();
			if(sid< effCount-1)
			{
				img=imageVec[sid];
				img.startLoad();
			}
		}
		public function get effTransitionVec():Vector.<EffTransitionElement>{
			return _effTransitionVec;
		}
		
		public function set effTransitionVec(value:Vector.<EffTransitionElement>):void{
			_effTransitionVec=value;
		}
		
		private function restContainerMask():void{
			maskSp.x=container.x;
			maskSp.y=container.y;
			container.mask=maskSp;
		}
		
		private function btnClickHandler(e:MouseEvent):void{
			var btnName:String=e.currentTarget.name;
			switch(btnName){
				case "upBtn":
					if(container.y>=0){
						return;
					}else{
						tween=TweenMax.to(container,0.5,{y:container.y+93,onComplete:tweenComplete});
					}
					break;
				case "downBtn":
					if(container.y<=maskSp.height-container.height){
						return;
					}else{
						tween=TweenMax.to(container,0.5,{y:container.y-93,onComplete:tweenComplete});
					}
					break;
			}
		}
		
		private function tweenComplete():void{
			if(tween){
				tween.pause();
				tween=null;
			}
		}
	}
}