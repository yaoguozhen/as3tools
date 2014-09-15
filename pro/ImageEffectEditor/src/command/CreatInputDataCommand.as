package command
{
	import com.zqvideo.model.data.DataPoolManager;
	import com.zqvideo.utils.CreatXMLManager;
	import com.zqvideo.view.component.EditorEffectImage;
	import com.zqvideo.view.component.EditorImageAndEffectBox;
	import com.zqvideo.view.component.EffTransitionElement;
	
	import mvc.Command;
	import mvc.ICommand;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class CreatInputDataCommand extends Command implements ICommand
	{
		private var panelName:String="";
		private var inputNameStr:String="";
		private var editorImageAndEffectBox:EditorImageAndEffectBox;
		private var imageVec:Vector.<EditorEffectImage>=new Vector.<EditorEffectImage>();
		private var effTransitionVec:Vector.<EffTransitionElement>=new Vector.<EffTransitionElement>();
		private var inputData:Vector.<Object>=new Vector.<Object>();
		
		public function CreatInputDataCommand()
		{
			super();
		}
		
		/**
		 * 
		 * @param type
		 * @param obj
		 */
		public function execute(type:String, obj:Object=null):void
		{
			if(obj.panelName){
				panelName=obj.panelName;
			}
			
			switch(panelName){
				case "EditorPanel":
					if(obj.inputView&&obj.inputName){
						inputNameStr=obj.inputName;
						editorImageAndEffectBox=obj.inputView;
						imageVec=editorImageAndEffectBox.imageVec;
						effTransitionVec=editorImageAndEffectBox.effTransitionVec;
						inputData.length=0;
					}else{
						return;
					}
					
					for(var i:int=0;i<imageVec.length;i++){
						if(imageVec[i].isHasData){
							//none特效名字
							var $name:String=DataPoolManager.getInstance().moRenEffectData.@englishName;
							var $from:String=imageVec[i].data.@localPath;
							var $to:String=$from;
							var $duration:String=String(Root.singleImgTime);
							var obj:Object={name:$name,from:$from,to:$to,duration:$duration};
							inputData.push(obj);
							
							isEffTransitionHasData(i);
						}
					}
					
					CreatXMLManager.getInstance().creatXML(inputData,inputNameStr);
					break;
			}
		}
		
		private function isEffTransitionHasData($index:int):void{
			var index:int=$index;
			if(index>effTransitionVec.length-1){
				return;
			}
			if(effTransitionVec[index].isHasData&&effTransitionVec[index].data!=DataPoolManager.getInstance().moRenEffectData){
				if(imageVec[index+1].isHasData){
					var $name:String=effTransitionVec[index].data.@englishName;
					var $from:String=imageVec[index].data.@localPath;
					var $to:String=imageVec[index+1].data.@localPath;
					var $duration:String=effTransitionVec[index].data.@duration;
					var obj:Object={name:$name,from:$from,to:$to,duration:$duration};
					inputData.push(obj);
				}
				
			}
		}
	}
}