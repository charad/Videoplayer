package be.marlon.arnor.basicvideoplayer.events
{
	/**
	 * Imports
	 **/
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * Handling dispatching of the view events
	 * @see flash.events.Event
	 **/
	public class ViewEvent extends Event
	{
		/**
		 * Variables
		 **/
		
		public static const FULL_SCREEN:String = "viewEventFullScreen";
		public static const ENTER_FULL_SCREEN:String = "videoEventEnterFullScreen";		
		public static const EXIT_FULL_SCREEN:String = "viewEventExitFullScreen";
		public static const FULL_SCREEN_ESCAPE:String = "viewEventFullScreenEscape";
		
		public static const BROWSE_FOR_FILE:String = "viewEventBrowseForFile";
		
		public static const CLOSE_APPLICATION:String = "viewEventCloseApplication";
		
		public static const REMOVE_OBJECT:String = "viewEventRemoveObject";
		
		public static const ACTIVATED:String = "viewEventActivated";
		
		public static const VIDEO_DELETED:String = "viewEventVideoDeleted";
		public static const VIDEO_CREATED:String = "viewEventVideoCreated";
		
		public static const OVER_CONTROLS:String = "viewEventOverControls";
		public static const OUT_CONTROLS:String = "viewEventOutControls";
		
		public var object:*;
		
		/**
		 * Constructor
		 **/
		public function ViewEvent(type:String, object:*=null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			this.object = object;
			
			//inheritance
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Override clone function
		 * Return new instance
		 **/
		override public function clone():Event
		{
			return new ViewEvent(type, object, bubbles, cancelable);
		}
	}
}