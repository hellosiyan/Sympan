package
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import org.osmf.containers.MediaContainer;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;
	
	[SWF(width="640", height="390", backgroundColor="#000000")]
	public class SympanOSMF extends Sprite
	{
		private static var CANVAS_WIDTH:uint = 640;
		private static var CANVAS_HEIHGT:uint = 390;
		private static var CBAR_HEIGHT:uint = 30;
		private static var BTN_WIDTH:uint = 40;
		
		private var container:MediaContainer;
		private var mediaFactory:MediaFactory;
		private var resource:URLResource;
		private var mediaElement:MediaElement;
		private var mediaPlayer:MediaPlayer;
		
		private var controlsBar:Sprite;
		
		public function SympanOSMF(url:String="http://media09.vbox7.com/s/60/60d14d9d.flv")
		{
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
			
			controlsBar = renderControlsBar();
			
			addChild(controlsBar);
			
			container.addEventListener(MouseEvent.CLICK, togglePlayingState);
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
	}
}