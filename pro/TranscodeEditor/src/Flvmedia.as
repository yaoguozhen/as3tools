package 
{
        import flash.display.Sprite;
        import flash.events.NetStatusEvent;
        import flash.media.SoundTransform;
        import flash.media.Video;
        import flash.net.NetConnection;
        import flash.net.NetStream;
        import flash.net.URLRequest;
        import flash.utils.clearTimeout;
        import flash.utils.setTimeout;
        
        //import org.osmf.events.PlayEvent;
        
        //import xems.ve.events.PlayerEvent;
        
        /**
         * ...
         * @author xdsnet
         */
        public class Flvmedia extends Sprite
        {
                private var _vid:Video; //用于显示视频
                private var _mainNc:NetConnection; //视频链接对象
                private var _mainStream:NetStream; //主要的视频流加载
                private var _vidStarFlag:Boolean = false;//视频是否开始播放
                private var _vol:uint = 70; //默认声音大小
                private var _isHttp:Boolean=true;
                private var _flvfile:String; //要播放的视频文件路径
                private var _vidinfo:Object; //视频信息集
                private var _mute:Boolean;
                private var seekInter:int=-1;
                
                // 控制用
                /** 最后定位的时间点对应字节流位置**/
                private var byteoffset:Number=0;
                /** 最后定位时间点**/
                private var timeoffset:Number=0;
                /** 在文件中的定位点. **/
                private var _position:Number;
                //** 声音控制 **/
                private var transformer:SoundTransform = new SoundTransform();
                //** 定位点 **/
                //private var position:Number;
                //** 状态值 **/
                private var _playState:uint;//播放状态指示器
                
                
                // 其他对象
                private var netclient:Object;//处理流控制的对象
				public var videoReady:Boolean=false;
        		public var seeking:Boolean=false;
				private var seekpoints:Array=null;
				
				private var isMP4:Boolean=false;
				private var _isComplete:Boolean=false;
				private var _playDelay:int=-1;
                public function Flvmedia() 
                {
                    super();
                    _vidinfo = new Object();                    
                    _mainNc = new NetConnection();
                    _mainNc.connect(null)
                    _mainStream = new NetStream(_mainNc);
					_mainStream.bufferTime=5;
                    netclient = new Object();
                    netclient.onMetaData = forMetaData;
                    netclient.onCuePoint = forCuePoint;
                    netclient.onPlayStatus = forNsStatus;
                    _mainStream.client = netclient;
					_mainStream.addEventListener(NetStatusEvent.NET_STATUS,onNetStateHandler);
					_mainNc.addEventListener(NetStatusEvent.NET_STATUS,onNetStateHandler);
                    _vid = new Video();
                    _vid.width = 200;
                    _vid.height = 150;
					
                    _vid.attachNetStream(_mainStream);
                    addChild(_vid);  
                }
				
				public function set isComplete(value:Boolean):void
				{
					_isComplete = value;
				}

				public function get isComplete():Boolean
				{
					return _isComplete;
				}

				protected function onNetStateHandler(event:NetStatusEvent):void
				{
					// TODO Auto-generated method stub
					var str:String=event.info.code;		
//					trace(str);
					if(isMP4==false){									
						if(str.indexOf(".Notify")>-1){		
							if(seeking&&seekInter==-1){
								seekInter=setTimeout(function():void{
									seeking=false;
									clearTimeout(seekInter);
									seekInter=-1;
								},50);
							}
							
							//this.dispatchEvent(new PlayerEvent(PlayerEvent.VIDEO_BUFFER_END,null));
						}else{	
							//this.dispatchEvent(new PlayerEvent(PlayerEvent.VIDEO_BUFFERING,null));
						}
					}else{
						if(event.info.code=="NetStream.SeekStart.Notify"){
							//this.dispatchEvent(new PlayerEvent(PlayerEvent.VIDEO_BUFFERING,null));
						}else if(event.info.code=="NetStream.Seek.Complete"||event.info.code=="NetStream.Play.Start"){
							seeking=false;
							//this.dispatchEvent(new PlayerEvent(PlayerEvent.VIDEO_BUFFER_END,null));
						}
					}
//					trace(event.info.code);
					if(str=="NetStream.Play.Stop"){
						_isComplete=true;
//						trace(str,'zz');
						//this.dispatchEvent(new PlayerEvent(PlayerEvent.VIDEO_COMPLETE,null));						
					}
					
				}
				public function load(url:String):void{
					_vidStarFlag=false;
					videoReady=false;
					stop();
					seekpoints=null;
					if(url.indexOf('.mp4')>-1){
						isMP4=true;
					}else{
						isMP4=false;
					}
					_flvfile=url;
					
					if(_playDelay==-1){
						seekInter=setTimeout(function():void{
							vidstar();
							clearTimeout(_playDelay);
							_playDelay=-1;
						},50);
					}					
				}
                
                //* 播放控制---开始--- */
                
                private function vidstar():void
                {
                    if (!_vidStarFlag) 
                    {
                        _mainStream.play(_flvfile);
                        setState(PlayerState.PLAYING);
                        _vidStarFlag = true;
						
                    }
                        
                }
                /** 播放暂停**/
                public function pause():void
                {
                    _mainStream.pause();
                    setState(PlayerState.PAUSED);
                }
                
                /****/
                public function stop():void
                {
//                    seek(0);
					clearTimeout(_playDelay);
					_playDelay=-1;
					
					clearTimeout(seekInter);
					seekInter=-1;
					_mainStream.close();
					_vid.clear();
                    pause();
                    setState(PlayerState.STOP);
                }
                /****/
                public function mute():void
                {
                    _vol = uint(_mainStream.soundTransform.volume * 100);
                    setVolume(0);
                }
                
                public function nomute():void
                {
                    setVolume(_vol);
                }
                
                /** 继续播放**/
                public  function play():void
                {
                    if (!_vidStarFlag)
                    {
                        vidstar();
                    }
                    else
                    {
                        _mainStream.resume();
                    }
                    setState(PlayerState.PLAYING);
                }

                /* 流定位功能实现 */
                public function seek(pos:Number):void
                {
					seeking=true;
					clearTimeout(seekInter);
					seekInter=-1;
					if(isMP4){
						timeoffset=0;
						mp4Seek(pos);
						return;
					}
					
					
                    if ( _isHttp && _vidinfo["httpstream"] ) //对在线http流的操作
                    {
                        var off:Number = getOffset(pos); //获取文件定位位置
						
                        if (off < byteoffset || off >= byteoffset + _mainStream.bytesLoaded)
                        { //如果不在缓冲范围内则需要新加载视频
                            timeoffset = _position = getOffset(pos, true);
                            byteoffset = off;
                            //处理重新加载操作
                            var str:String=loadPos();		
							trace(str,"加载文件定位位置",pos);
                        }
                        else
                        { //在缓冲范围内不进行加载，直接播放定位
                            if (_playState == PlayerState.PAUSED)
                            {
                                _mainStream.resume();
                            }
                            _position = pos;
							var pp:Number=getOffset(_position, true);
//                            _mainStream.seek(pos);
							_mainStream.seek(pp);
                            play();
							trace(pp,"关键帧位置定位",pos);
                        }
                    }
                    else
                    { //对 文件流、一般http访问的操作 
                        var bufferTime:Number = (_mainStream.bytesLoaded / _mainStream.bytesTotal) * _vidinfo.duration;
                        if (pos <= bufferTime)
                        {
                            _mainStream.seek(pos);
                            play();
                        }
                    }
                }
				
				private function mp4Seek(pos:Number):void
				{
					// TODO Auto Generated method stub
					if (_playState == PlayerState.PAUSED)
					{
						_mainStream.resume();
					}
					_position = pos;
//					timeoffset=getMp4Offset(_position, true);
//					var url:String = _flvfile;
//					var startparam:String = 'start';
//					if (timeoffset > 0)
//					{
//						url = getURLConcat(url, startparam, timeoffset);
//					}					
					var off:Number = getMp4Offset(pos,false); //获取文件定位位置					
					if (off < byteoffset || off >= byteoffset + _mainStream.bytesLoaded){
						timeoffset=getMp4Offset(_position, true);
						var url:String = _flvfile;
						var startparam:String = 'start';
						if (timeoffset > 0)
						{
							url = getURLConcat(url, startparam, timeoffset);
						}					
						byteoffset=off;
						_mainStream.play(url);
					}else{
						_mainStream.seek(_position);
						timeoffset=0;
						if(seeking&&seekInter==-1){
							seekInter=setTimeout(function():void{
								seeking=false;
								clearTimeout(seekInter);
								seekInter=-1;
							},50);
						}
					}
					
					setState(PlayerState.BUFFERING);
					_mute == true ? setVolume(0) : setVolume(_vol);
					trace(timeoffset,"关键帧位置定位",pos,url);
				}
				
                public function get duration():Number
                {
                    return _vidinfo.duration;
                }
                
                public function get time():Number
                {
					if(isMP4){
//						trace(_mainStream.time,timeoffset);
						return _mainStream.time+timeoffset;
					}else{
						return _mainStream.time;
					}
                    
                }
                
                public function get vol():uint
                {
                    return _vol;
                }
                
                public function set vol(invol:uint):void
                {
                    if (invol <= 100)
                    {
                        _vol = invol;
                    }
                    setVolume(_vol);
                }
                
                public function get state():uint
                {
                    return _playState;
                }
                
                public function setVolume(vol:uint):void
                { //设置声音大小
                    if (vol > 100)
                    {
                        vol = 100;
                    }
                    transformer.volume = vol / 100;
                    _mainStream.soundTransform = transformer;
                }

                /**  创建视频播放URL **/
                private function getURL():String
                {
                    var url:String = _flvfile;
                    var off:Number = byteoffset;
                    var startparam:String = 'start';
                    if (off > 0)
                    {
                        url = getURLConcat(url, startparam, off);
                    }
                    return url;
                }
                
                private function loadPos():String
                { //重新加载视频
                    _position = timeoffset;
                    if (_mainStream.bytesLoaded + byteoffset < _mainStream.bytesTotal)
                    {
                        _mainStream.close(); //如果定位点超出范围则停止
                    }
					var url:String=getURL();
                    _mainStream.play(url);
                    setState(PlayerState.BUFFERING);
                    _mute == true ? setVolume(0) : setVolume(_vol);
					return url;
                }

                private function setState(inState:uint):void
                { //设置相应状态
                    _playState = inState;
                }

                /** 为URL添加参数**/
                private function getURLConcat(url:String, prm:String, val:*):String
                {
                    if (url.indexOf('?') > -1)
                    {
                        return url + '&' + prm + '=' + val;
                    }
                    else
                    {
                        return url + '?' + prm + '=' + val;
                    }
                }

				private function getMp4Offset(pos:Number, tme:Boolean = false):Number{
					if (!seekpoints)
					{ //关键帧数据不存在时直接返回0
						return 0;
					}
					
					for (var i:Number = 0; i < seekpoints.length - 1; i++)
					{ //通过循环比较，定位最接近关键帧
						if (seekpoints[i].time <= pos && seekpoints[i + 1].time >= pos)
						{
							break;
						}
					}
					if (tme == true)
					{
						return seekpoints[i].time;
					}
					else
					{
						return seekpoints[i].offset;
					}
				}
                /*返回一个关键帧的字节流位置或者时间位置**/
                private function getOffset(pos:Number, tme:Boolean = false):Number
                { //tme为真时返回时间位置，否则返回数据流位置
                    if (!_vidinfo.keyframes)
                    { //关键帧数据不存在时直接返回0
                        return 0;
                    }
                    for (var i:Number = 0; i < _vidinfo.keyframes.times.length - 1; i++)
                    { //通过循环比较，定位最接近关键帧
                        if (_vidinfo.keyframes.times[i] <= pos && _vidinfo.keyframes.times[i + 1] >= pos)
                        {
                            break;
                        }
                    }
                    if (tme == true)
                    {
                        return _vidinfo.keyframes.times[i];
                    }
                    else
                    {
                        return _vidinfo.keyframes.filepositions[i];
                    }
                }
                
                private function _stop():void
                {
                    stop();
                }
                
                
                // 获取MetaDate后 触发调用函数
                private function forMetaData(data:Object):void //视频流加载onmeta触发动作，实现是否http流式环境监测
                {
                    _vidinfo.duration = data.duration;
                    _vidinfo.width = data.width;
                    _vidinfo.height = data.height;
                    if (data.keyframes)
                    {
                        _vidinfo["keyframes"] = data.keyframes;
                        _vidinfo["httpstream"] = true;
                    }
					if (data.seekpoints)
					{
						if(!seekpoints){
							seekpoints = data.seekpoints;
							_vidinfo["httpstream"] = true;
							trace("seekpoints");							
						}
//						for(var i:uint=0;i<data.seekpoints.length;i++){
//							trace(data.seekpoints[i].time,"xxx",data.seekpoints[i].offset);
//						}
					}
//					trace(data.keyframes.times);
//					for(var str in data.keyframes.times){
//						trace(str);
//					}
					
					//this.dispatchEvent(new PlayerEvent(PlayerEvent.VIDEO_READY,null));
					
					videoReady=true;
                }
                
                // 播放状态改变的处理
                private function forNsStatus(info:Object):void
                {
//					trace(info.code);
                    if (info.code == "NetStream.Play.Complete")
                    {
                        _stop();
                    }
//                    if (info.level.status=="NetStream.Play.Complete")
//                    {
//                        _stop();
//                    }
                }
                
                private function forCuePoint(info:Object):void // 视频流 CuePoint触发
                {
                    trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
                }
                
        }  
}
class PlayerState
{
	
	public static const IDLE:uint = 0x0;
	
	public static const BUFFERING:uint = 0x1;
	
	public static const PLAYING:uint = 0x2;
	
	public static const PAUSED:uint = 0x4;
	
	public static const STOP:uint = 0x8;
}