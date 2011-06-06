//--------------------------------------------------------------------------
//
//  ModelEvent.as
//
//  Extended class description & notes.
//
//  (c) 2011 - Marlon BVBA (arnor.dhaenens[at]marlon.be)
//
//--------------------------------------------------------------------------
package be.marlon.arnor.basicvideoplayer.events
{
	//----------------------------------
	//  Import statements
	//----------------------------------
	import be.marlon.arnor.basicvideoplayer.model.data.VideoData;
	
	import flash.events.Event;
	
	
	//----------------------------------
	//  Class
	//----------------------------------
	
	/**
	 * Class description.
	 *
	 * @author charad (arnor.dhaenens[at]marlon.be)
	 * @since May 4, 2011
	 */
	public class ModelEvent extends Event
	{
		//----------------------------------
		//  Properties
		//----------------------------------
		private var _data:VideoData;
		
		public static const CREATED_MODEL:String = "modelEventCreatedModel";
		public static const DESTROYED_MODEL:String = "modelEventDestroyedModel";
		
		public static const STARTED_PLAYING:String = "modelEventStartedPlaying";
		public static const RESUMED:String = "modelEventResumed";
		
		public static const PAUSED:String = "modelEventPaused";
		public static const STOPPED:String = "modelEventStopped";
		public static const ENDED:String = "modelEventEnded";
		
		public static const REWINDED:String = "modelEventRewinded";
		
		public static const MUTED_SOUND:String = "modelEventMutedSound";
		public static const UNMUTED_SOUND:String = "modelEventUnMutedSound";
		
		public static const PROGRESS:String = "modelEventProgress";
		
		/*public static const STARTED_LOADING_VIDEO:String = "modelEventStartedLoading";
		public static const VIDEO_LOADING_PROGRESSING:String = "modelEventVideoLoadingProgressing";
		public static const VIDEO_LOADED:String = "modelEventVideoLoaded";*/
		
		
		//----------------------------------
		//  Getters & setters
		//----------------------------------
		public function get data():VideoData
		{
			return _data;
		}
		
		
		//----------------------------------
		//  Constructor
		//----------------------------------
		
		/**
		 * Constructor function.
		 */
		public function ModelEvent(type:String, data:VideoData=null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			this._data = data;
			
			super(type, bubbles, cancelable);
		}
		
		//----------------------------------
		//  Public methods
		//----------------------------------
		override public function clone():Event
		{
			return new ModelEvent(type, data, bubbles, cancelable);
		}
	}
}