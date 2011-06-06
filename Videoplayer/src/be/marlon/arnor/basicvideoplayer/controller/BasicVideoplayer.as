//--------------------------------------------------------------------------
//
//  BasicVideoplayer.as
//
//  Extended class description & notes.
//
//  (c) 2011 - Marlon BVBA (arnor.dhaenens[at]marlon.be)
//
//--------------------------------------------------------------------------
package be.marlon.arnor.basicvideoplayer.controller
{
	//----------------------------------
	//  Import statements
	//----------------------------------
	import be.marlon.arnor.basicvideoplayer.events.FileEvent;
	import be.marlon.arnor.basicvideoplayer.events.HideControlsEvent;
	import be.marlon.arnor.basicvideoplayer.events.ModelEvent;
	import be.marlon.arnor.basicvideoplayer.events.SoundEvent;
	import be.marlon.arnor.basicvideoplayer.events.StreamingEvent;
	import be.marlon.arnor.basicvideoplayer.events.ViewEvent;
	import be.marlon.arnor.basicvideoplayer.model.HideControlsModel;
	import be.marlon.arnor.basicvideoplayer.model.Model;
	import be.marlon.arnor.basicvideoplayer.views.View;
	
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.media.StageVideo;
	
	
	//----------------------------------
	//  Class
	//----------------------------------
	
	/**
	 * Basic Video Player
	 * Stage project
	 * Basis video player dienend als basis voor alle mobiele apparaten
	 * Gericht naar Adobe AIR runtime
	 *
	 * @author charad (arnor.dhaenens[at]marlon.be)
	 * @since May 3, 2011
	 */
	public class BasicVideoplayer extends Sprite
	{
		//----------------------------------
		//  Properties
		//----------------------------------
		private var _model:Model;
		private var _hidecontrolsModel:HideControlsModel;
		private var _view:View;
		private var _activated:Boolean = false;
		
		private var _touch:Boolean;
		private var _fileBrowserNeeded:Boolean = false;
		private var _closeButtonNeeded:Boolean = false;
		private var _scaleControls:Boolean;
		private var _videoURL:String;

		private var _hasplayed:Boolean = false;
		
		//----------------------------------
		//  Getters & setters
		//----------------------------------
		public function get touch():Boolean
		{
			return _touch;
		}
		
		public function set touch(value:Boolean):void
		{
			_touch = value;
		}
		
		//----------------------------------
		//  Constructor
		//----------------------------------
		
		/**
		 * Constructor function.
		 */
		public function BasicVideoplayer(videoURL:String=null, fileBrowserNeeded:Boolean=false, closeButtonNeeded:Boolean=false, scaleControls:Boolean=true)
		{
			//INHERITANCE
			super();
			
			this._videoURL = videoURL;
			this._fileBrowserNeeded = fileBrowserNeeded;
			this._closeButtonNeeded = closeButtonNeeded;
			this._scaleControls = scaleControls;

			addEventListener(Event.ACTIVATE, handleApplicationActivate);
			//init();
		}
		
		//----------------------------------
		//  Public methods
		//----------------------------------
		
		/**
		 * Open a new video file after selecting it
		 * If a video has played, remove the Video Component
		 * If it hasn't, add new Video Component to the view
		 **/
		public function openNewVideo(url:String):void
		{
			this._videoURL = url;
			
			if(this._hasplayed)
				this._view.removeVideoComponent();
			else if(!this._hasplayed)
				this._view.newVideoComponent();
		}
		
		/**
		 * Add new Video Component to the view
		 **/
		public function newVideoComponent():void
		{
			this._view.newVideoComponent();
		}
		
		/**
		 * Remove video component from the view
		 **/
		public function removeVideoComponent():void
		{
			this._view.removeVideoComponent();
		}
		
		/**
		 * Handle change in stage orientation
		 **/
		public function handleOrientation():void
		{
			this._view.toggleFullScreen();
		}
		
		/**
		 * Toggle the controls
		 * Hide or show the controls
		 **/
		public function toggleControls():void
		{
			this._view.handleControlsVisability();
		}
		
		/**
		 * toggle screen
		 **/
		public function toggleScreen():void
		{
			this._view.toggleFullScreen();
		}
		
		/**
		 * Pause the video
		 **/
		public function pauseVideo():void
		{
			if(this._hasplayed)
				this._model.pauseVideo();
		}
		
		/**
		 * Resume the video
		 **/
		public function resumeVideo():void
		{
			if(this._hasplayed)
				this._model.resumeVideo();
		}
			
		
		//----------------------------------
		//  Private methods
		//----------------------------------
		/**
		 * Initialize the basic video player
		 * Adding Event Listeners to the view
		 * Adding Event Listeners to the model
		 **/
		public function init():void
		{
			_activated = true;
			dispatchEvent(new ViewEvent(ViewEvent.ACTIVATED));
			
			if(
				this._videoURL != null && 
				this._videoURL.replace(" ", "").length != 0
			)
			{
				if(this._hasplayed)
					this._view.removeVideoComponent();
				else if(!this._hasplayed)
					this._view.newVideoComponent();
			}
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//INITIALIZE MONSTER DEBUGGER
			//MonsterDebugger.initialize(this);
			
			setStageBasics();
			//setBackground();
			
			_view = new View(this._fileBrowserNeeded, this._closeButtonNeeded, this._scaleControls);			
			this.addChild(_view);
			
			_view.init();
			
			_view.addEventListener(ViewEvent.VIDEO_CREATED, handleVideoCreated);
			_view.addEventListener(ViewEvent.VIDEO_DELETED, handleVideoDeleted);
			
			_view.addEventListener(ViewEvent.FULL_SCREEN, handleFullScreenEvent);
			_view.addEventListener(ViewEvent.FULL_SCREEN_ESCAPE, handleEscapePress);
			
			_view.addEventListener(StreamingEvent.PLAY, handlePlay);
			_view.addEventListener(StreamingEvent.RESUME, handleResume);
			_view.addEventListener(StreamingEvent.PAUSE, handlePause);
			_view.addEventListener(StreamingEvent.STOP, handleStop);
			_view.addEventListener(StreamingEvent.REWIND, handleRewind);
			_view.addEventListener(StreamingEvent.THUMB_SLIDING, handleThumbSliding);
			_view.addEventListener(StreamingEvent.START_SLIDING, handleStartThumbSliding);
			_view.addEventListener(StreamingEvent.STOP_SLIDING, handleStopThumbSliding);
			_view.addEventListener(StreamingEvent.SLIDER_BACKGROUND_CLICKED, handleSliderBackgroundClicked);
			_view.addEventListener(SoundEvent.MUTE_CLICKED, handleMute);
			_view.addEventListener(SoundEvent.UNMUTE_CLICKED, handleUnMute);
			
			//create new model
			_model = new Model();
			
			_model.addEventListener(ModelEvent.DESTROYED_MODEL, handleModelDestroyed);			
			_model.addEventListener(ModelEvent.STARTED_PLAYING, handleStartedPlaying);
			_model.addEventListener(ModelEvent.PAUSED, handlePaused);
			_model.addEventListener(ModelEvent.RESUMED, handleResumed);
			_model.addEventListener(ModelEvent.REWINDED, handleRewinded);
			_model.addEventListener(ModelEvent.STOPPED, handleStopped);
			_model.addEventListener(ModelEvent.ENDED, handleVideoEnded);
			_model.addEventListener(ModelEvent.PROGRESS, handleProgress);
			_model.addEventListener(ModelEvent.MUTED_SOUND, handleMutedSound);
			_model.addEventListener(ModelEvent.UNMUTED_SOUND, handleUnmutedSound);
			
			_view.model = _model;
		}
		
		/**
		 * Set the basic elements of the stage
		 **/
		private function setStageBasics():void
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.displayState = StageDisplayState.NORMAL;
		}
		
		/**
		 * Set the background colour of the stage
		 **/
		private function setBackground():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x000000, 1);
			this.graphics.drawRect(0,0, this.stage.stageWidth, this.stage.stageHeight);
			
			this.graphics.endFill();
		}
		
		//----------------------------------
		//  Private event handlers
		//----------------------------------
		/**
		 * Executed when application is activated
		 * Check private variable _activated to look if video is already activated
		 * if not, execute init function
		 * 
		 * @see flash.events.Event
		 * 
		 **/
		public function handleApplicationActivate(evt:Event=null):void
		{
			if(!_activated)
			{
				removeEventListener(Event.ACTIVATE, handleApplicationActivate);
								
				//Initialize
				init();
				
				_activated = true;
				dispatchEvent(new ViewEvent(ViewEvent.ACTIVATED));
				
				if(
					this._videoURL != null && 
					this._videoURL.replace(" ", "").length != 0
				  )
				{
					if(this._hasplayed)
						this._view.removeVideoComponent();
					else if(!this._hasplayed)
						this._view.newVideoComponent();
				}
			}
		}
		
		/**
		 * Check if Stage Video is available
		 **/
		private function handleStageVideoAvailable(evt:StageVideoAvailabilityEvent):void
		{
			
		}
		
		/**
		 * When a new video component is created
		 * Create new NetConnection and NetStream Object
		 **/
		private function handleVideoCreated(evt:ViewEvent):void
		{
			evt.stopPropagation();
			
			if(this._hasplayed)
				this._model.destroy();
			else if(!this._hasplayed)
				this._model.loadNewVideo(this._videoURL, this._view.video, this._view.stageVideo);
		}
		
		/**
		 * When the old video component is deleted
		 * Create a new instance of the Video Object
		 * Add it to the view
		 **/
		private function handleVideoDeleted(evt:ViewEvent):void
		{
			evt.stopPropagation();
			this._view.newVideoComponent();
		}
		
		/**
		 * Handle Model Destroyed
		 **/
		private function handleModelDestroyed(evt:ModelEvent):void
		{
			evt.stopPropagation();
			this._model.loadNewVideo(this._videoURL, this._view.video, this._view.stageVideo);
		}
		
		/**
		 * Handle the enter and exit off fullscreen
		 * 
		 * @see be.marlon.arnor.videoplayer.events.ViewEvent
		 * @see be.marlon.arnor.videoplayer.events.VideoEvent
		 * 
		 **/
		private function handleFullScreenEvent(evt:ViewEvent):void
		{
			evt.stopPropagation();
			if(this.stage.displayState == StageDisplayState.NORMAL)
			{
				this.stage.displayState = StageDisplayState.FULL_SCREEN;
				dispatchEvent(new ViewEvent(ViewEvent.ENTER_FULL_SCREEN));
			}
			else if(this.stage.displayState == StageDisplayState.FULL_SCREEN)
			{
				this.stage.displayState = StageDisplayState.NORMAL;
				dispatchEvent(new ViewEvent(ViewEvent.EXIT_FULL_SCREEN));
			}
			
			_view.toggleFullScreen();
		}
		
		/**
		 * 
		 * Handling the pressing of escape
		 * Look if stage has a StageDisplayState of FullScreen
		 * if it does, set the stage to StageDisplayState.NORMAL
		 * and toglle the view fullscreen
		 * 
		 * @see be.marlon.arnor.videoplayer.events.ViewEvent
		 * 
		 **/
		private function handleEscapePress(evt:Event):void
		{
			evt.stopPropagation();
			_view.toggleFullScreen();	
		}
		
		/**
		 * Handle hide controls
		 **/
		private function handleHideControls(evt:HideControlsEvent):void
		{
			evt.stopPropagation();
			_view.hideControls();
			
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleShowControls);
		}
		
		/**
		 * Handle show controls
		 **/
		private function handleShowControls(evt:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleShowControls);
			
			this._hidecontrolsModel.resetTimer();
			this._view.showControls();
			
			trace("moving mouse");
		}
		
		/**
		 * Handle pressing the play button
		 **/
		private function handlePlay(evt:StreamingEvent):void
		{
			evt.stopPropagation();
			this._model.playVideo();
		}
		
		/**
		 * Handle pressing the resume button
		 **/
		private function handleResume(evt:StreamingEvent):void
		{
			evt.stopPropagation();
			this._model.resumeVideo();
		}
		
		/**
		 * Handle pressing the stop button
		 **/
		private function handleStop(evt:StreamingEvent):void
		{
			evt.stopPropagation();
			this._model.stopVideo();
		}
		
		/**
		 * Handle pressing the pause button
		 **/
		private function handlePause(evt:StreamingEvent):void
		{
			evt.stopPropagation();
			this._model.pauseVideo();
		}
		
		/**
		 * Handle pressing the rewind button
		 **/
		private function handleRewind(evt:StreamingEvent):void
		{
			evt.stopPropagation();
			this._model.rewindVideo();
		}
		
		/**
		 * Handle pressing the mute button
		 **/
		private function handleMute(evt:SoundEvent):void
		{
			this._model.muteSound();
		}
		
		/**
		 * Handle pressing unmute button
		 **/
		private function handleUnMute(evt:SoundEvent):void
		{
			this._model.unmuteSound();
		}
		
		/**
		 * Handle started loading the video
		 * Add a preloader to the stage 
		 * with an indication of loaded percentage
		 **/
		/*private function handleStartedLoadingVideo(evt:FileEvent):void
		{
			evt.stopPropagation();
			
			this.addEventListener(Event.ENTER_FRAME, handleEnterFramePreloader);
			this._view.addPreloader();
		}*/
		
		/**
		 * Handle the progress of the video loading
		 **/
		private function handleLoadingVideoProgress(evt:FileEvent):void
		{
			this._view.updatePreloader(evt.fileData);
		}
		
		/**
		 * Handle loading of the video complete
		 **/
		/*private function handleLoadingVideoComplete(evt:FileEvent):void
		{
			this.removeEventListener(Event.ENTER_FRAME, handleEnterFramePreloader);
			this._view.removePreloader();
		}*/
		
		/**
		 * Handle started playing of the video
		 **/
		private function handleStartedPlaying(evt:ModelEvent):void
		{
			this._hasplayed = true;
			
			this.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			evt.stopPropagation();
			this._view.startedPlaying();
		}
		
		/**
		 * Handle pausing video
		 **/
		private function handlePaused(evt:ModelEvent):void
		{
			evt.stopPropagation();
			this._view.paused();
		}
		
		/**
		 * Handle resumed
		 **/
		private function handleResumed(evt:ModelEvent):void
		{
			evt.stopPropagation();
			this._view.resumed();
		}
		
		/**
		 * Handle rewinded
		 **/
		private function handleRewinded(evt:ModelEvent):void
		{
			evt.stopPropagation();
			this._view.rewinded();
		}
		
		/**
		 * Handle stopped
		 **/
		private function handleStopped(evt:ModelEvent):void
		{
			evt.stopPropagation();
			this._view.stopped(evt.data);
			
			this.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		/**
		 * Handle Video Ended
		 **/
		private function handleVideoEnded(evt:ModelEvent):void
		{
			evt.stopPropagation();
			this._model.stopVideo();
		}
		
		/**
		 * Muted sound
		 **/
		private function handleMutedSound(evt:ModelEvent):void
		{
			evt.stopPropagation();
			this._view.mutedSound();
		}
		
		/**
		 * Unmuted Sound
		 **/
		private function handleUnmutedSound(evt:ModelEvent):void
		{
			evt.stopPropagation();
			this._view.unmutedSound();
		}
		
		/**
		 * Handle enter frame
		 * Used for updating the preloader
		 **/
		/*private function handleEnterFramePreloader(evt:Event):void
		{
			//this._model.updateLoadedPercentage();
		}*/
		
		/**
		 * Handle Enter Frame
		 * Used for updating time
		 **/
		private function handleEnterFrame(evt:Event):void
		{
			this._model.updateTime();
		}
		
		/**
		 * Handle video progress
		 **/
		private function handleProgress(evt:ModelEvent):void
		{
			this._view.videoProgress(evt.data);
		}
		
		/**
		 * Handle the start of the sliding of the thumb
		 **/
		private function handleStartThumbSliding(evt:StreamingEvent):void
		{
			this._model.muteSoundWhileSliding();
		}
		
		/**
		 * Handle the sliding of the thumb button
		 **/
		private function handleThumbSliding(evt:StreamingEvent):void
		{
			this._model.updateVideoPosition(evt.data);
		}
		
		/**
		 * Handle stopping of sliding the thumb
		 **/
		private function handleStopThumbSliding(evt:StreamingEvent):void
		{
			this._model.unmuteSoundAfterSliding();
		}
		
		/**
		 * Handle the clicking of the slider background
		 **/
		private function handleSliderBackgroundClicked(evt:StreamingEvent):void
		{
			evt.stopPropagation();
			this._model.gotoPosition(evt.data);
		}
		
	}
}