//--------------------------------------------------------------------------
//
//  file
//
//  Extended class description & notes.
//
//  (c) 2011 - Marlon BVBA (arnor.dhaenens[at]marlon.be)
//
//--------------------------------------------------------------------------
package be.marlon.arnor.basicvideoplayer.model
{
	//----------------------------------
	//  Import statements
	//----------------------------------
	import be.marlon.arnor.basicvideoplayer.events.HideControlsEvent;
	
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	//----------------------------------
	//  Class
	//----------------------------------
	
	/**
	 * Class description.
	 *
	 * @author charad (arnor.dhaenens[at]marlon.be)
	 * @since May 3, 2011
	 */
	public class HideControlsModel extends EventDispatcher
	{
		//----------------------------------
		//  Properties
		//----------------------------------
		private var _timer:Timer;
		
		
		
		//----------------------------------
		//  Getters & setters
		//----------------------------------
		
		
		
		//----------------------------------
		//  Constructor
		//----------------------------------
		
		/**
		 * Constructor function.
		 */
		public function HideControlsModel(target:IEventDispatcher=null)
		{
			super(target);
			
			init();
		}
		
		//----------------------------------
		//  Public methods
		//----------------------------------
		/**
		 * Stop the timer
		 **/
		public function stopTimer():void
		{
			this._timer.stop();
		}
		
		/**
		 * Reset the timer to 0
		 * Start the timer again
		 **/
		public function resetTimer():void
		{
			this._timer.reset();
			this._timer.start();
		}
		
		
		//----------------------------------
		//  Private methods
		//----------------------------------
		/**
		 * Initialise the timer model
		 **/
		private function init():void
		{
			this._timer = new Timer(1000, 2);
			this._timer.addEventListener(TimerEvent.TIMER, handleTimerProgress);
			this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete);
			
			this._timer.start();
		}
		
		//----------------------------------
		//  Private event handlers
		//----------------------------------
		/**
		 * Handle the progress of the timer object
		 **/
		private function handleTimerProgress(evt:TimerEvent):void
		{
			//MonsterDebugger.trace(this, evt);
		}
		
		/**
		 * Handle the completion of the timer object
		 **/
		private function handleTimerComplete(evt:TimerEvent):void
		{
			dispatchEvent(new HideControlsEvent(HideControlsEvent.HIDE_CONTROLS));
		}
		
	}
}