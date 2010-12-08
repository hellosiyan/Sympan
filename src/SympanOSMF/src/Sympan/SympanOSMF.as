package Sympan
{
	import Sympan.ControlBar;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import org.osmf.containers.MediaContainer;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;
	
	[SWF(width="640", height="400", backgroundColor="#000000")]
	public class SympanOSMF extends Sprite
	{
		private static var CANVAS_WIDTH:uint = 640;
		private static var CANVAS_HEIHGT:uint = 400;
		private static var CBAR_HEIGHT:uint = 30;
		private static var BTN_WIDTH:uint = 40;
		
		public var container:MediaContainer;
		private var mediaFactory:MediaFactory;
		private var resource:URLResource;
		private var mediaElement:MediaElement;
		private var mediaPlayer:MediaPlayer;
		
		private var controlBar:ControlBar;
		
		public function SympanOSMF(url:String="http://media09.vbox7.com/s/60/60d14d9d.flv")
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			container = new MediaContainer();
			container.width = CANVAS_WIDTH;
			container.height = CANVAS_HEIHGT - CBAR_HEIGHT;
			addChild(container);
			
			mediaFactory = new DefaultMediaFactory();
			
			resource = new URLResource(url);
			
			mediaElement = mediaFactory.createMediaElement(resource);
			container.addMediaElement(mediaElement);
			
			mediaPlayer = new MediaPlayer();
			mediaPlayer.media = mediaElement;
			mediaPlayer.pause();
			
			controlBar = new ControlBar();
			addChild(controlBar);
			
			container.addEventListener(MouseEvent.CLICK, togglePlayingState);
			addEventListener(Event.ADDED_TO_STAGE, onSympanAddedToStage);
		}
		
		private function renderControlsBar():Sprite
		{
			var cbar:Sprite = new Sprite();
			var g:Graphics = cbar.graphics;
			
			var gradientMatrix:Matrix = new Matrix();
			gradientMatrix.createGradientBox(CANVAS_WIDTH, CBAR_HEIGHT, Math.PI / 2, 0, CANVAS_HEIHGT - CBAR_HEIGHT);
			
			g.beginGradientFill(GradientType.LINEAR, [0x666666, 0x000000], [1, 1], [0x00, 0xFF], gradientMatrix);
			g.drawRect(0, CANVAS_HEIHGT - CBAR_HEIGHT, CANVAS_WIDTH, CBAR_HEIGHT);
			g.endFill();
			
			return cbar;
		}
		
		private function togglePlayingState(event:MouseEvent):void
		{
			if (mediaPlayer.playing)
			{
				mediaPlayer.pause();
			} else {
				mediaPlayer.play();
			}
		}
		
		private function onSympanAddedToStage(event:Event):void
		{
			this.stage.addEventListener(Event.RESIZE, onSympanResize);
			this.stage.dispatchEvent(new Event(Event.RESIZE));
		}
		
		private function onSympanResize(event:Event):void
		{
			container.width = stage.stageWidth;
			container.height = stage.stageHeight;
		}
	}
}