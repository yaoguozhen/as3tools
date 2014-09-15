package transcode.request
{
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class MediaInfoReq extends BaseRequest
	{
		public var fileName:String="";
		
		public function MediaInfoReq()
		{
			super();
			
			this.API=EditorConfig.getMediaInfo;
			this._type=RequestType.MEDIA_INFO;
		}
		
		override protected function init():void{
			var vars:URLVariables = new URLVariables();
			if(fileName){
				vars.fileName=fileName;
			}
			_request.data=vars;
			_request.method=URLRequestMethod.POST;
		}
		
		override protected function validateResult():void{
			var infoObj:Object={};
			infoObj.duration=_data[2].second;
			infoObj.malv=_data[0].second;
			infoObj.fenBianLv=_data[3].second;
			infoObj.videoMa=_data[4].second;
			infoObj.audioMa=_data[5].second;
			_result=infoObj;
		}
	}
}