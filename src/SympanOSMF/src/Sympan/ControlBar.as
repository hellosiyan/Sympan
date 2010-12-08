package Sympan
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import mx.core.BitmapAsset;
	import mx.events.ResizeEvent;
	
	public class ControlBar extends Sprite
	{
		public static const HEIGHT:uint = 30;
		
		[Embed(source="assets/pause_btn.png")]
		private static const PAUSE_BUTTON:Class;
		
		[Embed(source="assets/play_btn.png")]
		private static const PLAY_BUTTON:Class;
		
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
		
		public function ControlBar()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onControlBarAddedToStage);
		}
		
		private function onControlBarAddedToStage(event:Event):void
		{
			drawControls();
			this.parent.stage.addEventListener(Event.RESIZE, onParentStageResize);
		}
		
		private function onParentStageResize(event:Event):void
		{
			drawControls();
		}
		
		public function drawControls():void
		{
			var g:Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, 0.75);
			g.drawRect(0, stage.height, stage.width, HEIGHT);
			g.endFill();
			
			var playButtonAsset:BitmapAsset = new PLAY_BUTTON();
			g.beginBitmapFill(playButtonAsset.bitmapData);
			g.drawRect(0, stage.height, 17, 21);
			g.endFill();
		}
	}
}