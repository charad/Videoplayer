//--------------------------------------------------------------------------
//
//  FileData
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
	 * @since May 5, 2011
	 */
	public class FileData
	{
		//----------------------------------
		//  Properties
		//----------------------------------
		private var _fileURL:String;
		private var _bytesLoaded:uint;
		private var _bytesTotal:uint;
		
		
		//----------------------------------
		//  Getters & setters
		//----------------------------------
		public function get fileURL():String
		{
			return _fileURL;
		}
		
		public function set fileURL(value:String):void
		{
			_fileURL = value;
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
		
		
		//----------------------------------
		//  Constructor
		//----------------------------------
		
		/**
		 * Constructor function.
		 */
		public function FileData()
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