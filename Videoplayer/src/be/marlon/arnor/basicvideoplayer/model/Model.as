//--------------------------------------------------------------------------
//
//  Model.as
//
//  Extended class description & notes.
//
//  (c) 2011 - Marlon BVBA (arnor.dhaenens[at]marlon.be)
//
//--------------------------------------------------------------------------
package be.marlon.arnor.basicvideoplayer.model
{
	//----------------------------------
	//  Import statements
	//----------------------------------
	import be.marlon.arnor.basicvideoplayer.events.FileEvent;
	import be.marlon.arnor.basicvideoplayer.events.ModelEvent;
	import be.marlon.arnor.basicvideoplayer.events.SoundEvent;
	import be.marlon.arnor.basicvideoplayer.events.StreamingEvent;
	import be.marlon.arnor.basicvideoplayer.model.data.FileData;
	import be.marlon.arnor.basicvideoplayer.model.data.VideoData;
	
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.media.SoundTransform;
	import flash.media.StageVideo;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	
	//----------------------------------
	//  Class
	//----------------------------------
	/**
	 * Model.as
	 * 
	 * Model class voor de video component
	 * 
	 * @author D'Haenens Arnor - 2011 
	 * @see flash.events.EventDispatcher
	 * @since May 2, 2011
	 **/
	public class Model extends EventDispatcher
	{
		//----------------------------------
		//  Properties
		//----------------------------------
		private var _stVideo:StageVideo;
		private var _video:Video;
		private var _videoURL:String;
		private var _ns:NetStream;
		private var _nt:NetConnection;
		private var _prevStatus:String;
		
		private var _duration:Number;
		private var _hVideo:int;
		private var _wVideo:int;
		
		private var _sTransform:SoundTransform;
				
		//----------------------------------
		//  Getters and setters
		//----------------------------------		
		public function get duration():Number
		{
			return _duration;
		}
		
		public function get hVideo():int
		{
			return _hVideo;
		}
		
		public function get wVideo():int
		{
			return _wVideo;
		}
		
		
		//----------------------------------
		//  Constructor
		//----------------------------------
		/**
		 * CONSTRUCTOR
		 **/
		public function Model()
		{
			//INHERITANCE
			super();
			
			//initialize
			//init();
		}
		
		
		//----------------------------------
		//  Public functions
		//----------------------------------
		/**
		 * Function destroy
		 * 
		 * Clears the NetConnection and NetStream Object
		 **/
		public function destroy():void
		{
			this._ns.close();
			_nt.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			_nt.removeEventListener(NetStatusEvent.NET_STATUS, handleNetStatus);
			this._nt = null;
			
			_ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, handleAsyncError);
			_ns.removeEventListener(NetStatusEvent.NET_STATUS, handleNetStatus);
			_ns.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			this._ns = null;
			
			this._sTransform = null;
			
			//this._video = null;
			this._videoURL = null;
			
			//this._stVideo = null;
			
			dispatchEvent(new ModelEvent(ModelEvent.DESTROYED_MODEL));
		}
		
		
		/**
		 * Play video from a given URL
		 **/
		public function loadNewVideo(url:String, video:Video, stageVideo:StageVideo):void
		{
			//video
			this._videoURL = url;
			this._video = video;
			
			//stageVideo
			//this._stVideo = stageVideo;
			
			createNewNetconnection();
		}
		
		/**
		 * Play current video if stopped
		 **/
		public function playVideo():void
		{
			this._ns.play(this._videoURL);
			
			dispatchEvent(new ModelEvent(ModelEvent.STARTED_PLAYING));
		}
		
		/**
		 * Pause the video
		 **/
		public function pauseVideo():void
		{
			try
			{
				this._ns.pause();
				dispatchEvent(new ModelEvent(ModelEvent.PAUSED));
			}
			catch(e:Error)
			{
				MonsterDebugger.trace(this, e.message);
			}
		}
		
		/**
		 * Resume video
		 **/
		public function resumeVideo():void
		{
			try
			{
				this._ns.resume();
				dispatchEvent(new ModelEvent(ModelEvent.RESUMED));
			}
			catch(e:Error)
			{
				MonsterDebugger.trace(this, e.message);
			}
		}
		
		/**
		 * Rewind video
		 **/
		public function rewindVideo():void
		{
			try
			{
				this._ns.seek(0);
				this._ns.resume();
				dispatchEvent(new ModelEvent(ModelEvent.REWINDED));
			}
			catch(e:Error)
			{
				MonsterDebugger.trace(this, e.message);
			}
		}
		
		/**
		 * Stop video
		 **/
		public function stopVideo():void
		{
			try
			{
				//close the NetStream object
				this._ns.close();
				
				//clear the video screen
				this._video.clear();
				
				var videoData:VideoData = new VideoData();
				videoData.strTimeToCome = this.calculateTime(this.duration - this._ns.time);
				videoData.strTimePast = this.calculateTime(this._ns.time);
				
				dispatchEvent(new ModelEvent(ModelEvent.STOPPED, videoData));
			}
			catch(e:Error)
			{
				MonsterDebugger.trace(this, e.message);
			}
		}
		
		public function muteSound():void
		{
			this._sTransform = new SoundTransform(0);
			this._ns.soundTransform = this._sTransform;
			
			dispatchEvent(new ModelEvent(ModelEvent.MUTED_SOUND));
		}
		
		public function unmuteSound():void
		{
			this._sTransform = new SoundTransform(1);
			this._ns.soundTransform = this._sTransform;
			dispatchEvent(new ModelEvent(ModelEvent.UNMUTED_SOUND));
		}
		
		/**
		 * Handle Enter frame
		 * Use it for updating past time and time to come
		 **/
		public function updateTime():void
		{
			var videoData:VideoData = new VideoData();
			
			videoData.strTimePast = calculateTime(this._ns.time);
			videoData.strTimeToCome = calculateTime(this._duration - this._ns.time);
			videoData.duration = this.duration;
			videoData.pastTime = this._ns.time;
			
			dispatchEvent(new ModelEvent(ModelEvent.PROGRESS, videoData));
		}
		
		/**
		 * Mute sound while user is sliding
		 **/
		public function muteSoundWhileSliding():void
		{
			this._sTransform = new SoundTransform(0);
			this._ns.soundTransform = this._sTransform;
		}
		
		/**
		 * Update video position
		 **/
		public function updateVideoPosition(timeData:*):void
		{
			this._ns.seek(this.duration * (timeData/100));
			//this._ns.resume();
		}
		
		/**
		 * Unmute the sound when user is done sliding
		 **/
		public function unmuteSoundAfterSliding():void
		{
			this._sTransform = new SoundTransform(1);
			this._ns.soundTransform = this._sTransform;
		}
		
		/**
		 * Go to position in movie
		 * Dependent on the clicking on slider background
		 **/
		public function gotoPosition(data:*):void
		{
			var perc:Number = data.mouseXSlider * (1/data.widthSlider);
			var position:Number = this._duration * perc;
			
			this._ns.seek(position);			
		}
		
		//----------------------------------
		//  Private functions
		//----------------------------------
		
		/**
		 * Private functions
		 **/
		private function init():void
		{
			createNewNetconnection();
		}
		
		/**
		 * Create new NetConnection
		 **/
		private function createNewNetconnection():void
		{
			//create new instance of netconnection
			_nt = new NetConnection();
			_nt.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			_nt.addEventListener(NetStatusEvent.NET_STATUS, handleNetStatus);
			_nt.connect(null);
		}
		
		/**
		 * Create new NetStream
		 **/
		private function createNewNetStream():void
		{
			
		}
		
		/**
		 * Connect to the video component
		 **/
		private function connectVideo():void
		{
			this._ns = new NetStream(_nt);
			this._ns.inBufferSeek = true;
			this._ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, handleAsyncError);
			this._ns.addEventListener(NetStatusEvent.NET_STATUS, handleNetStatus);
			this._ns.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			
			/*this._sTransform = new SoundTransform();
			this._ns.soundTransform = this._sTransform;*/
			
			//video
			this._video.attachNetStream(this._ns);
			
			//stageVideo
			//this._stVideo.attachNetStream(this._ns);
			
			var customClient:Object = new Object();
			customClient.onMetaData = metaHandler;
			
			this._ns.client = customClient;
			
			this._ns.play(this._videoURL);
			
			dispatchEvent(new FileEvent(FileEvent.FILE_BEGIN_LOADING));
		}
		
		//----------------------------------
		//  Private event handlers
		//----------------------------------
		
		/**
		 * Handle Security Error Event
		 * @see flash.events.SecurityErrorEvent
		 **/
		private function handleSecurityError(evt:SecurityErrorEvent):void
		{
			trace("SecurityErrorEvent: " + evt.text);
		}
		
		/**
		 * Handle Async Error Event
		 * @see flash.events.AsyncErrorEvent
		 **/
		private function handleAsyncError(evt:AsyncErrorEvent):void
		{
			trace("AsyncError: " + evt.text);
		}
		
		/**
		 * Handle the netstatus event
		 * @see flash.events.NetStatusEvent
		 **/
		private function handleNetStatus(evt:NetStatusEvent):void
		{
			switch(evt.info.code)
			{
				case "NetConnection.Connect.Success":
					connectVideo();
					break;
				
				case "NetStream.Play.StreamNotFound":
					trace("can't locate video");
					break;
				
				case "NetStream.Play.Stop":
					/*if(this._prevStatus == "NetStream.Buffer.Stop")
					{
						dispatchEvent(new ModelEvent(ModelEvent.ENDED));
					}*/
					dispatchEvent(new ModelEvent(ModelEvent.ENDED));
					break;
			}
			
			this._prevStatus = evt.info.code;
			trace(this._prevStatus);
		}
		
		/**
		 * When an input or output operation fails
		 * @ see flash.events.IOErrorEvent
		 **/
		private function handleIOError(evt:IOErrorEvent):void
		{
			trace("io error: " + evt.text);
		}
		
		/**
		 * Loading the metadata of the movie
		 **/
		private function metaHandler(infoObject:Object):void
		{
			dispatchEvent(new FileEvent(FileEvent.FILE_LOADING_COMPLETE));
			
			this._duration = infoObject.duration;
			this._hVideo = infoObject.height;
			this._wVideo = infoObject.width;
			
			this._video.width = this._wVideo;
			this._video.height = this._hVideo;
			
			dispatchEvent(new ModelEvent(ModelEvent.STARTED_PLAYING));
		}
		
		/**
		 * Function used for calculating the time
		 * @return String
		 **/
		private function calculateTime(_time:Number):String
		{
			var minutes:Number = Math.floor(_time/60);
			var seconds:Number = Math.floor(_time%60);
			
			//IF MINUTES < 2
			//ADD ZERO IN FRONT
			var m_string:String = minutes.toString();
			if(m_string.length < 2)
				m_string = "0" + m_string;
			
			//IF SECONDS IS < 2
			//ADD 0 IN FRONT
			var s_string:String = seconds.toString();
			if(s_string.length < 2)
				s_string = "0" + s_string;
			
			//RETURN THE CALCULATED STRING
			return m_string + ":" + s_string;
		}
	}
}