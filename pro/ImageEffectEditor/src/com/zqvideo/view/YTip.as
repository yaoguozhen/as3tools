package  com.zqvideo.view
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import flashx.textLayout.elements.BreakElement;
	/**
	 *显示tip 
	 * @author yaoguozhen
	 * 
	 */	
	public class YTip
	{
		private static var instance:YTip
		private var _stage:Stage;
		private var _skin:MovieClip;
		private var _timer:Timer;//tip自动消失定时器
		
		public static function getInstance():YTip{
			if (instance){
				return instance;
			}
			instance=new YTip()
			return instance;
		}
		/**
		 *根据tip类型设置各元件位置 
		 * @param type tip类型
		 * @param otherParam
		 * 
		 */		
		private function refreshOnShow(type:String,otherParam:Object):void
		{
			_skin.tipBg.width=_skin.label.width+_skin.label.x*2;
			//设置箭头的初始位置
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
				
				if(param.point.x<_skin.tipBg.width)//如果箭头指向的点的横坐标小于tip背景的长度，则tip的横坐标始终为0，箭头指向该点
				{
					_skin.x=0;
					_skin.arrow.x=param.point.x-_skin.arrow.width/2;
				}
				else if(param.point.x+(_skin.tipBg.width-_skin.arrow.x-_skin.arrow.width/2)>_stage.stageWidth)//如果tip将要出现位置的横坐标超出了stage的右边，则tip始终和stage右对齐
				{
					_skin.x=_stage.stageWidth-_skin.tipBg.width;
					_skin.arrow.x=_skin.tipBg.width-(_stage.stageWidth-param.point.x)-_skin.arrow.width/2;
				}
				else
				{
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
		private function timerEventHandler(event:TimerEvent):void
		{
			hide();
		}
		public function init(s:Stage,skin:MovieClip):void
		{
			_stage=s;
			_skin=skin;
			_skin.mouseChildren=false;
			_skin.mouseEnabled=false;
			_skin.label.autoSize="left";
			_skin.label.wordWrap=false;
			_skin.label.multiline=false;
			
			_timer=new Timer(2000,1);
			_timer.addEventListener(TimerEvent.TIMER,timerEventHandler);
		}
		public function hide():void
		{
			_timer.reset();
			try
			{
				_stage.removeChild(_skin);
			}
			catch(err:Error)
			{
				
			}
		}
		/**
		 * 显示tip
		 * @param word tip文字
		 * @param type 1 带箭头，无需otherParam参数；2 跟随鼠标，无需otherParam参数；3 无箭头的定点显示，otherParam参数为{point:Point} 
		 * @param otherParam 其他参数
		 * 
		 */		
		public function show(word:String,type:String,otherParam:Object=null,autoHide:Boolean=false):void
		{
			_skin.label.text=word;
			//设置各元件位置
			refreshOnShow(type,otherParam);
			_stage.addChild(_skin);
			
			_timer.reset();
			//如果tip自动消失，则此时启动定时器
			if(autoHide)
			{
				_timer.start();
			}
		}
	}
}