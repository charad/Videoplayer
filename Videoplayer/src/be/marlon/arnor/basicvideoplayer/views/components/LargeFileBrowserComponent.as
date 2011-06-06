//--------------------------------------------------------------------------
//
//  LargeFileBrowserComponent.as
//
//  Extended class description & notes.
//
//  (c) 2011 - Marlon BVBA (arnor.dhaenens[at]marlon.be)
//
//--------------------------------------------------------------------------
package be.marlon.arnor.basicvideoplayer.views.components
{
	import be.marlon.arnor.basicvideoplayer.events.FileEvent;
	import be.marlon.arnor.basicvideoplayer.events.ViewEvent;
	
	import flash.events.MouseEvent;

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
	public class LargeFileBrowserComponent extends OpenFileLargeMC
	{
		//----------------------------------
		//  Properties
		//----------------------------------
		
		
		
		//----------------------------------
		//  Getters & setters
		//----------------------------------
		
		
		
		//----------------------------------
		//  Constructor
		//----------------------------------
		
		/**
		 * Constructor function.
		 */
		public function LargeFileBrowserComponent(_stWidth:int, _stHeight:int, _filebrowservisible:Boolean)
		{
			super();
			
			if(_filebrowservisible)
			{
				this.x = (_stWidth - this.width) * .5;
				this.y = (_stHeight - this.height) * .5;
				
				//initialise
				init();
			}
		}
		
		//----------------------------------
		//  Public methods
		//----------------------------------
		
		
		
		//----------------------------------
		//  Private methods
		//----------------------------------
		private function init():void
		{
			this.mouseChildren = false;
			this.buttonMode = true;
			this.useHandCursor = true;
			
			this.addEventListener(MouseEvent.CLICK, handleBrowse);
		}
		
		//----------------------------------
		//  Private event handlers
		//----------------------------------
		/**
		 * Dispatch event for browsing after a videofile
		 **/
		private function handleBrowse(evt:MouseEvent):void
		{
			dispatchEvent(new ViewEvent(ViewEvent.BROWSE_FOR_FILE));
		}
		
	}
}