package
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import flashx.textLayout.elements.BreakElement;
	
	public class YTip
	{
		private static var instance:YTip
		private var _stage:Stage;
		private var _skin:MovieClip;
		
		public static function getInstance():YTip{
			if (instance){
				return instance;
			}
			instance=new YTip()
			return instance;
		}
		private function refreshOnShow(type:String,otherParam:Object):void
		{
			_skin.tipBg.width=_skin.label.width+_skin.label.x*2;
			_skin.arrow.x=_skin.tipBg.width-_skin.arrow.width-10;
			
			switch(type)
			{
				case "1"://带箭头
					refreshFun1(otherParam)
					break;
				case "2"://不带箭头，跟随鼠标
					refreshFun2(otherParam)
					break;
				case "3"://不带箭头，定点显示
					refreshFun3(otherParam)
					break;
			}
		}
		//带箭头
		private function refreshFun1(param:Object):void
		{
			if(param)
			{
				_skin.arrow.visible=true;
				
				//var targetX:Number;
				if(param.point.x<_skin.tipBg.width)//如果超出了左边
				{
					trace(1)
					_skin.x=0;
					_skin.arrow.x=param.point.x-_skin.arrow.width/2;
				}
				else if(param.point.x+(_skin.tipBg.width-_skin.arrow.x-_skin.arrow.width/2)>_stage.stageWidth)//如果超出了右边
				{
					trace(2)
					_skin.x=_stage.stageWidth-_skin.tipBg.width;
					_skin.arrow.x=_skin.tipBg.width-(_stage.stageWidth-param.point.x)-_skin.arrow.width/2;
				}
				else
				{
					trace(3)
					_skin.x=param.point.x-(_skin.arrow.x+_skin.arrow.width/2);
				}
				_skin.y=param.point.y-_skin.height;
			}
			else
			{
				throw new Error("当type参数是 1 时，show 方法的 otherParam参数不能为null ");
			}
		}
		//不带箭头，跟随鼠标
		private function refreshFun2(param:Object):void
		{
			_skin.arrow.visible=false;
			var targetX:Number=_stage.mouseX;
			if(targetX+_skin.tipBg.width>_stage.stageWidth)
			{
				targetX=_stage.stageWidth-_skin.tipBg.width;
			}
			_skin.x=targetX;
			_skin.y=_stage.mouseY+20;
		}
		//不带箭头，定点显示
		private function refreshFun3(param:Object):void
		{
			if(param)
			{
				_skin.arrow.visible=false;
				var targetX:Number=param.point.x-_skin.tipBg.width/2;
				if(param.point.x+_skin.tipBg.width/2>_stage.stageWidth)
				{
					targetX=_stage.stageWidth-_skin.tipBg.width;
				}
				_skin.x=targetX;
				_skin.y=param.point.y-_skin.tipBg.height;
			}
			else
			{
				throw new Error("当type参数是 3 时，show 方法的 otherParam参数不能为null ");
			}
		}
		public function init(s:Stage,skin:MovieClip):void
		{
			_stage=s;
			_skin=skin;
			_skin.mouseChildren=false;
			_skin.mouseEnabled=false;
			_skin.label.autoSize="left";
			_skin.label.wordWrap=false;
			_skin.label.multiline=false
		}
		public function hide():void
		{
			try
			{
				_stage.removeChild(_skin);
			}
			catch(err:Error)
			{
				
			}
		}
		/**
		 * 
		 * @param word tip文字
		 * @param type 1 带箭头，无需otherParam参数；2 跟随鼠标，无需otherParam参数；3 无箭头的定点显示，otherParam参数为{point:Point} 
		 * @param otherParam
		 * 
		 */		
		public function show(word:String,type:String,otherParam:Object=null):void
		{
			var showArrow=false;
			_skin.label.text=word;
			//设置各元件位置
			refreshOnShow(type,otherParam);
			_stage.addChild(_skin);
		}
	}
}