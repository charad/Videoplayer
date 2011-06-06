//--------------------------------------------------------------------------
//
//  BottomControlsComponent.as
//
//  Extended class description & notes.
//
//  (c) 2011 - Marlon BVBA (arnor.dhaenens[at]marlon.be)
//
//--------------------------------------------------------------------------
package be.marlon.arnor.basicvideoplayer.views.components
{
	import be.marlon.arnor.basicvideoplayer.events.SoundEvent;
	import be.marlon.arnor.basicvideoplayer.events.StreamingEvent;
	import be.marlon.arnor.basicvideoplayer.events.ViewEvent;
	import be.marlon.arnor.basicvideoplayer.model.data.VideoData;
	
	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.TweenLite;
	
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	//----------------------------------
	//  Import statements
	//----------------------------------
	
	
	
	//----------------------------------
	//  Class
	//----------------------------------
	
	/**
	 * Class description.
	 *
	 * @author charad (arnor.dhaenens[at]marlon.be)
	 * @since May 3, 2011
	 */
	public class BottomControlsComponent extends ContainerMC
	{
		//----------------------------------
		//  Properties
		//----------------------------------
		private var _thumbUpdate:Boolean = true;
		private var _scaleControls:Boolean;
		
		
		//----------------------------------
		//  Getters & setters
		//----------------------------------
		
		
		
		//----------------------------------
		//  Constructor
		//----------------------------------
		
		/**
		 * Constructor function.
		 */
		public function BottomControlsComponent(_stWidth:int, _stHeight:int, scaleControls:Boolean=true)
		{
			super();
			
			init();
			
			this._scaleControls = scaleControls;
			
			//this.scaleX = this.scaleY = 2;
			
			if(this._scaleControls)
			{
				this.height = this.height * ((_stWidth - 60) / this.width);
				this.width = _stWidth - 60;
			}
			
			
			//set the position of the bottom controls
			this.x = (_stWidth - this.width) * .5;
			this.y = _stHeight - this.height - 20;
			
			//add event listeners
			this.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOverControls);
			this.addEventListener(MouseEvent.MOUSE_OUT, handleMouseOutControls);
			
			
		}
		
		//----------------------------------
		//  Public methods
		//----------------------------------
		/**
		 * Reposition the controls after resizing the application
		 * Set the fullscreen buttons dep. of the stage display state 
		 **/
		public function handleStageChange(_stWidth:int, _stHeight:int, _stagedisplay:String):void
		{
			resize(_stWidth);
			
			//set the position of the bottom controls			
			TweenLite.to(this, 0, {x:((_stWidth - this.width) * .5), y:(_stHeight - this.height - 20)});
			
			//set the fullscreen buttons dep. of the stage display state
			switch(_stagedisplay)
			{
				case StageDisplayState.FULL_SCREEN:
					this.btnMaximize.visible = false;
					this.btnRestore.visible = true;
					break;
				
				case StageDisplayState.FULL_SCREEN_INTERACTIVE:
					this.btnMaximize.visible = false;
					this.btnRestore.visible = true;
					break;
				
				case StageDisplayState.NORMAL:
					this.btnMaximize.visible = true;
					this.btnRestore.visible = false;
					break;
			}
		}
		
		/**
		 * Hide the bottom controls
		 **/
		public function hideBottomControls(_stHeight:int):void
		{
			TweenLite.killTweensOf(this);
			
			TweenLite.to(this, 0.5, {y:(_stHeight + this.height), alpha:0});
		}
		
		/**
		 * Show the bottom controls
		 **/
		public function showBottomControls(_stHeight:int):void
		{
			TweenLite.killTweensOf(this);
			
			TweenLite.to(this, 0.5, {y:(_stHeight - this.height - 20), alpha:1});
		}
		
		/**
		 * Handle started playing
		 **/
		public function handleStartedPlaying():void
		{			
			this.btnPlay.visible = false;
			this.btnPlay.enabled = true;
			
			this.btnPause.visible = true;
			
			this.btnReturn.enabled = true;
			this.btnStop.enabled = true;
			
			this.btnSound.enabled = true;
			this.btnMute.enabled = false;
			this.btnSound.addEventListener(MouseEvent.CLICK, handleSoundClicked);
			this.btnMute.addEventListener(MouseEvent.CLICK, handleMuteClicked);
			
			this.slider.btnThumb.enabled = true;
			
			this.slider.btnThumb.addEventListener(MouseEvent.MOUSE_DOWN, handleThumbDrag);
			this.slider.btnThumb.addEventListener(MouseEvent.MOUSE_UP, handleThumbStopDrag);
			this.addEventListener(MouseEvent.MOUSE_OUT, handleThumbStopDrag);
			
			this.slider.background.enabled = true;
			this.slider.background.addEventListener(MouseEvent.CLICK, handleSliderBackgroundClick);
			
			this.btnPlay.addEventListener(MouseEvent.CLICK, handlePlay);
			
			this.btnStop.addEventListener(MouseEvent.CLICK, handleStop);
			
			this.btnReturn.addEventListener(MouseEvent.CLICK, handleReturn);
			
			this.btnPause.addEventListener(MouseEvent.CLICK, handlePause);
		}
		
		/**
		 * Handle resumed
		 **/
		public function handleResumed():void
		{
			this.btnPlay.visible = false;
			
			this.btnPause.visible = true;
		}
		
		/**
		 * Handle stopped
		 **/
		public function handleStopped(videoData:VideoData):void
		{
			this.btnStop.enabled = false;
			this.btnReturn.enabled = false;
			this.btnPause.visible = false;
			this.btnPlay.visible = true;
			
			this.btnPlay.removeEventListener(MouseEvent.CLICK, handleResume);
			this.btnPlay.addEventListener(MouseEvent.CLICK, handlePlay);
			
			this.timePast.txtTime.text = videoData.strTimePast;
			this.timeToCome.txtTime.text = videoData.strTimeToCome;
			
			this.slider.btnThumb.x = 0;
		}
		
		/**
		 * Handle paused
		 **/
		public function handlePaused():void
		{
			this.btnPause.visible = false;
			this.btnPlay.visible = true;
			
			this.btnPlay.removeEventListener(MouseEvent.CLICK, handlePlay);
			this.btnPlay.addEventListener(MouseEvent.CLICK, handleResume);
		}
		
		/**
		 * Handle rewinded
		 **/
		public function handleRewinded():void
		{
			
		}
		
		/**
		 * Handle video progress
		 **/
		public function handleProgress(videoData:VideoData):void
		{			
			this.timePast.txtTime.text = videoData.strTimePast;
			this.timeToCome.txtTime.text = videoData.strTimeToCome;
			
			if(this._thumbUpdate)
			{
				var position:int = (this.slider.background.width - this.slider.btnThumb.width + 1) * (videoData.pastTime / videoData.duration);
				
				this.slider.btnThumb.x = position;
			}
		}
		
		/**
		 * Handle Muted sound
		 **/
		public function handleMutedSound():void
		{
			this.btnSound.visible = false;
			this.btnMute.visible = true;
		}
		
		/**
		 * Handle Unmuted sound
		 **/
		public function  handleUnmutedSound():void
		{
			this.btnSound.visible = true;
			this.btnMute.visible = false;
		}		
		
		//----------------------------------
		//  Private methods
		//----------------------------------
		private function init():void
		{			
			this.btnRestore.visible = false;
			this.btnPause.visible = false;
			this.btnMute.visible = false;
			
			this.btnStop.enabled = false;
			this.btnReturn.enabled = false;
			this.btnSound.enabled = false;
			this.slider.enabled = false;
			this.slider.btnThumb.enabled = false;
			
			this.btnMaximize.enabled = true;
			this.btnPlay.enabled = false;
						
			this.btnMaximize.addEventListener(MouseEvent.CLICK, handleFullScreen);
			this.btnRestore.addEventListener(MouseEvent.CLICK, handleFullScreen);
		}
		
		/**
		 * Handle Resize
		 **/
		private function resize(_stWidth:int):void
		{
			if(this._scaleControls)
			{
				this.height = this.height * ((_stWidth - 60) / this.width);
				this.width = _stWidth - 60;
			}
		}
		
		//----------------------------------
		//  Private event handlers
		//----------------------------------
		/**
		 * Handle the fullscreen buttons
		 **/
		private function handleFullScreen(evt:MouseEvent):void
		{
			dispatchEvent(new ViewEvent(ViewEvent.FULL_SCREEN));
		}
		
		/**
		 * Handle pressing of the play button
		 **/
		private function handlePlay(evt:MouseEvent):void
		{		
			dispatchEvent(new StreamingEvent(StreamingEvent.PLAY));
		}
		
		/**
		 * Handle the pressing of the pause button
		 **/
		private function handlePause(evt:MouseEvent):void
		{		
			dispatchEvent(new StreamingEvent(StreamingEvent.PAUSE));
		}
		
		/**
		 * Handle the pressing of the stop button
		 **/
		private function handleStop(evt:MouseEvent):void
		{
			dispatchEvent(new StreamingEvent(StreamingEvent.STOP));
		}
		
		/**
		 * Handle the pressing of the resume button
		 **/
		private function handleResume(evt:MouseEvent):void
		{
			dispatchEvent(new StreamingEvent(StreamingEvent.RESUME));
		}
		
		/**
		 * Handle the pressing of the return button
		 **/
		private function handleReturn(evt:MouseEvent):void
		{
			dispatchEvent(new StreamingEvent(StreamingEvent.REWIND));
		}
		
		/**
		 * Handle the clicking on the background of the slider
		 * Go to the clicked position
		 **/
		private function handleSliderBackgroundClick(evt:MouseEvent):void
		{
			var data:* = {widthSlider:this.slider.background.width, mouseXSlider:evt.target.mouseX};
			dispatchEvent(new StreamingEvent(StreamingEvent.SLIDER_BACKGROUND_CLICKED, data));
		}
		
		/**
		 * Handle Thumb Dragging
		 **/
		private function handleThumbDrag(evt:MouseEvent):void
		{
			this._thumbUpdate = false;
			
			this.slider.btnThumb.startDrag(false, new Rectangle(0,-1.8, (this.slider.width - (this.slider.btnThumb.width / 2)),0 ));
			this.slider.btnThumb.addEventListener(Event.ENTER_FRAME, handleThumbSliding);
			
			dispatchEvent(new StreamingEvent(StreamingEvent.START_SLIDING));
		}
		
		/**
		 * Handling dragging thumb
		 **/
		private function handleThumbSliding(evt:Event):void
		{
			var perc:uint = Math.round((this.slider.btnThumb.x * 100) / (this.slider.width - this.slider.btnThumb.width));
			dispatchEvent(new StreamingEvent(StreamingEvent.THUMB_SLIDING, perc));
		}
		
		/**
		 * Handle Thumb Stop Drag
		 **/
		private function handleThumbStopDrag(evt:MouseEvent):void
		{
			this._thumbUpdate = true;
			
			this.slider.btnThumb.removeEventListener(Event.ENTER_FRAME, handleThumbSliding);
			this.slider.btnThumb.stopDrag();
			
			dispatchEvent(new StreamingEvent(StreamingEvent.STOP_SLIDING));
		}
		
		/**
		 * Handle Mouse over controls
		 **/
		private function handleMouseOverControls(evt:MouseEvent):void
		{
			dispatchEvent(new ViewEvent(ViewEvent.OVER_CONTROLS));
		}
		
		/**
		 * Handle Mouse out controls
		 **/
		private function handleMouseOutControls(evt:MouseEvent):void
		{
			dispatchEvent(new ViewEvent(ViewEvent.OUT_CONTROLS));
		}
		
		/**
		 * Handle sound clicked
		 **/
		private function handleSoundClicked(evt:MouseEvent):void
		{
			dispatchEvent(new SoundEvent(SoundEvent.MUTE_CLICKED));
		}
		
		/**
		 * Handle mute clicked
		 **/
		private function handleMuteClicked(evt:MouseEvent):void
		{
			dispatchEvent(new SoundEvent(SoundEvent.UNMUTE_CLICKED));
		}
		
	}
}