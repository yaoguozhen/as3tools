package com.zqvideo.view.component
{
	import com.zqvideo.model.data.DataPoolManager;
	import com.zqvideo.utils.SkinManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class HasSelectedImageBox extends MovieClip
	{
		private var hasSelectedImageContainer:Sprite;
		private var selectedImageMCCls:Class;
		private var _hasSelectedImageData:Vector.<Object>=new Vector.<Object>();
		private var _imageVec:Vector.<HasSelectedImage>=new Vector.<HasSelectedImage>();
		
		public function HasSelectedImageBox()
		{
			super();
			
			hasSelectedImageContainer=new Sprite();
			this.addChild(hasSelectedImageContainer);
			
			selectedImageMCCls=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info,"SelectImageContainer");
		}
		
		public function get hasSelectedImageData():Vector.<Object>{
			return _hasSelectedImageData;
		}
		
		public function set hasSelectedImageData(value:Vector.<Object>):void{
			_hasSelectedImageData=value;
		}
		
		public function get imageVec():Vector.<HasSelectedImage>{
			return _imageVec;
		}
		
		public function set imageVec(value:Vector.<HasSelectedImage>):void{
			_imageVec=value;
		}
		
		/**
		 * 
		 * @param selectedObj
		 */
		public function addSelectedElement(selectedObj:Object):void{
			//trace(selectedObj.selectedPageIndex+"||"+selectedObj.selectedID+"||"+selectedObj.selectedData.toXMLString()+"||"+selectedObj.updateType+"||"+selectedObj.imageType);
			var imageMC:MovieClip=new selectedImageMCCls();
			var img:HasSelectedImage=new HasSelectedImage();
			img.ui=imageMC;
			img.pageIndex=selectedObj.selectedPageIndex;
			img.id=selectedObj.selectedID;
			//trace(selectedObj.selectedID);
			img.data=selectedObj.selectedData;
			var obj:Object={pageIndex:selectedObj.selectedPageIndex,id:selectedObj.selectedID,data:selectedObj.selectedData};
			_hasSelectedImageData.push(obj);
			hasSelectedImageContainer.addChild(img);
			_imageVec.push(img);
			updateImageCoord();
		}
		
		/**
		 * 
		 * @param selectedObj
		 */
		public function removeSelectedElement(selectedObj:Object):void{
			for(var i:int=0;i<_imageVec.length;i++){
				var img:HasSelectedImage=_imageVec[i] as HasSelectedImage;
				if(img.pageIndex==selectedObj.selectedPageIndex&&img.id==selectedObj.selectedID){
					hasSelectedImageContainer.removeChild(img);
					_hasSelectedImageData.splice(i,1);
					_imageVec.splice(i,1);
					break;
				}
			}
			updateImageCoord();
		}
		
		private function updateImageCoord():void{
			for(var i:int=0;i<_imageVec.length;i++){
				_imageVec[i].x=i*(_imageVec[i].width+15);
			}
			
			//trace(">>>_hasSelectedImageData.length:"+_hasSelectedImageData.length);
		}
	}
}