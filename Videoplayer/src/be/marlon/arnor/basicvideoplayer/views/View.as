/**
 * VIEW CLASS
 * 
 * USED FOR UPDATING STAGE ELEMENT(S)
 **/
package be.marlon.arnor.basicvideoplayer.views
{
	/**
	 * IMPORTS
	 **/	
	
	import be.marlon.arnor.basicvideoplayer.events.HideControlsEvent;
	import be.marlon.arnor.basicvideoplayer.events.ModelEvent;
	import be.marlon.arnor.basicvideoplayer.events.ViewEvent;
	import be.marlon.arnor.basicvideoplayer.model.Model;
	import be.marlon.arnor.basicvideoplayer.model.data.FileData;
	import be.marlon.arnor.basicvideoplayer.model.data.VideoData;
	import be.marlon.arnor.basicvideoplayer.views.components.BottomControlsComponent;
	import be.marlon.arnor.basicvideoplayer.views.components.LargeFileBrowserComponent;
	import be.marlon.arnor.basicvideoplayer.views.components.PreloaderComponent;
	import be.marlon.arnor.basicvideoplayer.views.components.TopControlsComponent;
	
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.StageVideoEvent;
	import flash.geom.Rectangle;
	import flash.media.StageVideo;
	import flash.media.Video;
	import flash.ui.Mouse;
	
	/**
	 * View.as
	 * 
	 * @author D'Haenens Arnor
	 * @since May 2, 2011
	 * @see flash.display.Sprite
	 **/
	public class View extends Sprite
	{
		//----------------------------------
		//  Properties
		//----------------------------------
		private var _model:Model;
		private var _video:Video;
		private var _stageVideo:StageVideo;
		private var _hasPlayed:Boolean = false;
		private var _needfilebrowser:Boolean;
		private var _needCloseButton:Boolean;
		private var _controlsVisible:Boolean = true;
		private var _scaleControls:Boolean;
		
		//----------------------------------
		//  Components
		//----------------------------------
		private var _bottomcontrols:BottomControlsComponent;
		private var _topControls:TopControlsComponent;
		private var _largeFileOpener:LargeFileBrowserComponent;
		private var _preloader:PreloaderComponent;
		
		//----------------------------------
		//  Getters and setters
		//----------------------------------
		public function get video():Video
		{
			return _video;
		}
		
		/*public function set video(value:Video):void
		{
			_video = value;
		}*/
		
		public function get stageVideo():StageVideo
		{
			return _stageVideo;
		}
		
		public function set stageVideo(value:StageVideo):void
		{
			_stageVideo = value;
		}
		
		public function get model():Model
		{
			return _model;
		}
		
		public function set model(value:Model):void
		{
			_model = value;
		}
		
		//----------------------------------
		//  Constructor
		//----------------------------------
		
		/**
		 * CONSTRUCTOR
		 **/
		public function View(_needBrowser:Boolean, _needClose:Boolean, scaleControls:Boolean)
		{
			//INHERITANCE
			super();
			
			this._needfilebrowser = _needBrowser;
			this._needCloseButton = _needClose;
			this._scaleControls = scaleControls;
		}
		
		
		
		//----------------------------------
		//  Private methods
		//----------------------------------
		
		/**
		 * Initialise the view
		 **/
		public function init():void
		{			
			//Adding the bottom controls to the stage			
			_bottomcontrols = new BottomControlsComponent(this.stage.stageWidth, this.stage.stageHeight, this._scaleControls);
			this.addChild(_bottomcontrols);
						
			//Adding the topControls to the stage
			_topControls = new TopControlsComponent(this.stage.stageWidth, this.stage.stageHeight, this._needfilebrowser, this._needCloseButton);
			this.addChild(_topControls);
			
			//Add filebrowser to the stage 
			/*if(_needfilebrowser)
			{
				_largeFileOpener = new LargeFileBrowserComponent(this.stage.stageWidth, this.stage.stageHeight, this._needfilebrowser);
				this.addChild(_largeFileOpener);
			}*/
			
			//Listen to key board events
			this.stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyBoard);
		}
		
		/**
		 * Toggle Stage Fullscreen
		 **/
		public function toggleFullScreen():void
		{			
			//redraw the stage background
			redrawBackground();
			
			//reposition the controls
			_bottomcontrols.handleStageChange(this.stage.stageWidth, this.stage.stageHeight, this.stage.displayState);
			_topControls.handleStageChange(this.stage.stageWidth, this.stage.stageHeight);
			
			if(_needfilebrowser)
			{
				
			}
			
			//rescaling video component
			//adjust position to the stage
			if(this._video)
			{
				if(_model.wVideo > _model.hVideo)
				{
					_video.height = _video.height * (this.stage.stageWidth / _video.width);
					_video.width = this.stage.stageWidth;
				}
				else if(_model.wVideo < model.hVideo)
				{
					_video.width = _video.width * (this.stage.stageHeight / _video.height);
					_video.height = this.stage.stageHeight;
				}
				
				//adjusting position 
				_video.x = (this.stage.stageWidth - _video.width) * .5;
				_video.y = (this.stage.stageHeight - _video.height) * .5;
				
			}
			
			
			if(this._preloader)
			{
				this._preloader.handleStageResize(this.stage.stageWidth, this.stage.stageHeight);
			}
		}
		
		/**
		 * Hiding the controls of the videoplayer
		 * 
		 * Hide the topcontrols
		 * Hide the bottom controls
		 * Hide the large file browser if needed
		 * 
		 **/
		public function hideControls():void
		{
			_topControls.hideTopControls();
			_bottomcontrols.hideBottomControls(this.stage.stageHeight);
			
			//hide the mouse
			Mouse.hide();
		}
		
		/**
		 * Show the controls of the videoplayer
		 * 
		 * Show the topcontrols
		 * Show the bottom controls
		 * Show the large file browser if needed
		 * 
		 **/
		public function showControls():void
		{
			_topControls.showTopControls();
			_bottomcontrols.showBottomControls(this.stage.stageHeight);
			
			//show the mouse
			Mouse.show();
		}
		
		/**
		 * Add preloader on stage while loading the video
		 **/
		public function addPreloader():void
		{
			this._preloader = new PreloaderComponent(this.stage.stageWidth, this.stage.stageHeight);
			this._preloader.addEventListener(ViewEvent.REMOVE_OBJECT, handleRemoveObject);
			
			this.addChild(this._preloader);
		}
		
		/**
		 * Update preloader
		 **/
		public function updatePreloader(fileData:FileData):void
		{
			this._preloader.updatePreloader(fileData);
		}
		
		/**
		 * Remove preloader from stage
		 **/
		public function removePreloader():void
		{
			if(this._preloader)
				this._preloader.hidePreloader();
		}
		
		/**
		 * Started playing
		 **/
		public function startedPlaying():void
		{
			toggleFullScreen();
			this._bottomcontrols.handleStartedPlaying();
		}
		
		/**
		 * Paused video
		 **/
		public function paused():void
		{
			this._bottomcontrols.handlePaused();
		}
		
		/**
		 * Resumed video
		 **/
		public function resumed():void
		{
			this._bottomcontrols.handleResumed();
		}
		
		/**
		 * Rewinded the video
		 **/
		public function rewinded():void
		{
			this._bottomcontrols.handleRewinded();
		}
		
		/**
		 * Stopped the video
		 **/
		public function stopped(videoData:VideoData):void
		{
			this._bottomcontrols.handleStopped(videoData);
		}
		
		/**
		 * Muted sound
		 **/
		public function mutedSound():void
		{
			this._bottomcontrols.handleMutedSound();
		}
		
		/**
		 * Unmuted sound
		 **/
		public function unmutedSound():void
		{
			this._bottomcontrols.handleUnmutedSound();
		}
		
		/**
		 * Progress
		 **/
		public function videoProgress(timeData:*):void
		{
			this._bottomcontrols.handleProgress(timeData);
		}

		
		/**
		 * Hiding or showing the controls
		 **/
		public function handleControlsVisability():void
		{
			if(this._controlsVisible == true)
			{
				this._controlsVisible = false;
				this._bottomcontrols.hideBottomControls(this.stage.stageHeight);
				this._topControls.hideTopControls();
			}
			else if(this._controlsVisible == false)
			{
				this._controlsVisible = true;
				this._bottomcontrols.showBottomControls(this.stage.stageHeight);
				this._topControls.showTopControls();
			}
		}
		
		/**
		 * Create new video component
		 **/
		public function newVideoComponent():void
		{
			//general video
			this._video = new Video();
			this._video.x = this.video.y = 0;
			this.addChildAt(this._video, 0);
			
			//stage video
			/*this._stageVideo = new StageVideo();
			this._stageVideo.addEventListener(StageVideoEvent.RENDER_STATE, handleStageVideoRender);
			this.stage.stageVideos.push(this._stageVideo);	*/		
			
			dispatchEvent(new ViewEvent(ViewEvent.VIDEO_CREATED));
		}
		
		/**
		 * Remove the video component
		 **/
		public function removeVideoComponent():void
		{
			//remove video
			this.removeChild(this._video);
			this._video = null;
			
			//remove stage video
			//this.stage.stageVideos[0] = null;
			dispatchEvent(new ViewEvent(ViewEvent.VIDEO_DELETED));
		}
		
		
		
		/**
		 * Redraw the background so it fits the stage
		 **/
		private function redrawBackground():void
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
		* Handles clicking on the video object
		 * @param event:MouseEvent
		 */
		private function videoClickHandler(event:MouseEvent):void
		{
			event.stopPropagation();
			
			trace("clicked on: " + event.target);
		}
		
		/**
		 * Handling the stage resize
		 * @see be.marlon.arnor.videoplayer.events.ViewEvent
		 **/
		private function handleStageResize(evt:MouseEvent):void
		{
			dispatchEvent(new ViewEvent(ViewEvent.FULL_SCREEN));
		}
		
		/**
		 * Handling KeyBoard Pressing
		 * @see flash.events.KeyBoardEvent
		 **/
		private function handleKeyBoard(evt:KeyboardEvent):void
		{
			switch(evt.charCode)
			{
				//Pressed escape
				case 27:
					dispatchEvent(new ViewEvent(ViewEvent.FULL_SCREEN_ESCAPE));
					break;
				
				//Pressed spacebar
				case 32:
					break;
				
			}
			
			MonsterDebugger.trace(this, evt.charCode);
		}
		
		/**
		 * Handle the large file opener
		 **/
		private function handleLargeFileOpener(evt:MouseEvent):void
		{
			dispatchEvent(new ViewEvent(ViewEvent.BROWSE_FOR_FILE));
		}
		
		/**
		 * Handle the clicking of the close button
		 **/
		private function handleCloseButton(evt:MouseEvent):void
		{
			dispatchEvent(new ViewEvent(ViewEvent.CLOSE_APPLICATION));
		}
		
		/**
		 * Handle the movement of the mouse
		 **/
		private function handleMouseMovement(evt:MouseEvent):void
		{
			dispatchEvent(new HideControlsEvent(HideControlsEvent.SHOW_CONTROLS));
		}
		
		/**
		 * Remove an object from the view if requested
		 **/
		private function handleRemoveObject(evt:ViewEvent):void
		{
			this.removeChild(this._preloader);
			this._preloader = null;
		}

	}
}