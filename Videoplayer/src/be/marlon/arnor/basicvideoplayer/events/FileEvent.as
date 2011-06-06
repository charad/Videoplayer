//--------------------------------------------------------------------------
//
//  FileEvent.as
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
	import be.marlon.arnor.basicvideoplayer.model.data.FileData;
	
	import flash.events.Event;

	
	//----------------------------------
	//  Class
	//----------------------------------
	
	/**
	 * Class description.
	 *
	 * @author charad (arnor.dhaenens[at]marlon.be)
	 * @since May 3, 2011
	 * @see flash.events.Event
	 */
	public class FileEvent extends Event
	{
		//----------------------------------
		//  Properties
		//----------------------------------
		
		public static const FILE_SELECTED:String = "fileEventFileSelected";
		public static const FILE_CANCEL:String = "fileEventFileCancel";	
		
		public static const FILE_BEGIN_LOADING:String = "fileEventFileBeginLoading";
		public static const FILE_LOADING:String = "fileEventLoading";
		public static const FILE_LOADING_COMPLETE:String = "fileEventLoadingComplete";
		
		public var fileData:FileData;
		
		
		
		
		//----------------------------------
		//  Constructor
		//----------------------------------
		
		/**
		 * Constructor function.
		 */
		public function FileEvent(type:String, fileData:FileData=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.fileData = fileData;
			super(type, bubbles, cancelable);
		}
		
		//----------------------------------
		//  Public methods
		//----------------------------------
		
		/**
		 * Return new instance of the FileEvent
		 **/
		override public function clone():Event
		{
			return new FileEvent(type, fileData, bubbles, cancelable);
		}		
		
	}
}