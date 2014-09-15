package com.zqvideo.view.component
{
	import com.zqvideo.model.data.DataEvent;
	import com.zqvideo.model.data.DataPoolManager;
	import com.zqvideo.utils.SkinManager;
	import com.zqvideo.view.core.ComponentView;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mvc.Command;
	import mvc.ICommand;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class BiaoDianBox extends ComponentView
	{
		private var _totalNum:int;
		private var biaoDianMCCls:Class;
		private var biaoDianVec:Vector.<MovieClip>=new Vector.<MovieClip>();
		private var currentBiaoDian:MovieClip;
		private var currentSelectID:int=0;
		private var direction:String="";
		private var dataObj:Object={};
		
		public function BiaoDianBox()
		{
			super();
			this.addChild(rootContainer);
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get totalNum():int{
			return _totalNum;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set totalNum(value:int):void{
			_totalNum=value;
			biaoDianMCCls=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info, "BiaoDian");
			
			for(var i:int=0;i<value;i++){
				var biaoDian:MovieClip=new biaoDianMCCls();
				rootContainer.addChild(biaoDian);
				biaoDian.name=String(i);
				biaoDian.x=i*(biaoDian.width+15);
				biaoDianVec.push(biaoDian);
				biaoDian.buttonMode=true;
				biaoDian.addEventListener(MouseEvent.CLICK,biaoDianClickHandler);
			}
			
			if(biaoDianVec.length>0){
				currentBiaoDian=biaoDianVec[0];
				currentBiaoDian.gotoAndStop(2);
				currentSelectID=int(currentBiaoDian.name);
				currentBiaoDian.mouseChildren=currentBiaoDian.mouseEnabled=false;
			}
		}
		
		private function biaoDianClickHandler(e:MouseEvent):void{
			if(currentBiaoDian==null){
				return;
			}
			var selectID:int=int(MovieClip(e.currentTarget).name);
			if(selectID==currentSelectID){
				return;
			}else if(selectID>currentSelectID){
				direction="right";
			}else if(selectID<currentSelectID){
				direction="left";
			}
			
			dataObj.pageIndex=selectID+1;
			dataObj.direction=direction;
			this.dispatchEvent(new DataEvent(DataEvent.SELECT_POINT,dataObj));
			updateBiaoDianShow(selectID);
		}
		
		/**
		 * 
		 * @param $index
		 */
		public function updateBiaoDianShow($index:int,$direction:String=""):void{
			//trace($index+"******************************>");
			if(currentBiaoDian){
				currentBiaoDian.gotoAndStop(1);
				currentBiaoDian.mouseChildren=currentBiaoDian.mouseEnabled=true;
				currentBiaoDian=null;
			}
			
			if($index<totalNum){
				currentBiaoDian=biaoDianVec[$index];
				currentBiaoDian.gotoAndStop(2);
				currentBiaoDian.mouseChildren=currentBiaoDian.mouseEnabled=false;
				currentSelectID=int(currentBiaoDian.name);
			}
			direction=$direction;
		}
	}
}