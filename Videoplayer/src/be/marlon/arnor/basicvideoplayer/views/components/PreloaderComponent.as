//--------------------------------------------------------------------------
//
//  PreloaderComponent.as
//
//  Extended class description & notes.
//
//  (c) 2011 - Marlon BVBA (arnor.dhaenens[at]marlon.be)
//
//--------------------------------------------------------------------------
package be.marlon.arnor.basicvideoplayer.views.components
{
	import be.marlon.arnor.basicvideoplayer.events.ViewEvent;
	import be.marlon.arnor.basicvideoplayer.model.data.FileData;
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;

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
	public class PreloaderComponent extends PreloaderMC
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
		public function PreloaderComponent(_stWidth:int, _stHeight:int)
		{
			this.x = (_stWidth - this.width) * .5;
			this.y = (_stHeight - this.height) * .5;
			this.alpha = 1;
		}
		
		//----------------------------------
		//  Public methods
		//----------------------------------
		/**
		 * Update percentage loaded
		 **/
		public function updatePreloader(fileData:FileData):void
		{
			//var perc:uint = (fileData.bytesLoaded / fileData.bytesTotal);
			
			this.marlon.alpha = fileData.bytesLoaded / fileData.bytesTotal;
			this.txtPercentage.text = (Math.floor((fileData.bytesLoaded / fileData.bytesTotal) * 100)) + "%";
		}
		
		/**
		 * Used for hiding the preloader after loading is complete
		 **/
		public function hidePreloader():void
		{
			TweenMax.to(this, 1, {alpha:0, onComplete:hidingPreloaderComplete});
		}

		/**
		 * 
		 * Reposition the preloader component
		 * stageheight and stagewidth as variables
		 * 
		 **/
		public function handleStageResize(_stWidth:int, _stHeight:int):void
		{
			this.x = (_stWidth - this.width) * .5;
			this.y = (_stHeight - this.height) * .5;
		}
		
		
		//----------------------------------
		//  Private methods
		//----------------------------------
		/**
		 * Executed when preloader is completed hiding
		 **/
		private function hidingPreloaderComplete():void
		{
			dispatchEvent(new ViewEvent(ViewEvent.REMOVE_OBJECT));
		}
		
		
		//----------------------------------
		//  Private event handlers
		//----------------------------------
		
		
	}
}