package com.zqvideo.utils
{
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	
	public class EffectUtils
	{
		public function EffectUtils()
		{
			
		}
		
		public static function getTheDifferentUrls(newArr:Array,oldArr:Array):Array{
			//newArr=[1,2,3,4,5,7];
			//oldArr=[1,2,3,4,5,6];
			if(oldArr.length<=0){
				return newArr;
			}else{
				var loadUrlArr:Array=[];
				for(var i:int=0;i<newArr.length;i++){
					var newUrlStr:String=newArr[i];
					//for(newUrlStr in oldArr){
					if(oldArr.indexOf(newUrlStr)==-1){
						trace(">>>need load imgUrl:"+newUrlStr);
						loadUrlArr.push(newUrlStr);
					}
					//}
				}
				return loadUrlArr;
			}
		}
		
		public static function getTheSameImgObjUrls(imgUrlArr:Array,imgObjArr:Array):Array{
			if(imgObjArr.length<=0){
				return imgObjArr;
			}else{
				var imgUrlStrArr:Array=[];
				for(var i:int=0;i<imgObjArr.length;i++){
					var obj:Object=imgObjArr[i];
					var imgUrl:String=obj.urlStr;
					imgUrlStrArr.push(imgUrl);
				}
				var updateImgObjArr:Array=[];
				for(var j:int=0;j<imgUrlArr.length;j++){
					var cloneImgUrl:String=imgUrlArr[j];
					if(imgUrlStrArr.indexOf(cloneImgUrl)!=-1){
						var index:int=imgUrlStrArr.indexOf(cloneImgUrl);
						updateImgObjArr.push(imgObjArr[index]);
					}
				}
				return updateImgObjArr;
			}
		}
		
		public static function getTheArrangeUrls(arrangeUrlArr:Array,totalImgObjArr:Array):Array{
			trace(">>>length:"+arrangeUrlArr.length+"||"+totalImgObjArr.length);
			var imageArr:Array=[];
			var totalImgUrlArr:Array=[];
			for(var i:int=0;i<totalImgObjArr.length;i++){
				var urlStr:String=totalImgObjArr[i].urlStr;
				totalImgUrlArr.push(urlStr);
			}
			
			for(var j:int=0;j<arrangeUrlArr.length;j++){
				var arrangeUrlStr:String=arrangeUrlArr[j];
				if(totalImgUrlArr.indexOf(arrangeUrlStr)!=-1){
					var index:int=totalImgUrlArr.indexOf(arrangeUrlStr);
					var bitmap:Bitmap=totalImgObjArr[index].bitmap as Bitmap;
					imageArr.push(bitmap);
				}
			}
			
			return imageArr;
		}
		
		public static function clone(source:Object):* {
			var copier:ByteArray = new ByteArray();
			copier.writeObject(source);
			copier.position = 0;
			return(copier.readObject());
		}
	}
}