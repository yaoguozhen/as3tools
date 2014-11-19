package zhen.guo.yao.component.ytip
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
    public class YTip extends Sprite
    {
        private const BG_COLOR:uint = 0x999999;
		private const LABEL_COLOR:uint = 0xFFFFFF;
		private const DIS:uint = 3;
		
        private var _label:TextField;
        private var _bg:Sprite;
		private var _stage:Stage;
		
		private var _showdelayTimer:Timer;
		
        public function YTip()
        {
			_bg=creatBg();
			
			_label = creatLabel();
			_label.x = DIS;
			_label.y = DIS;
		    
			addChild(_bg);
			addChild(_label);
			
			_showdelayTimer = new Timer(300,1);
			_showdelayTimer.addEventListener(TimerEvent.TIMER, showdelayTimerHandler);
        }
        private function showdelayTimerHandler(evn:TimerEvent):void
		{
			visible = true;
		}
        private function creatBg() : void
        {
            this.graphics.clear();
            this.graphics.beginFill(BG_COLOR);
            this.graphics.drawRect(0, 0, 10,10);
            this.graphics.endFill();
            return;
        }
        private function creatLabel():TextField
        {
            var tf:TextFormat = new TextFormat();
            tf.size = 12;
			tf.color = LABEL_COLOR;
			
			var l:TextField = new TextField();
			l.autoSize = TextFieldAutoSize.LEFT;
			l.defaultTextFormat = tf;
			
			return l;
        }
        public function show(text:String) : void
        {
            _label.text = text;
            _bg.width = _label.width + DIS * 2;
		    _bg.height = _label.height + DIS * 2;
			
			_showdelayTimer.reset()
			_showdelayTimer.start();
        }
		public function hide() : void
        {
           visible = false;
		   _showdelayTimer.reset()
        }

    }
}
