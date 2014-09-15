package transcode.request
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	public class GetListReq extends BaseRequest
	{
		public function GetListReq()
		{
			super();
			
			this.API=EditorConfig.getExistFiles;
			this._type=RequestType.GET_LIST;
		}
		
		override protected function init():void{
			_request.method=URLRequestMethod.POST;
		}
		
		override protected function validateResult():void{
			var str:String = _urlloader.data;
			var arr:Array=String(_data).split(",");
			var resultArr:Array=[];
			for( str in arr){
				trace(">>>:"+str,arr[str]);
				var newStr:String=setNewStr(arr[str]);
				resultArr.push(newStr);
				//trace(JSON.parse(arr[str]),'mmm');
			}
			
			_result=resultArr;
		}
		
		private function setNewStr(srcStr:String):String{
			var str:String="";
			var newStr:String;
			if(srcStr.indexOf("[")>-1){
				str=srcStr.slice(srcStr.indexOf("[")+1);
				srcStr=str;
			}
			if(srcStr.indexOf("]")>-1){
				str=srcStr.slice(0,srcStr.length-1);
				srcStr=str;
			}
			str=srcStr;
			newStr=str.slice(1,str.length-1);
			return newStr;
		}
	}
}