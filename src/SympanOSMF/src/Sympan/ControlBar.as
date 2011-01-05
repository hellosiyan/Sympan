package Sympan
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	
	import mx.core.BitmapAsset;
	import mx.events.ResizeEvent;
	
	import org.osmf.events.PlayEvent;
	import org.osmf.media.MediaPlayer;
	import org.osmf.net.SwitchingRuleBase;
	
	public class ControlBar extends Sprite
	{
		public static const HEIGHT:uint = 30;
		
		[Embed(source="assets/pause_btn.png")]
		private static const PAUSE_BUTTON:Class;
		
		[Embed(source="assets/play_btn.png")]
		private static const PLAY_BUTTON:Class;
		
		[Embed(source="assets/fullscreen_btn.png")]
		private static const FULLSCREEN_BUTTON:Class;
		
		[Embed(source="assets/scrubbar_bg.png")]
		private static const SCRUBBAR_BACKGROUND:Class;
		
		[Embed(source="assets/scrubbar_loaded.png")]
		private static const SCRUBBAR_LOADED_IMAGE:Class;
		
		[Embed(source="assets/scrubbar_position.png")]
		private static const SCRUBBAR_POSITION_IMAGE:Class;
		
		[Embed(source="assets/speaker.png")]
		private static const SPEAKER:Class;
		
		[Embed(source="assets/volumebar_bg.png")]
		private static const VOLUMEBAR_BACKGROUND:Class;
		
		[Embed(source="assets/volumebar_position.png")]
		private static const VOLUMEBAR_POSITION:Class;
		
		private var playButton:Sprite;
		private var pauseButton:Sprite;
		private var fullscreenButton:Sprite;
		private var scrubber:Sprite;
		private var speaker:Sprite;
		private var volumeBar:Sprite;
		
		public var mediaPlayer:MediaPlayer;
		
		public function ControlBar(mediaPlayer:MediaPlayer)
		{
			//TODO: scale all button in reverse
			
			playButton = new Sprite();
			playButton.width = 30;
			playButton.height = 30;
			playButton.x = 0;
			playButton.y = 0;
			playButton.buttonMode = true;
			var playButtonAsset:BitmapAsset = new PLAY_BUTTON();
			playButton.graphics.beginBitmapFill(playButtonAsset.bitmapData);
			playButton.graphics.drawRect(0, 0, 30, 30);
			playButton.addEventListener(MouseEvent.CLICK, onPlayButtonClick);
			addChild(playButton);
			
			pauseButton = new Sprite();
			pauseButton.width = 30;
			pauseButton.height = 30;
			pauseButton.x = 0;
			pauseButton.y = 0;
			pauseButton.buttonMode = true;
			var pauseButtonAsset:BitmapAsset = new PAUSE_BUTTON();
			pauseButton.graphics.beginBitmapFill(pauseButtonAsset.bitmapData);
			pauseButton.graphics.drawRect(0, 0, 30, 30);
			pauseButton.addEventListener(MouseEvent.CLICK, onPauseButtonClick);
			
			fullscreenButton = new Sprite();
			fullscreenButton.width = 30;
			fullscreenButton.height = 30;
			fullscreenButton.x = 610;
			fullscreenButton.y = 0;
			fullscreenButton.buttonMode = true;
			var fullscreenButtonAsset:BitmapAsset = new FULLSCREEN_BUTTON();
			fullscreenButton.graphics.beginBitmapFill(fullscreenButtonAsset.bitmapData);
			fullscreenButton.graphics.drawRect(0, 0, 30, 30);
			fullscreenButton.addEventListener(MouseEvent.CLICK, onFullscreenButtonClick);
			addChild(fullscreenButton);
			
			this.mediaPlayer = mediaPlayer;
			this.mediaPlayer.addEventListener(PlayEvent.PLAY_STATE_CHANGE, onMediaPlayerPlayStateChange);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onMediaPlayerPlayStateChange(event:PlayEvent):void
		{
			if (event.playState == 'playing')
			{
				if (playButton.parent == this)
				{
					removeChild(playButton);
				}
				addChild(pauseButton);
			}
			else
			{
				if (pauseButton.parent == this)
				{
					removeChild(pauseButton);
				}
				addChild(playButton);
			}
		}
		
		private function onPlayButtonClick(event:MouseEvent):void
		{
			this.mediaPlayer.play();
		}
		
		private function onPauseButtonClick(event:MouseEvent):void
		{
			this.mediaPlayer.pause();
		}
		
		private function onFullscreenButtonClick(event:MouseEvent):void
		{
			switch (this.parent.stage.displayState) {
				case StageDisplayState.NORMAL:
					this.parent.stage.displayState = StageDisplayState.FULL_SCREEN;
					break;
				case StageDisplayState.FULL_SCREEN:
					this.parent.stage.displayState = StageDisplayState.NORMAL;
					break;
			}
		}
		
		private function onEnterFrame(event:Event):void
		{
			var w:uint = event.currentTarget.parent.stage.stageWidth;
			var h:uint = event.currentTarget.parent.stage.stageHeight;
			
			drawControls(w, h);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onAddedToStage(event:Event):void
		{
			var w:uint = event.currentTarget.parent.stage.stageWidth;
			var h:uint = event.currentTarget.parent.stage.stageHeight;
			
			drawControls(w, h);
			this.parent.stage.addEventListener(Event.RESIZE, onParentStageResize);
		}
		
		private function onParentStageResize(event:Event):void
		{
			var w:uint = event.currentTarget.stageWidth;
			var h:uint = event.currentTarget.stageHeight;
			
			this.width = event.currentTarget.stageWidth;
			
			drawControls(w, h);
		}
		
		public function drawControls(w:uint=0, h:uint=0):void
		{
			if (w == 0) {
				w = this.parent.stage.stageWidth;
			}
			if (h == 0) {
				h = this.parent.stage.stageHeight;
			}
			
			this.y = h - HEIGHT;
			
			var g:Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, 0.75);
			g.drawRect(0, 0, w, HEIGHT);
			g.endFill();
			
			playButton.width = 30;
			playButton.height = 30;
			
			pauseButton.width = 30;
			pauseButton.height = 30;
			
			fullscreenButton.width = 30;
			fullscreenButton.height = 30;
			fullscreenButton.x = w - fullscreenButton.width;
		}
		
		private function play():void
		{
			mediaPlayer.play();
		}
		
		private function pause():void
		{
			mediaPlayer.pause();
		}
	}
}