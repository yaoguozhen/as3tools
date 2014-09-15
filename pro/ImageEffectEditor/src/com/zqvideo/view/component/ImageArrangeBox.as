package com.zqvideo.view.component
{
	import com.zqvideo.model.data.DataPoolManager;
	import com.zqvideo.utils.SkinManager;
	
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mvc.Command;
	import mvc.ICommand;

	/**
	 *
	 * @author .....Li灬Star
	 */
	public class ImageArrangeBox extends MovieClip
	{
		protected var _pageIndex:int;
		protected var _imageType:String="";
		protected var _arrangeDirection:String=""; //排列方向
		protected var _arrangeImageNum:int;
		protected var _data:XML;
		protected var _xmlNodeName:String="";
		protected var imageArr:Array=new Array();
		protected var imageContainer:Sprite;

		public function ImageArrangeBox()
		{
			super();
			imageContainer=new Sprite();
			this.addChild(imageContainer);
		}
		

		/**
		 * 
		 * @return 
		 */
		public function get pageIndex():int{
			return _pageIndex;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set pageIndex(value:int):void{
			_pageIndex=value;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get imageType():String
		{
			return _imageType;
		}

		/**
		 * 
		 * @param value
		 */
		public function set imageType(value:String):void
		{
			_imageType=value;
		}

		/**
		 * 
		 * @return 
		 */
		public function get arrangeDirection():String
		{
			return _arrangeDirection;
		}

		/**
		 * 
		 * @param value
		 */
		public function set arrangeDirection(value:String):void
		{
			_arrangeDirection=value;
		}

		/**
		 * 
		 * @return 
		 */
		public function get arrangeImageNum():int
		{
			return _arrangeImageNum;
		}

		/**
		 * 
		 * @param value
		 */
		public function set arrangeImageNum(value:int):void
		{
			_arrangeImageNum=value;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get imagesArr():Array{
			return imageArr;
		}

		public function get imgContainer():Sprite{
			return imageContainer;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get data():XML
		{
			return _data;
		}

		/**
		 * 
		 * @param value
		 */
		public function set data(value:XML):void
		{
			_data=value;
			if(!xmlNodeName){
				return;
			}

			while (imageContainer.numChildren > 0)
			{
				imageContainer.removeChildAt(0);
			}

			var arrangeIndex:int=0;
			var yUpdateNum:Number=0;
			var xDistance:Number=0;
			var yDistance:Number=10;
			
			var imageMCCls:Class;
			if(imageType=="HomePageImage"){
				imageMCCls=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info, "ImageContainer");
				xDistance=15;
			}else if(imageType=="EditorSuCaiImage"){
				imageMCCls=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info, "ImageSuCaiContainer");
				xDistance=8;
			}
			else if(imageType=="PublishSucai"){
				imageMCCls=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info, "PublishSucai");
				xDistance=8;
			}

			if (arrangeDirection == "Horizontal")
			{
				trace("data.child(xmlNodeName).length():",data.child(xmlNodeName).length());
				for (var i:int=0; i < arrangeImageNum; i++)
				{
					var imageMC:MovieClip=new imageMCCls();
					var img:Image;
					if (imageType == "HomePageImage")
					{
						img=new HomePageImage();
					}else if(imageType=="EditorSuCaiImage"){
						if(i>=Root.EDITORPAGE_IMAGE_SHOWNUM){
							return;
						}
						img=new EditorSuCaiImage();
					}
					else if(imageType=="PublishSucai"){
						if(i>=Root.EDITORPAGE_IMAGE_SHOWNUM){
							return;
						}
						img=new PublishImage();
					}
					img.ui=imageMC;
					if(i<data.child(xmlNodeName).length())
					{
						img.data=data.child(xmlNodeName)[i];
						img.pageIndex=pageIndex;
						img.id=int(data.child(xmlNodeName)[i].@ID);
					}
					img.x=arrangeIndex * (img.width + xDistance);
					img.y=yUpdateNum;
					arrangeIndex++;
					if ((i + 1) % arrangeImageNum == 0)
					{
						arrangeIndex=0;
						yUpdateNum+=(img.height + yDistance);
					}
					imageContainer.addChild(img);
					imageArr.push(img);
				}
			}

		}
		
		/**
		 * 
		 * @param vec
		 */
		public function addImageSelectedStatus(vec:Vector.<Object>):void{
			for(var i:int=0;i<vec.length;i++){
				if(vec[i].pageIndex!=pageIndex){
					return;
				}else{
					var id:int=vec[i].id;
					//trace("********>"+id);
					if(imageArr[i] is Image&&imageArr[i].id==id){
						//imageArr[i].isSelected=true;
					}
				}
			}
		}
		
		/**
		 * 
		 * @param selectedData
		 */
		public function removeImageSelectedStatus(selectedData:Object):void{
			if(selectedData.selectedPageIndex!=pageIndex){
				return;
			}else{
				for(var i:int=0;i<imageArr.length;i++){
					var id:int=selectedData.selectedID;
					
					if(imageArr[i] is Image&&imageArr[i].id==id){
						imageArr[i].isSelected=false;
						break;
					}
				}
			}
		}

		/**
		 * 
		 * @return 
		 */
		public function get xmlNodeName():String
		{
			return _xmlNodeName;
		}

		/**
		 * 
		 * @param value
		 */
		public function set xmlNodeName(value:String):void
		{
			_xmlNodeName=value;
		}
	}
}
