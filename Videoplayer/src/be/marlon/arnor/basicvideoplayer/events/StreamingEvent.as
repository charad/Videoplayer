package be.marlon.arnor.basicvideoplayer.events
{
	/**
	 * Imports
	 **/
	import flash.events.Event;
	import flash.media.StageVideo;
	
	/**
	 * StreamingEvent.as
	 * 
	 * @author D'Haenens Arnor
	 * @since May 2, 2011
	 * @see flash.events.Event
	 * 
	 **/
	public class StreamingEvent extends Event
	{
		/**
		 * Variables
		 **/
		public static const PLAY:String = "streamingEventPlay";
		public static const RESUME:String = "streamingEventResume";
		
		public static const PAUSE:String = "streamingEventPause";
		public static const STOP:String = "streamingEventStop";
		public static const ENDED:String = "streamingEventEnded";
		
		public static const REWIND:String = "streamingEventRewind";
		
		public static const MUTE_SOUND:String = "streamingEventMuteSound";
		public static const UNMUTE_SOUND:String = "streamingEventUnMuteSound";
		
		public static const START_SLIDING:String = "streamingEventStartSliding";
		public static const THUMB_SLIDING:String = "streamingEventThumbSliding";
		public static const STOP_SLIDING:String = "streamingEventStopSliding";
		
		public static const SLIDER_BACKGROUND_CLICKED:String = "streamingEventSliderBackgroundClicked";
		
		private var _data:*;
		
		/**
		 * Getters and setters
		 **/
		public function get data():*
		{
			return _data;
		}
		
		/**
		 * Constructor
		 **/
		public function StreamingEvent(type:String, data:* = null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			this._data = data;
			//INHERITANCE
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Return new instance of StreamingEvent
		 **/
		override public function clone():Event
		{
			return new StreamingEvent(type, bubbles, cancelable);
		}
	}
}