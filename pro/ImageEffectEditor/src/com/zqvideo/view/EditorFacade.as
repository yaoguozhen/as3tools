package com.zqvideo.view
{
	import command.CreatInputDataCommand;
	import command.ImgAndEffSelectCommand;
	import command.InitFlashvarsCommand;
	import command.InitSwfSkinCommand;
	import command.InitViewCommand;
	import command.PanelHideCommand;
	import command.PanelShowCommand;
	import command.SelectedEffectCommand;
	import command.SelectedImageCommand;
	import command.SoundListChangeCommand;
	import command.TiaoHuanSelectedImageCommand;
	import command.UpdateDataCommand;
	import command.UpdateEffectPlayCommand;
	import command.UpdatePanelCommand;
	import command.controlSoundCommand;
	import command.deletPanelBtnClickCommand;
	import command.publishBtnClickCommand;
	
	import mvc.Command;
	import mvc.Facade;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class EditorFacade extends Facade
	{
		/**
		 * 
		 * @return 
		 */
		public static function getInstance():EditorFacade{
			if (Command.editorFacade == null){
				Command.editorFacade = new EditorFacade();
			}
			return Command.editorFacade;
		}
		
		/**
		 * 
		 * @param appMain
		 */
		public function init(appMain:ImageEffectEditor):void{
			registerCommand("initSwfSkinCommand",InitSwfSkinCommand); 
			registerCommand("initFlashvarsCommand",InitFlashvarsCommand);
			registerCommand("initViewCommand",InitViewCommand);
			registerCommand("panelShowCommand",PanelShowCommand);
			registerCommand("panelHideCommand",PanelHideCommand);
			registerCommand("updateDataCommand",UpdateDataCommand);
			registerCommand("updatePanelCommand",UpdatePanelCommand);
			registerCommand("selectedImageCommand",SelectedImageCommand);
			registerCommand("selectedEffectCommand",SelectedEffectCommand);
			registerCommand("tiaoHuanSelectedImageCommand",TiaoHuanSelectedImageCommand);
			registerCommand("updateEffectPlayCommand",UpdateEffectPlayCommand);
			registerCommand("creatInputDataCommand",CreatInputDataCommand);
			registerCommand("soundListChangeCommand",SoundListChangeCommand);
			registerCommand("controlSoundCommand",controlSoundCommand);
			registerCommand("deletPanelBtnClickCommand",deletPanelBtnClickCommand);
			registerCommand("imgAndEffSelectCommand",ImgAndEffSelectCommand);
			registerCommand("publishBtnClickCommand",publishBtnClickCommand);
			sendNotification("initSwfSkinCommand",{app:appMain});
			
			
		}
		
		/**
		 * 
		 * @param xNum
		 * @param yNum
		 * @param widthNum
		 * @param heightNum
		 */
		public function updateSize(xNum:Number=0, yNum:Number=0, widthNum:Number=0, heightNum:Number=0):void{
			Root.editorContainer.x = xNum;
			Root.editorContainer.y = yNum;
			//updateControllerSize(widthNum, heightNum);
		}
	}
}