package be.marlon.arnor.basicvideoplayer.events
{
	/**
	 * Imports
	 **/
	import flash.events.Event;
	
	/**
	 * HideControlsEvent.as
	 * 
	 * @author D'Haenens Arnor
	 * @since May 2, 2011
	 * @see flash.events.Event
	 * 
	 **/ 
	public class HideControlsEvent extends Event
	{
		/**
		 * Variables
		 **/
		public static const HIDE_CONTROLS:String = "hideControls";
		public static const SHOW_CONTROLS:String = "showControls";
		
		public static const START_TIMER:String = "startTimer";
		public static const RESET_TIMER:String = "resetTimer";
		
		public static const ADD_EVENT_LISTENER:String = "hideControlsEventAddEventListener";
		
		/**
		 * Constructor
		 **/
		public function HideControlsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			//INHERITANCE
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Return new instance of the function
		 **/
		override public function clone():Event
		{
			return new HideControlsEvent(type, bubbles, cancelable);
		}
	}
}