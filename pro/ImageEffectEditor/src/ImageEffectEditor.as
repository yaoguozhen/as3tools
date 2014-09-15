package
{
	import com.zqvideo.utils.YufengMath;
	import com.zqvideo.view.EditorFacade;
	import com.zqvideo.view.panel.SoundListPanel;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.Security;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	
	[SWF(width="980", height="548", frameRate="25", backgroundColor="0x000000")]
	public class ImageEffectEditor extends MovieClip
	{
		private var editorFacade:EditorFacade;
		private var errorShow:Sprite;
		
		public function ImageEffectEditor()
		{
			Security.allowDomain("*");
			this.addEventListener(Event.ENTER_FRAME,onAddToStage);
			showRenderTime();
		}
		
		/**
		 * 
		 * @param event
		 */
		protected function onAddToStage(event:Event):void
		{
			if(stage&&stage.stageWidth>0&&stage.stageHeight>0){
				this.removeEventListener(Event.ENTER_FRAME,onAddToStage);
				initApp();
			}
		}
		
		private function showRenderTime():void{
			var myContextMenu:ContextMenu = new ContextMenu();
			myContextMenu.hideBuiltInItems();
			var tm:String="2014‎年9月15日 15:30";
			var item:ContextMenuItem=new ContextMenuItem("【图片转视频】 更新时间:"+tm);
			myContextMenu.customItems.push(item);
			this.contextMenu=myContextMenu;		
		}
		
		private function initApp():void
		{
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align=StageAlign.TOP_LEFT;
			
			errorShow=new ErrorPanelMC();
			this.addChild(errorShow);
			errorShow.x=(stage.stageWidth-errorShow.width)/2;
			errorShow.y=(stage.stageHeight-errorShow.height)/2;
			errorShow.visible=false;
			
			editorFacade=EditorFacade.getInstance();
			editorFacade.init(this);
			
			stage.addEventListener(Event.RESIZE,updateSize);
			updateSize();
		}
		
		private function updateSize(e:Event=null):void{
			var stW:Number=stage.stageWidth;
			var stH:Number=stage.stageHeight;
			//editorFacade.updateSize(0,0,stW,stH);
			
			if(errorShow){
				var sc:Number=YufengMath.getMinScale(new Point(stW, stH), new Point(980, 548));
				errorShow.scaleX=errorShow.scaleY=sc;
				errorShow.x=(stW-errorShow.width)/2;
				errorShow.y=(stH-errorShow.height)/2;
			}
		}
		
		public function showError(error:String):void{
			errorShow["err_txt"].text=error;
		}
		
		public function removeErrorShow():void{
			this.removeChild(errorShow);
			errorShow=null;
		}
	}
}