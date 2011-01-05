package Sympan
{
	import Sympan.ControlBar;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
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
	
	[SWF(width="640", height="360", backgroundColor="#000000")]
	public class SympanOSMF extends Sprite
	{
		private static var CANVAS_WIDTH:uint = 640;
		private static var CANVAS_HEIHGT:uint = 360;
		private static var CBAR_HEIGHT:uint = 30;
		
		private var container:MediaContainer;
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
			container.height = CANVAS_HEIHGT;
			addChild(container);
			
			mediaFactory = new DefaultMediaFactory();
			
			resource = new URLResource(url);
			
			mediaElement = mediaFactory.createMediaElement(resource);
			container.addMediaElement(mediaElement);
			
			mediaPlayer = new MediaPlayer();
			mediaPlayer.media = mediaElement;
			mediaPlayer.pause();
			
			controlBar = new ControlBar(mediaPlayer);
			addChild(controlBar);
			
			container.addEventListener(MouseEvent.CLICK, togglePlayingState);
			stage.addEventListener(Event.RESIZE, onSympanResize);
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
		
		private function onSympanResize(event:Event):void
		{
			container.width = stage.stageWidth;
			container.height = stage.stageHeight;
		}
	}
}