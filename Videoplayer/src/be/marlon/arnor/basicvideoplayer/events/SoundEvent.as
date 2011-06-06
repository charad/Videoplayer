//--------------------------------------------------------------------------
//
//  SoundEvent.as
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
	import flash.events.Event;

	
	
	//----------------------------------
	//  Class
	//----------------------------------
	
	/**
	 * Class description.
	 *
	 * @author charad (arnor.dhaenens[at]marlon.be)
	 * @since May 10, 2011
	 */
	public class SoundEvent extends Event
	{
		//----------------------------------
		//  Properties
		//----------------------------------
		public static const MUTE_CLICKED:String = "soundEventMuteClicked";
		public static const UNMUTE_CLICKED:String = "soundEventUnMuteClicked";
		
		
		
		//----------------------------------
		//  Constructor
		//----------------------------------
		
		/**
		 * Constructor function.
		 */
		public function SoundEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		//----------------------------------
		//  Public methods
		//----------------------------------
		override public function clone():Event
		{
			return new SoundEvent(type, bubbles, cancelable);
		}
	}
}