//--------------------------------------------------------------------------
//
//  VideoData
//
//  Extended class description & notes.
//
//  (c) 2011 - Marlon BVBA (arnor.dhaenens[at]marlon.be)
//
//--------------------------------------------------------------------------
package be.marlon.arnor.basicvideoplayer.model.data
{
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
	 * @since May 4, 2011
	 */
	public class VideoData
	{
		//----------------------------------
		//  Properties
		//----------------------------------
		private var _duration:uint;
		private var _pastTime:uint;
		
		private var _bytesLoaded:uint;
		private var _bytesTotal:uint;
		
		private var _strTimeToCome:String;
		private var _strTimePast:String;
		
		//----------------------------------
		//  Getters & setters
		//----------------------------------
		public function get duration():uint
		{
			return _duration;
		}
		
		public function set duration(value:uint):void
		{
			_duration = value;
		}
		
		public function get pastTime():uint
		{
			return _pastTime;
		}
		
		public function set pastTime(value:uint):void
		{
			_pastTime = value;
		}
		
		public function get bytesLoaded():uint
		{
			return _bytesLoaded;
		}

		public function set bytesLoaded(value:uint):void
		{
			_bytesLoaded = value;
		}
		
		public function get bytesTotal():uint
		{
			return _bytesTotal;
		}
		
		public function set bytesTotal(value:uint):void
		{
			_bytesTotal = value;
		}
		
		public function get strTimeToCome():String
		{
			return _strTimeToCome;
		}
		
		public function set strTimeToCome(value:String):void
		{
			_strTimeToCome = value;
		}
		
		public function get strTimePast():String
		{
			return _strTimePast;
		}
		
		public function set strTimePast(value:String):void
		{
			_strTimePast = value;
		}
		
		//----------------------------------
		//  Constructor
		//----------------------------------
		
		/**
		 * Constructor function.
		 */
		public function VideoData()
		{
			
		}
		
		//----------------------------------
		//  Public methods
		//----------------------------------
		
		
		
		//----------------------------------
		//  Private methods
		//----------------------------------
		
		
		//----------------------------------
		//  Private event handlers
		//----------------------------------
		
		
	}
}