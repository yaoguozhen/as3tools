package
{
	public class EditorConfig
	{
		public static var host:String="";
		public static var assetPath:String="";
		public static var upload:String="";
		public static var getExistFiles:String="";
		public static var getMediaInfo:String="";
		public static var callApi:String="";
		public static var query:String="";
		public static var fileCreate:String="";
		public static var clipCreate:String="";
		public static var taskProgress:String="";
		public static var playVideo:String="";
		public static var downLoadVideo:String="";
		public static var fileUrl:String="";
		public static var destUrl:String="";
		public static var readUrl:String="";
		public static var formatArr:Array=[".ts",".mp4",".mpeg",".mpg",".mkv",".mov",".avi",".flv"];
		
		public static const APP_WIDTH:Number=1002;
		
		public function EditorConfig()
		{
		}
		
		public static function getAssetPath(url:String):String
		{
			/*if(url.toLowerCase().indexOf("http") == 0){ 
				return url;
			}*/
			return assetPath + url;
		}
	}
}