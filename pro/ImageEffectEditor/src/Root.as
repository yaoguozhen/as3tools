package
{
	import com.zqvideo.utils.DragManager;
	
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class Root
	{
		
		public static var appMain:ImageEffectEditor;
		
		public static var host:String=""; // http://172.16.3.133:8080/povs2.1/material/
		
		public static var assetsURL:String=""; // http://172.16.3.133:8080/povs2.1/imgflash/
		
		public static var getGenerates:String="";
		
		public static var getImagesApi:String="";
		
		public static var saveImagesApi:String="";
		
		public static var qwGenerate:String="";
		
		public static var toUplaod:String="toUploadImg/";
		
		public static var queryPercentGenerate:String="";
		
		public static var removeG:String="";
		
		public static var soundHttpHost:String="";
		
		public static var soundTranscodeHost:String="";
		
		public static var configUrl:String="config.xml";
		
		public static const HOMEPAGE_IMAGE_SHOWNUM:int=50;
		
		public static const EDITORPAGE_IMAGE_SHOWNUM:int=24;
		
		public static var homeImageTotalPage:int=0;
		
		public static var editorImageTotalPage:int=0;
		
		public static var soundTranscodeURL:String="";
		
		public static var soundPlayURL:String="";
		
		public static var useSound:Boolean=false;
		
		public static var previewPlayerState:String="pause";
		
		public static const SELECT_IMAGE:String="SelectImage";
		
		public static const SELECT_EFFECT:String="SelectEffect";
		
		public static var isImageDiaoHuan:Boolean=false; //是否调换图片顺序
		
		public static var stage:Stage;
		
		public static var loaderInfo:LoaderInfo;
		
		public static var imageEffectEditor:MovieClip;
		
		public static var editorContainer:MovieClip=new MovieClip();
		
		public static var LANGUAGE_DATA:Object={};
		
		public static const MAX_SELECT_NUM:int=6;
		public static const MAX_IMAGE_WIDTH:Number=300;
		public static const MAX_IMAGE_HEIGHT:Number=280;
		
		public static const TOTAL_PLAY_TIME:Number=9;
		public static const SINGLE_EFF_TIME:Number=0.6;
		public static var singleImgTime:Number=0;
		
		/**拖动管理器*/
		public static var drag:DragManager = new DragManager();
		
		public static var dragType:String="";
		
		public function Root()
		{
			
		}
		
		/**
		 * 
		 * @param $stage
		 * @param $loaderInfo
		 * @param $imageEffectEditor
		 */
		public static function init($stage:Stage,$loaderInfo:LoaderInfo,$imageEffectEditor:MovieClip):void{
			stage=$stage;
			loaderInfo=$loaderInfo;
			imageEffectEditor=$imageEffectEditor;
			
			imageEffectEditor.addChild(editorContainer);
		}
		
		public static function initDataUrl():void{
			
		}
	}
}