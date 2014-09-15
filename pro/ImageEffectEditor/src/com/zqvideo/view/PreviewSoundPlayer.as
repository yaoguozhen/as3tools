package  com.zqvideo.view
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.as3wavsound.WavSound;
	import org.as3wavsound.WavSoundChannel;
	
	public class PreviewSoundPlayer extends EventDispatcher
	{
		public var totalTime:Number;
		public var soundURL:String;
		
		private var _lastTime:Number = 0;
		
		private var _sound:Sound;
		private var _channel:SoundChannel;
		
		private static var _instance:PreviewSoundPlayer;
		private var _lightContainer:Sprite;
		
		private var wavSound:WavSound=null;
		private var wavChannel:WavSoundChannel=null;
		private var isByteSound:Boolean=false;
		private var wav:ByteArray=null;
		
		private var _playCompleted:Boolean = false;
		private var _vol:Number=1;
		private var isMute:Boolean=false;
		private var msk:Shape;
		public function PreviewSoundPlayer()
		{
			super();
			if(_instance){
				throw new Error("单例对象");
			}
			_instance = this;
		}
		private function setVolume(v:Number):void
		{
			// TODO Auto Generated method stub
			msk.scaleX=v;
			_vol=v;
			
			if(isByteSound==false){
				_channel.soundTransform=new SoundTransform(_vol);
			}else{				
				wavChannel.soundTransform.volume=_vol;
//				trace(">>>wavChannel.soundTransform.volume："+_vol);
			}
		}
		
		/**
		 *播放数据流 
		 * @param bytes
		 * 
		 */
		public function playBytes(bytes:ByteArray):void{
			isByteSound=true;	
			_playCompleted=false;
			wav=bytes;
			stopWav();
			playWav();
			
		}
		
		private function playWav():void
		{
			// TODO Auto Generated method stub
			wavSound=new WavSound(wav);
			wavChannel=wavSound.play();
			if(isMute){
				wavChannel.soundTransform.volume=0;
			}else{
				wavChannel.soundTransform.volume=_vol;
			}
			
			wavChannel.addEventListener(Event.SOUND_COMPLETE, onWavPlayCompleteHandler)
		}
		
		private function stopWav():void
		{
			// TODO Auto Generated method stub
			if(wavChannel){
				wavChannel.stop();
				wavChannel.removeEventListener(Event.SOUND_COMPLETE, onWavPlayCompleteHandler)
			}
			if(wavSound){
				wavSound=null;
			}
		}
		
		/**
		 *流播放器播放完成 
		 * @param event
		 * 
		 */
		protected function onWavPlayCompleteHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			_playCompleted = true;
			stopWav();
		}

		private function onProgress(event:ProgressEvent):void
		{
			
		}

		private function onIoError(event:IOErrorEvent):void
		{
			trace(event.text);
		}
		public function play(url:String=null):void
		{
			isByteSound=false;
			stop();
			if(url != null){
				soundURL=url;
				if(_sound){
					try{
						_sound.close();
					}catch(e:IOError){
						
					}
					_sound.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
					_sound.removeEventListener(ProgressEvent.PROGRESS, onProgress);
					_sound.removeEventListener(Event.OPEN,onLoadMusicOpenHandler);
					_sound = null;
				}
				
				_sound = new Sound();
				_sound.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
				_sound.addEventListener(ProgressEvent.PROGRESS, onProgress);
				_sound.addEventListener(Event.OPEN,onLoadMusicOpenHandler);
				
				
				
				_sound.load(new URLRequest(url));
				_lastTime = 0;
				
				
				
			}
			_channel = _sound.play(_lastTime);
			if(isMute){
				_channel.soundTransform=new SoundTransform(0);
			}else{
				_channel.soundTransform=new SoundTransform(_vol);
			}
			
			_channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			_playCompleted = false;
		}
		
		protected function onLoadMusicOpenHandler(event:Event):void
		{
			// TODO Auto-generated method stub
//			trace(_sound.length,"aaaa");
		}
		
		public function stop():void
		{
			if(_channel){
				_lastTime = _channel.position;
				_channel.stop();
				_channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
				_channel=null;
			}
		}
		
		public function close(type:String = null):void
		{
			if(isByteSound){
				stopWav();
				isByteSound=false;
			}else{
				stop();			
				if(_sound){
					try{
						_sound.close();
					}catch(e:IOError){
						
					}
				}
				
				_channel = null;
			}			
			_lastTime = 0;
			
			_vol=1;
			isMute=false;
			
		}

		private function onSoundComplete(event:Event):void
		{
			_playCompleted = true;
			stop();
			_lastTime = 0;
			trace("播放完毕");
			dispatchEvent(new Event("soundPlayComplete"));
		}

		public static function get instance():PreviewSoundPlayer
		{
			if(!_instance){
				_instance = new PreviewSoundPlayer();
			}
			
			return _instance;
		}

	}
}