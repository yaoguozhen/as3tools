package com.zqvideo.utils
{
	import com.zqvideo.model.core.Model;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class CreatXMLManager extends Model
	{
		private static var instance:CreatXMLManager=new CreatXMLManager();
		
		private var _inputXML:XML;
		private var _path:String="";
		
		public function CreatXMLManager()
		{
			if (instance)
			{
				throw new Error("CreatXMLManager.getInstance()获取实例");
			}
		}
		
		/**
		 * 
		 * @return 
		 */
		public static function getInstance():CreatXMLManager
		{
			return instance;
		}
		
		public function get inputXML():XML{
			return _inputXML;
		}
		
		public function set inputXML(value:XML):void{
			_inputXML=value;
		}
		
		public function get path():String{
			return _path;
		}
		
		public function set path(value:String):void{
			_path=value;
		}
		
		public function creatXML(objVec:Vector.<Object>,inputNameStr:String):void{
			//根节点
			var xml:XML=<ConfigurationSettings xmlns="https://comet.balldayton.com/standards/namespaces/2005/v1/comet.xsd">
                      </ConfigurationSettings>;
			//版本号节点
			var xml1:XML=<Helen version="1"/>;
			
			var selectMusicUrl:String="";
			if(Root.useSound&&Root.soundTranscodeURL!="")
			{
				selectMusicUrl=Root.soundTranscodeURL
			}
			var test:XML=<musicUrl>{selectMusicUrl}</musicUrl>
			xml.appendChild(test);
			
			xml.appendChild(xml1);
			//animation节点
			var xml2:XML=<animation name="User-defined" path="">
                       </animation>
				
			if(path){
				xml2.@path=path;
			}
			xml.appendChild(xml2);
			
			//effect节点和对应子节点
			for(var i:int=0;i<objVec.length;i++){
				var childXML:XML=<effect></effect>;
				var content_name:String=String(objVec[i].name);
				var content_from:String=String(objVec[i].from);
				var content_to:String=String(objVec[i].to);
				var content_duration:String=String(objVec[i].duration);
				
				var nameXML:XML=<name>{content_name}</name>;
				var fromXML:XML=<from>{content_from}</from>;
				var toXML:XML=<to>{content_to}</to>;
				var durationXML:XML=<duration>{content_duration}</duration>;
				
				childXML.appendChild(nameXML);
				childXML.appendChild(fromXML);
				childXML.appendChild(toXML);
				childXML.appendChild(durationXML);
				
				xml2.appendChild(childXML);
			}
			
			trace(xml.toXMLString());
			sendNotification("updateDataCommand",{dataType:"SEND_IMAGE",inputName:inputNameStr,sendXml:xml});
		}
	}
}