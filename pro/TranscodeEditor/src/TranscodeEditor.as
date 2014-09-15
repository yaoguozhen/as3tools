package
{
	import flash.display.Sprite; 
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import morn.core.components.Styles;
	import morn.core.handlers.Handler;
	
	import transcode.view.MainView;
	
	[SWF(width="1002", height="613", frameRate="25", backgroundColor="0x000000")]
	public class TranscodeEditor extends Sprite
	{
		private var mainView:MainView;
		
		public function TranscodeEditor()
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			addEventListener(Event.ENTER_FRAME, onAddedToStage);
			showRenderTime();
		}
		
		private function onAddedToStage(e:Event):void{
			if(!stage){
				return;
			}
			
			removeEventListener(Event.ENTER_FRAME, onAddedToStage);
			
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align=StageAlign.TOP_LEFT;
			
			
			App.init(this);
			Styles.fontName="Microsoft Yahei";
			
			if(ExternalInterface.available){
			
				initConfig();
			}
			
		}
		
		private function showRenderTime():void{
			var myContextMenu:ContextMenu = new ContextMenu();
			myContextMenu.hideBuiltInItems();
			var tm:String="2014‎年8月26日 16:43";
			var item:ContextMenuItem=new ContextMenuItem("更新时间:"+tm);
			myContextMenu.customItems.push(item);
			this.contextMenu=myContextMenu;		
		}
		
		private function initConfig():void{
			var config:Object = ExternalInterface.call("getConfig");
			if(!config){
				return;
			}
			var params:Object = config;
			
			if(params.host){
				EditorConfig.host=params.host;
				App.log.echo(EditorConfig.host);
			}
			if(params.assetPath){
				EditorConfig.assetPath=params.assetPath;
				App.log.echo(EditorConfig.assetPath);
			}
			if(params.upload){
				EditorConfig.upload=params.upload;
				App.log.echo(EditorConfig.upload);
			}
			if(params.getExistFiles){
				EditorConfig.getExistFiles=params.getExistFiles;
				App.log.echo(EditorConfig.getExistFiles);
			}
			if(params.getMediaInfo){
				EditorConfig.getMediaInfo=params.getMediaInfo;
				App.log.echo(EditorConfig.getMediaInfo);
			}
			if(params.callApi){
				EditorConfig.callApi=params.callApi;
				App.log.echo(EditorConfig.callApi);
			}
			if(params.query){
				EditorConfig.query=params.query;
				App.log.echo(EditorConfig.query);
			}
			if(params.fileCreate){
				EditorConfig.fileCreate=params.fileCreate;
				App.log.echo(EditorConfig.fileCreate);
			}
			if(params.clipCreate){
				EditorConfig.clipCreate=params.clipCreate;
				App.log.echo(EditorConfig.clipCreate);
			}
			if(params.taskProgress){
				EditorConfig.taskProgress=params.taskProgress;
				App.log.echo(EditorConfig.taskProgress);
			}
			if(params.playVideo){
				EditorConfig.playVideo=params.playVideo;
				App.log.echo(EditorConfig.playVideo);
			}
			if(params.downLoadVideo){
				EditorConfig.downLoadVideo=params.downLoadVideo;
				App.log.echo(EditorConfig.downLoadVideo);
			}
			if(params.fileUrl){
				EditorConfig.fileUrl=params.fileUrl;
				App.log.echo(EditorConfig.fileUrl);
			}
			if(params.destUrl){
				EditorConfig.destUrl=params.destUrl;
				App.log.echo(EditorConfig.destUrl);
			}
			if(params.readUrl){
				EditorConfig.readUrl=params.readUrl;
				App.log.echo(EditorConfig.readUrl);
			}
			
			if(EditorConfig.assetPath.length>=0){
				var loadUrlArr:Array=[];
				var assetsArr:Array=["assets/comp.swf?random="+Math.random(),"assets/ball.swf?random="+Math.random(),"assets/flashcheckxx.swf?random="+Math.random()];
				for(var i:int=0;i<assetsArr.length;i++){
					loadUrlArr.push(EditorConfig.getAssetPath(assetsArr[i]));
				}
				
				App.loader.loadAssets(loadUrlArr,new Handler(loadComHandler));
			}
		}
		
		private function loadProgress(value:Number):void {
			//加载进度
			//trace("loaded", value);
		}
		
		private function loadComHandler():void{
			mainView=new MainView();
			addChild(mainView);
		}
	}
}