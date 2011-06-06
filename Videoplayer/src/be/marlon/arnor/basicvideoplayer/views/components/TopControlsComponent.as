//--------------------------------------------------------------------------
//
//  TopControlsComponent.as
//
//  Extended class description & notes.
//
//  (c) 2011 - Marlon BVBA (arnor.dhaenens[at]marlon.be)
//
//--------------------------------------------------------------------------
package be.marlon.arnor.basicvideoplayer.views.components
{
	import be.marlon.arnor.basicvideoplayer.events.ViewEvent;
	
	import com.greensock.TweenLite;
	
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
	public class TopControlsComponent extends TopContainer
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
		public function TopControlsComponent(_stWidth:int, _stHeight:int, _fileBrowseVisible:Boolean=false, _needCloseButton:Boolean=false)
		{
			super();
			
			//set the position
			this.background.width = _stWidth;
			this.btnBrowse.x = 20;
			this.btnBrowse.y = this.btnClose.y = 10;
			this.btnBrowse.visible = _fileBrowseVisible;
			
			this.btnClose.x = _stWidth - this.btnClose.width - 20;
			this.btnClose.visible = _needCloseButton;
			
			
			init();
		}
		
		//----------------------------------
		//  Public methods
		//----------------------------------
		/**
		 * Handle resizing of the stage
		 **/
		public function handleStageChange(_stWidth:int, _stHeight:int):void
		{
			this.background.width = _stWidth;
			this.btnClose.x = _stWidth - this.btnClose.width - 20;
		}
		
		/**
		 * Hide the topcontrols
		 **/
		public function hideTopControls():void
		{
			TweenLite.killTweensOf(this);
			TweenLite.to(this, 0.5, {y:-(this.height), alpha:0});
		}
		
		/**
		 * Show the topcontrols
		 **/
		public function showTopControls():void
		{
			TweenLite.killTweensOf(this);
			TweenLite.to(this, 0.5, {y:10, alpha:1});
		}
		
		
		//----------------------------------
		//  Private methods
		//----------------------------------
		private function init():void
		{
			this.btnClose.addEventListener(MouseEvent.CLICK, handleCloseButton);
			this.btnBrowse.addEventListener(MouseEvent.CLICK, handleBrowseButton);
		}
		
		
		//----------------------------------
		//  Private event handlers
		//----------------------------------
		/**
		 * Handle clicking of the close button
		 **/
		private function handleCloseButton(evt:MouseEvent):void
		{
			dispatchEvent(new ViewEvent(ViewEvent.CLOSE_APPLICATION));
		}
		
		/**
		 * Handling the clicking of the browse button
		 **/
		private function handleBrowseButton(evt:MouseEvent):void
		{
			dispatchEvent(new ViewEvent(ViewEvent.BROWSE_FOR_FILE));
		}
		
	}
}