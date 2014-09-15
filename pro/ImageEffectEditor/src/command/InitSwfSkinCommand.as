package command
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import com.zqvideo.event.LoadEvent;
	import com.zqvideo.loader.XMLLoader;
	import com.zqvideo.model.data.DataLoader;
	import com.zqvideo.model.data.DataPoolManager;
	import com.zqvideo.model.data.LanguageParser;
	import com.zqvideo.utils.SkinManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.system.System;
	
	import mvc.Command;
	import mvc.ICommand;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class InitSwfSkinCommand extends Command implements ICommand
	{
		private var appMain:ImageEffectEditor;
		
		public function InitSwfSkinCommand()
		{
			super();
		}
		
		/**
		 * 
		 * @param type
		 * @param obj
		 */
		public function execute(type:String, obj:Object=null):void
		{
			if(obj){
				appMain=obj.app;
				LanguageParser.init();
				
				if(appMain.stage.loaderInfo.parameters.host){
					Root.host=appMain.stage.loaderInfo.parameters.host;
					trace("DataPort>>>Root.host:"+Root.host);
				}
				
				if(appMain.stage.loaderInfo.parameters.assetsURL){
					Root.assetsURL=appMain.stage.loaderInfo.parameters.assetsURL;
				}
				
				if(ExternalInterface.available){
					var config:Object=ExternalInterface.call("config");
					if(!config){
						return;
					}
					if(Root.host&&config.getGenerates){
						Root.getGenerates=Root.host+config.getGenerates;
						DataLoader.getInstance().getGeneratesUrl=Root.getGenerates;
						trace("DataPort>>>Root.getGenerates:"+Root.getGenerates);
					}
					if(Root.host&&config.GetList){ 
						Root.getImagesApi=Root.host+config.GetList;
						DataLoader.getInstance().pageImageUrl=Root.getImagesApi;
						trace("DataPort>>>Root.getImagesApi:"+Root.getImagesApi);
					}
					if(Root.host&&config.Build){
						Root.saveImagesApi=Root.host+config.Build;
						DataLoader.getInstance().sendImageUrl=Root.saveImagesApi;
						trace("DataPort>>>Root.saveImagesApi:"+Root.saveImagesApi);
					}
					if(Root.host&&config.qwGenerate){
						Root.qwGenerate=config.qwGenerate;
						DataLoader.getInstance().qwGenerateUrl=config.qwGenerate;
						trace("DataPort>>>Root.qwGenerate:"+Root.qwGenerate);
					}
					if(Root.host&&config.queryPercentGenerate){
						Root.queryPercentGenerate=Root.host+config.queryPercentGenerate;
					}
					if(Root.host&&config.removeG){
						Root.removeG=Root.host+config.removeG;
					}
					if(Root.host&&config.toUplaod){
						Root.toUplaod=Root.host+config.toUplaod;
					}
				}
				
				configXMLLoader=new XMLLoader();
				configXMLLoader.addEventListener(LoadEvent.XML_LOAD_COMPLETE,xmlLoadCompleteHandler);
				configXMLLoader.addEventListener(LoadEvent.XML_LOAD_ERROR,xmlLoadErrorHandler);
				configXMLLoader.load(Root.assetsURL+Root.configUrl);
				
			}
		}
		
		private function xmlLoadCompleteHandler(e:LoadEvent):void{
			//appMain.showError(Root.LANGUAGE_DATA.configDataGetSucceed[0]);
			DataPoolManager.getInstance().configData=configXMLLoader.data;
			Root.soundHttpHost=DataPoolManager.getInstance().configData.sounds.@httpUrl;
			Root.soundTranscodeHost=DataPoolManager.getInstance().configData.sounds.@transcodeUrl;
			
			//trace("====>"+Root.soundHttpHost);
			//trace("====>"+Root.soundTranscodeHost);
			
			//trace(DataPoolManager.getInstance().configData.toXMLString());
			
			if(DataPoolManager.getInstance().configData.skins.(hasOwnProperty("skin"))){
				
			}else{
				appMain.showError(Root.LANGUAGE_DATA.configDataWarn[0]);
				return;
			}
			
			assetsLoader=new BulkLoader("assetInit");
			assetsLoader.addEventListener(BulkProgressEvent.COMPLETE, initAssetsCompleted);
			assetsLoader.addEventListener(BulkProgressEvent.PROGRESS, initAssetsProgressHandler);
			
			///加载皮肤
			var skinList:XMLList=DataPoolManager.getInstance().configData.skins.skin;
			var index:uint=0;
			var length:Number=skinList.length();
			var url:String=null;
			var id:String=null;
			while (index < length)
			{
				var xml:XML=skinList[index];
				//url=xml.@url + "?" + getTimer().toString();
				url=Root.assetsURL+xml.@url;
				id=xml.@id;
				assetsLoader.add(url, {id: id});
				assetsLoader.get(url).addEventListener(Event.COMPLETE, skinsLoadCompleted);
				assetsLoader.get(url).addEventListener(IOErrorEvent.IO_ERROR,skinLoadError);
				index++;
			}
			assetsLoader.start();
		}
		
		private function skinsLoadCompleted(e:Event):void{
			var item:LoadingItem=e.target as LoadingItem;
			var mc:MovieClip=assetsLoader.getMovieClip(item.id);
			SkinManager.addSwfSkin(mc.loaderInfo, item.id);
		}
		
		private function skinLoadError(e:IOErrorEvent):void{
			appMain.showError(Root.LANGUAGE_DATA.assetsGetLose[0]);
		}
		
		private function initAssetsProgressHandler(e:BulkProgressEvent):void{
			//trace(e.weightPercent);
			var perStr:String=String(Math.round(e.weightPercent*100))+"%";
		}
		
		private function initAssetsCompleted(e:BulkProgressEvent):void{
			//appMain.showError(Root.LANGUAGE_DATA.assetsGetSucceed[0]);
			appMain.removeErrorShow();
			DataPoolManager.getInstance().info=SkinManager.getSwfSkin("skin");
			
			sendNotification("initFlashvarsCommand", {app:appMain});
		}
		
		
		private function xmlLoadErrorHandler(e:LoadEvent):void{
			appMain.showError(Root.LANGUAGE_DATA.configDataGetLose[0]);
		}
	}
}