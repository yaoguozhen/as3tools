package zhen.guo.yao.fps{
  import flash.display.Sprite;
  import flash.display.Stage;
  import flash.events.Event;
  import flash.system.System;
  import flash.text.TextField;
  import flash.text.TextFieldAutoSize;
  import flash.text.TextFormat;
  import flash.utils.getTimer;
  
  public class FPS extends Sprite{
    
    private static var stageInstance:Stage;
    
    private var lastTime:uint = getTimer();
    private var frames:Number = 0;
    private var monitorKitTextField:TextField;
    private var textColor:uint=0xffffff;
	private var checkCircle:uint;//检测周期，单位毫秒
	private var bg:Sprite;

    public function FPS(_checkCircle:uint) 
	{
      checkCircle = _checkCircle;
      addEventListener(Event.ADDED_TO_STAGE, initMonitorHandler);
    }
	private function creatBG()
	{
		bg=new Sprite();
		bg.graphics.beginFill(0x000000);
		bg.graphics.drawRect(0,0,monitorKitTextField.width,monitorKitTextField.height);
	}
    private function creatText():void
	{
		monitorKitTextField = new TextField();
      	monitorKitTextField.selectable = false;
     	monitorKitTextField.textColor = textColor;
		monitorKitTextField.backgroundColor=0x0000ff;
      	monitorKitTextField.autoSize = TextFieldAutoSize.LEFT;
      	var format:TextFormat = new TextFormat();
      	format.size = 15;
     	monitorKitTextField.defaultTextFormat = format;
      	monitorKitTextField.text = "[ Loading... ]";
	}
    private function initMonitorHandler(event:Event):void 
	{
      // Unregister the event handler
      removeEventListener(Event.ADDED_TO_STAGE, initMonitorHandler);
	  
	  creatText();
	  creatBG();
	  addChild(bg);
	  addChild(monitorKitTextField);
	  
      stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }
    
    private function enterFrameHandler(evt:Event):void 
	{
      frames++;
      var currentTime:uint = getTimer();
      var deltaTime:uint = currentTime - lastTime;
	  if(deltaTime>=checkCircle)
	  {
      	  var fps:Number = frames / deltaTime * 1000;
     	  monitorKitTextField.text = "帧频: " + fps.toFixed(1);
     	  monitorKitTextField.appendText("\n内存: " + Number(System.totalMemory/1024/1024).toFixed(3)+"(M)");
      	  frames = 0;
      	  lastTime = currentTime;
      	  
		  bg.width=monitorKitTextField.width;
		  bg.height=monitorKitTextField.height;
	  }
    }
  }
}