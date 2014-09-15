package com.zqvideo.view
{

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;


	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class LayerManager extends EventDispatcher
	{
		public static var loadingPanel:MovieClip;
		public static var alertPanel:MovieClip;
		public static var shengChengPanel:MovieClip;
		public static var homePagePanel:MovieClip;
		public static var editorPanel:MovieClip;
		public static var deleteAlertPanel:MovieClip;

		public static function init():void
		{
			loadingPanel=new MovieClip();
			alertPanel=new MovieClip();
			shengChengPanel=new MovieClip();
			//homePagePanel=new MovieClip();
			editorPanel=new MovieClip();
			deleteAlertPanel=new MovieClip();

			//Root.editorContainer.addChild(homePagePanel);
			Root.editorContainer.addChild(editorPanel);
			Root.editorContainer.addChild(loadingPanel);
			Root.editorContainer.addChild(shengChengPanel);
			Root.editorContainer.addChild(alertPanel);
			Root.editorContainer.addChild(deleteAlertPanel);
		}

		/**
		 * 
		 * @param classObj
		 * @param displayObj
		 * @return 
		 */
		public static function addToLayer(classObj:Object, displayObj:DisplayObject):MovieClip
		{
			var panel:MovieClip;
			var className:String=getQualifiedClassName(classObj).split("::")[1];
			switch (className)
			{
				case "LoadingPanel":
					panel=loadingPanel;
					break;
				case "AlertPanel":
					panel=alertPanel;
					break;
				case "ShengChengPanel":
					panel=shengChengPanel;
					break;
				/*case "HomePagePanel":
					panel=homePagePanel;
					break;*/
				case "EditorPanel":
					panel=editorPanel;
					break;
				case "DeleteAlertPanel":
					panel=deleteAlertPanel;
					break;

			}
			panel.addChild(displayObj);
			return (panel);
		}

	}
}
