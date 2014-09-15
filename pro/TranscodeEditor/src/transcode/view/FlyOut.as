package transcode.view
{
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class FlyOut extends EventDispatcher
	{
		private var leftMask:Sprite;
		private var rightMask:Sprite;
		private var leftObj:DisplayObject;
		private var rightObj:DisplayObject;
		
		private const LEFT_INIT_X:Number=320;
		private const LEFT_TARGET_X:Number=38;
		private const RIGHT_INIT_X:Number=318;
		private const RIGHT_TARGET_X:Number=602;
		private const MASK_Y:Number=151.5;
		
		public function FlyOut(target:IEventDispatcher=null)
		{
			super(target);
			
			leftMask=creatMask();
			leftMask.y=MASK_Y
			
			rightMask=creatMask();
			rightMask.y=MASK_Y;
			rightMask.x=EditorConfig.APP_WIDTH/2;
			
			App.stage.addChild(leftMask);
			App.stage.addChild(rightMask);
		}
		private function creatMask():Sprite
		{
			var sp:Sprite=new Sprite();
			sp.graphics.beginFill(0x0000ff);
			sp.graphics.drawRect(0,0,EditorConfig.APP_WIDTH/2,300);
			return sp;
		}
		public function setObj(leftObject:DisplayObject,rightObject:DisplayObject,ball:DisplayObject):void
		{
			leftObj=leftObject;
			rightObj=rightObject;
			
			leftObj.x=LEFT_INIT_X;
			rightObj.x=RIGHT_INIT_X;
			
			leftObj.mask=leftMask;
			rightObj.mask=rightMask;
		}
		public function move():void
		{
			TweenMax.to(leftObj,1,{x:LEFT_TARGET_X});
			TweenMax.to(rightObj,1,{x:RIGHT_TARGET_X});
		}
	}
}