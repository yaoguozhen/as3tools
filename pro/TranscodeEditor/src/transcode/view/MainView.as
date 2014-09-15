package transcode.view
{
	import com.adobe.serialization.json.JSON;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import morn.core.utils.ObjectUtils;
	import morn.core.utils.StringUtils;
	
	import transcode.EventManager;
	import transcode.event.NetEvent;
	import transcode.request.GetListReq;
	import transcode.request.MediaInfoReq;
	import transcode.request.RequestType;
	import transcode.request.SubmitTaskReq;
	import transcode.request.TaskProgressReq;
	import transcode.request.TemplateReq;
	import transcode.request.UploadReq;
	
	public class MainView extends Sprite
	{	
		
		private var uploadReq:UploadReq;
		private var getListReq:GetListReq;
		private var mediaInfoReq:MediaInfoReq;
		private var templateReq:TemplateReq;
		private var submitTaskReq:SubmitTaskReq;
		private var taskProgressReq:TaskProgressReq;
		
		private var templeArr:Array=[];
		private var submitTaskType:String="";
		private var selectFileName:String="";
		private var selectTemplateIndexArr:Array=[];
		private var playUrlArr:Array=[];
		
		private var taskProgressTimer:Timer;
		private var showTranscodeTimeTimer:Timer;
		private var taskID:int=0;
		private var transcodePer:int=0;
		
		private var transcodeTime:int=0;
		
		public const TASK_TYPE_FILE:String="Task_Type_File"; //普通转码任务
		public const TASK_TYPE_CLIP:String="Task_Type_Clip"; //切片转码任务
		public const UPLOAD_SUCESS:String="success";
		public const DATA_ERROR:String="error";
		public const TRANSCODE_TIME:int=5;
		
		private var bgView:BGView;
		private var ballView:BallView;
		private var leftObjectView:LeftObjectView;
		private var rightObjectView:RightObjectView;
		private var selectVideoView:SelectVideoView;
		private var startBtnView:StartBtnView;
		
		private var flyOut:FlyOut;
		
		
		public function MainView()
		{
			super();
			if(stage){
				onAddedToStage(null);
			}else{
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
		}
		
		private function onAddedToStage(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addViews();
			initFlyOut();
			initDataPort();
		}
		
		private function addViews():void
		{
			bgView=new BGView();
			addChild(bgView);
			
			leftObjectView=new LeftObjectView();
			leftObjectView.x=38;
			leftObjectView.y=151.5;
			addChild(leftObjectView);
			
			rightObjectView=new RightObjectView();
			rightObjectView.addEventListener("playVideo",playVideoHandler);
			rightObjectView.addEventListener("downloadVideo",downloadVideoHandler);
			rightObjectView.x=602;
			rightObjectView.y=151.5;
			addChild(rightObjectView);
			
			ballView=new BallView();
			ballView.addEventListener("labelHideFinish",labelHideFinishHandler);
			ballView.x=339;
			ballView.y=115;
			addChild(ballView);
			
			selectVideoView=new SelectVideoView();
			selectVideoView.addEventListener("selectFile",selectFileHandler);
			selectVideoView.addEventListener("loadExistFile",loadExistFileHandler);
			selectVideoView.addEventListener("dataReady",dataReadyHandler);
			selectVideoView.addEventListener("dataNotReady",dataNotReadyHandler);
			selectVideoView.addEventListener("checkVideoMsg",checkVideoMsgHandler);
			selectVideoView.addEventListener("itemClick",comboBoxItemClickHandler);
			selectVideoView.x=234;
			selectVideoView.y=25;
			addChild(selectVideoView);
			
			startBtnView=new StartBtnView();
			startBtnView.x=430;
			startBtnView.y=463;
			addChild(startBtnView);
			startBtnView.addEventListener("startBtnClick",startBtnClickHandler);
			
		}
		private function dataReadyHandler(evn:Event):void
		{
			startBtnView.changeState("1");
		}
		private function dataNotReadyHandler(evn:Event):void
		{
			startBtnView.changeState("2");
		}
		private function checkVideoMsgHandler(evn:Event):void
		{
			this.leftObjectView.clear();
			selectFileName=selectVideoView.selectExistFileName;
			App.log.echo("selectFileName:"+selectFileName);
			getMediaInfoData(selectFileName);
		}
		private function comboBoxItemClickHandler(evn:Event):void
		{
			if(evn.target.itemType=="templeComboBoxItem")
			{
				trace("模板列表，选中的模板id列表:", selectVideoView.templeSelectedValues);
				trace("模板列表，选中的模板的索引列表:", selectVideoView.templeSelectedItemIndexArray);
				selectTemplateIndexArr=selectVideoView.templeSelectedItemIndexArray;
			}
			//			else if(evn.target.itemType=="existFileItem")
			//			{
			//				trace("选择的已存在文件的文件名：",selectVideoView.existFileName);
			//			}
		}
		private function startBtnClickHandler(evn:Event):void
		{
			trace("点击开始按钮");
			trace("切片:",selectVideoView.isSection);
			
			initItemShow();
			
			if(selectVideoView.isSection){
				submitTaskType=TASK_TYPE_CLIP;
			}else{
				submitTaskType=TASK_TYPE_FILE;
			}
			
			getSubmitTaskData(submitTaskType,selectFileName,selectTemplateIndexArr);
		}
		private function initFlyOut():void
		{
			flyOut=new FlyOut();
			flyOut.setObj(leftObjectView,rightObjectView,ballView);
		}
		private function playVideoHandler(evn:Event):void
		{
			App.log.echo(">>>videoPlayer playUrl:"+rightObjectView.url);
			var req:URLRequest=new URLRequest(EditorConfig.assetPath+"transplayer/YSPlayer.html?a="+rightObjectView.url);
			navigateToURL(req,"_blank");
		}
		private function downloadVideoHandler(evn:Event):void
		{
			var req:URLRequest=new URLRequest(rightObjectView.url);
			navigateToURL(req,"_blank");
		}
		private function labelHideFinishHandler(evn:Event):void
		{
			flyOut.move();
		}
		private function initDataPort():void{
			//上传接口
			uploadReq=new UploadReq();
			EventManager.instance.addEventListener(RequestType.UP_LOAD,uploadCompleteHandler);
			EventManager.instance.addEventListener(RequestType.UP_LOAD_PROGRESS,uploadProgressHandler);
			
			//已有文件列表接口
			getListReq=new GetListReq();
			EventManager.instance.addEventListener(RequestType.GET_LIST,getListCompleteHandler);
			
			//文件信息接口，帧率，码率等
			mediaInfoReq=new MediaInfoReq();
			EventManager.instance.addEventListener(RequestType.MEDIA_INFO,getMediaInfoCompleteHandler);
			
			//模板接口，参数写死了
			templateReq=new TemplateReq();
			var obj:Object={"range":"200"};
			var str:String=com.adobe.serialization.json.JSON.encode(obj);
			trace("template:"+str);
			templateReq.data=str;
			EventManager.instance.addEventListener(RequestType.TEMPLATE,getTemplateCompleteHandler);
			
			//提交转码任务接口
			submitTaskType=TASK_TYPE_FILE;
			submitTaskReq=new SubmitTaskReq();
			EventManager.instance.addEventListener(RequestType.SUBMIT_TASK,getSubmitTaskCompleteHandler);
			
			//请求转码进度接口
			taskProgressReq=new TaskProgressReq();
			EventManager.instance.addEventListener(RequestType.TASK_PROGRESS,getTaskProgressComHandler);
			
			taskProgressTimer=new Timer(TRANSCODE_TIME*1000);
			taskProgressTimer.addEventListener(TimerEvent.TIMER,taskProgressTimerHandler);
			
			showTranscodeTimeTimer=new Timer(1000);
			showTranscodeTimeTimer.addEventListener(TimerEvent.TIMER,showTranscodeTimeHandler);
			
			getTemplateData();
		}
		
		private function selectFileHandler(evn:Event):void
		{
			this.startBtnView.changeState("2");
			selectVideoView.uploadPer=0;
			uploadFile();
		}
		private function loadExistFileHandler(evn:Event):void
		{
			getListData();
		}
		
		private function uploadFile():void{
			uploadReq.send();
		}
		
		private function getListData():void{
			getListReq.send();
		}
		
		private function getMediaInfoData(fileName:String):void{
			if(fileName){
				mediaInfoReq.fileName=StringUtils.trim(fileName);
				mediaInfoReq.send();
			}
		}
		
		private function getTemplateData():void{
			templateReq.send();
		}
		
		private function getSubmitTaskData(type:String,fileName:String,templateIndexArr:Array):void{
			if(!fileName||templateIndexArr.length<=0){
				return;
			}
			if(type==TASK_TYPE_FILE){
				submitTaskReq.url=decodeURIComponent(EditorConfig.fileCreate);
			}else if(type==TASK_TYPE_CLIP){
				submitTaskReq.url=decodeURIComponent(EditorConfig.clipCreate);
			}
			
			playUrlArr=[];
			var splitName:String=splitFileName(fileName);
			
			var totalObj:Object={};
			totalObj={"user_id":"00001","user_token":"zhangchengchun","business_code":"test_tool","file_url":EditorConfig.fileUrl+fileName,
				"dest_url":EditorConfig.readUrl,"callback":"http://192.168.0.131:8080/Demo/trans/callBack.action","priority":100,
				"output":[]
			};
			
			for(var i:int=0;i<templateIndexArr.length;i++){
				var index:int=templateIndexArr[i];
				var indexObj:Object=templeArr[index];
				var outputObj:Object={};
				outputObj.template_id=indexObj.template_id;
				var templateName:String=indexObj.template_name;
				var templateFormat:String=indexObj.format;
				outputObj.output_file=splitName+"_"+templateName+"."+templateFormat;
				trace("outputObj:"+outputObj.template_id,outputObj.output_file);
				var playUrl:String=EditorConfig.destUrl+outputObj.output_file;
				totalObj.output.push(outputObj);
				playUrlArr.push(playUrl);
			}
			
			trace("totalObj.output.length:"+totalObj.output.length);
			trace("totalObj.file_url:"+totalObj.file_url);
			
			var str:String=com.adobe.serialization.json.JSON.encode(totalObj);
			submitTaskReq.data=str;
			submitTaskReq.send();
		}
		
		private function uploadCompleteHandler(e:NetEvent):void{
			uploadReq.stopTimer();
			var uploadState:String=String(e.data);
			if(uploadState!=DATA_ERROR){
				//上传成功
				selectVideoView.uploadPer=1;
				selectFileName=uploadState;
				getMediaInfoData(uploadState);
				this.selectVideoView.onUploadComplete();
			}else{
				//上传失败
				App.log.echo(">>>文件上传失败！");
				selectVideoView.uploadPer=0;
			}
		}
		
		private function uploadProgressHandler(e:NetEvent):void{
			trace("上传服务器进度："+int(e.data));
			selectVideoView.uploadPer=int(e.data)/100;
		}
		
		private function getListCompleteHandler(e:NetEvent):void{
			var resultArr:Array=e.data as Array;
			selectVideoView.existFileList=resultArr;
		}
		
		private function getMediaInfoCompleteHandler(e:NetEvent):void{
			var infoObj:Object=e.data;
			/**
			 * 时长 infoObj.duration
			 * 码率 infoObj.malv
			 * 分辨率 infoObj.fenBianLv
			 * 视频编码 infoObj.videoMa
			 * 音频编码 infoObj.audioMa
			 */
			this.leftObjectView.videoData=infoObj;
			ballView.setVideoDuration(infoObj.duration);
		}
		
		private function getTemplateCompleteHandler(e:NetEvent):void{
			templeArr=e.data;
			selectVideoView.templeList=templeArr;
		}
		
		private function getSubmitTaskCompleteHandler(e:NetEvent):void{
			var obj:Object=e.data;
			var result:Boolean=obj.result;
			if(result){
				//转码任务提交成功
				var task_id:int=obj.info.task_id;
				App.log.echo("转码任务提交成功："+obj.result,task_id);
				//请求转码任务
				taskID=task_id;
				ballView.transcodePer("0%");
				getTaskProgressData(taskID);
//				taskProgressTimer.start();
				showTranscodeTimeTimer.start();
			}else{
				//转码任务提交失败
				App.log.error("转码任务提交失败！");
			}
		}
		
		private function getTaskProgressData(task_id:int):void{
			var obj:Object={};
			obj={"user_id":"00001","user_token":"zhangchengchun","business_code":"test_tool","task_id":String(task_id)};
			var str:String=com.adobe.serialization.json.JSON.encode(obj);
			taskProgressReq.data=str;
			taskProgressReq.send();
		}
		
		private function getTaskProgressComHandler(e:NetEvent):void{
			var obj:Object=e.data;
			var result:Boolean=obj.result;
			if(result==false){
				trace("转码失败！");
				transcodeLose();
				return;
			}
			var info:Object=obj.info;
			var status:int=info.status;
			if(status<0){
				trace("转码失败！");
				transcodeLose();
				return;
			}else if(status==2){
				//转码进度条显示
				trace("转码成功！");
				transcodeSucess();
			}else{
				//等待转码中
				trace("等待转码中！");
				transcodePer=info.progress;
				ballView.transcodePer(String(transcodePer)+"%");
				trace(",,,,"+showTranscodeTimeTimer.running);
				getTaskProgressData(taskID);
			}
		}
		
		private function transcodeLose():void{
			stopTimer();
			transcodePer=0;
			ballView.showDoing(false);
			ballView.transcodePer("转码失败！",true);
			startBtnView.changeState("1");
			this.selectVideoView.actived=true;
		}
		
		private function transcodeSucess():void{
			stopTimer();
			transcodePer=100;
			ballView.showDoing(false);
			ballView.transcodePer(String(transcodePer)+"%");
			startBtnView.changeState("1");
			if(playUrlArr.length>0){
				var cloneUrlArr:Array=ObjectUtils.clone(playUrlArr);
				rightObjectView.videoData=cloneUrlArr;
				for(var i:int=0;i<cloneUrlArr.length;i++){
					trace(">>>playUrl:"+cloneUrlArr[i]);
				}
			}
			this.selectVideoView.actived=true;
		}
		
		private function taskProgressTimerHandler(e:TimerEvent):void{
//			getTaskProgressData(taskID);
		}
		
		private function showTranscodeTimeHandler(e:TimerEvent):void{
			transcodeTime+=1;
			ballView.setUseTime(transcodeTime*1000);
			App.log.echo("转码耗时："+transcodeTime);
		}
		
		private function initItemShow():void{
			this.rightObjectView.clear();
			ballView.showDoing(true);
			this.selectVideoView.actived=false;
			transcodePer=0;
			ballView.transcodePer("提交转码任务...");
			transcodeTime=0;
			ballView.setUseTime(0);
		}
		
		private function stopTimer():void{
			try
			{
				taskProgressTimer.stop();
				showTranscodeTimeTimer.stop();
				//transcodePer=0;
			} 
			catch(error:Error) 
			{
				
			}
		}
		
		private function splitFileName(srcName:String):String{
			var newName:String="";
			var index:int=0;
			
			for(var i:int=0;i<EditorConfig.formatArr.length;i++){
				if(srcName.indexOf(EditorConfig.formatArr[i])>-1){
					index=srcName.indexOf(EditorConfig.formatArr[i]);
					newName=srcName.slice(0,index);
					break;
				}
			}
			
			return newName;
		}
	}
}