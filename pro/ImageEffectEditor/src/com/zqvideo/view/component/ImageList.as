package com.zqvideo.view.component
{
	import com.zqvideo.model.data.DataPoolManager;
	import com.zqvideo.utils.SkinManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;

	public class ImageList extends ImageArrangeBox
	{
		
		public function ImageList()
		{
			super();
			arrangeImageNum=6;
			//initShow();
		}

		private function initShow():void
		{
			var arrangeIndex:int=0;
			var yUpdateNum:Number=0;
			var xDistance:Number=0;
			var yDistance:Number=1;
			var imageMCCls:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info, "NewImgSucai");
			xDistance=7;

			for (var i:int=0; i < Root.EDITORPAGE_IMAGE_SHOWNUM; i++)
			{
				var imageMC:MovieClip=new imageMCCls();
				var img:ShowSuCaiImage=new ShowSuCaiImage();
				img.ui=imageMC;
//				img.data=data.child(xmlNodeName)[i];
//				img.pageIndex=pageIndex;
//				img.id=int(data.child(xmlNodeName)[i].@ID);
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
            imageContainer.x=img.width+xDistance;
		}

		/**
		 *
		 * @param value
		 */
		override public function set data(value:XML):void
		{
			_data=value;
			if (!xmlNodeName)
			{
				return;
			}
			
			var arrangeIndex:int=0;
			var yUpdateNum:Number=0;
			var xDistance:Number=0;
			var yDistance:Number=1;
			var imageMCCls:Class=SkinManager.getSkinClassByName(DataPoolManager.getInstance().info, "NewImgSucai");
			xDistance=7;
			
			for (var i:int=0; i < data.child(xmlNodeName).length(); i++)
			{
				var imageMC:MovieClip=new imageMCCls();
				var img:ShowSuCaiImage=new ShowSuCaiImage();
				img.ui=imageMC;
				img.data=data.child(xmlNodeName)[i];
				img.pageIndex=pageIndex;
				img.id=int(data.child(xmlNodeName)[i].@ID);
				img.sordID=i;
				img.totalDataObj={selectedPageIndex:img.pageIndex,selectedID:img.id,selectedData:img.data};
				img.addEventListener("img_complete",onNextImg);
				img.x=arrangeIndex * (img.width + xDistance);
				img.y=yUpdateNum;
				arrangeIndex++;
				if ((i + 1) % arrangeImageNum == 0)
				{
					arrangeIndex=0;
					yUpdateNum+=(img.height + yDistance);
				}
				
				//				trace(img.sordID,pageIndex);
				
				if(i==0){
					img.startLoad();
				}
				imageContainer.addChild(img);
				imageArr.push(img);
				
			}
			imageContainer.x=img.width+xDistance;

//			var img:ShowSuCaiImage;
//			var imageMC:MovieClip;
//			//trace("data.child(xmlNodeName).length():", data.child(xmlNodeName).length());
//			var len:uint=data.child(xmlNodeName).length();
//			trace(len,'zzzzzzzz');
//			for (var i:int=0; i < len; i++)
//			{
//				imageMC=new imageMCCls();
//				img=imageArr[i] as ShowSuCaiImage;
//				img.data=data.child(xmlNodeName)[i];
//				img.pageIndex=pageIndex;
//				
//				img.id=int(data.child(xmlNodeName)[i].@ID);
//				img.sordID=i;
//				img.totalDataObj={selectedPageIndex:img.pageIndex,selectedID:img.id,selectedData:img.data};
//				img.addEventListener("img_complete",onNextImg);
//				//				trace(img.sordID,pageIndex);
//				if(i==0){
//					img.startLoad();
//				}
//				//trace("ImageList:"+img.data.toXMLString()+"||"+img.pageIndex+"||"+img.id);
//			}
		}
		
		protected function onNextImg(event:Event):void
		{
			// TODO Auto-generated method stub
			
			var img:ShowSuCaiImage=event.currentTarget as ShowSuCaiImage;
			img.removeEventListener("img_complete",onNextImg);
			var sid:int=img.sordID+1;
//			trace(sid,pageIndex);
			
			if(sid< data.child(xmlNodeName).length()){
				img=imageArr[sid];
				img.startLoad();
			}
		}
	}
}
