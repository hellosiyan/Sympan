package
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.osmf.containers.MediaContainer;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;
	
	[SWF(width="640", height="360", backgroundColor="#000000")]
	public class SympanOSMF extends Sprite
	{
		private static const SIZE:Number = 100;
		private static const X:Number = 320;
		private static const Y:Number = 190;
		private static const F:Number = 1.2;
		
		private var container:MediaContainer;
		private var mediaFactory:MediaFactory;
		private var resource:URLResource;
		private var mediaElement:MediaElement;
		private var mediaPlayer:MediaPlayer;
		private var playButton:Sprite;
		
		public function SympanOSMF(url:String="http://media09.vbox7.com/s/60/60d14d9d.flv")
		{
			container = new MediaContainer();
			container.width = 640;
			container.height = 360;
			addChild(container);
			
			mediaFactory = new DefaultMediaFactory();
			
			resource = new URLResource(url);
			
			mediaElement = mediaFactory.createMediaElement(resource);
			container.addMediaElement(mediaElement);
			
			mediaPlayer = new MediaPlayer();
			mediaPlayer.media = mediaElement;
			mediaPlayer.pause();
			
			playButton = renderPlayButton();
			addChild(playButton);
			
			playButton.addEventListener(MouseEvent.CLICK, togglePlayingState);
			container.addEventListener(MouseEvent.CLICK, togglePlayingState);
		}
		
		private function renderPlayButton():Sprite
		{
			var button:Sprite = new Sprite();
			var g:Graphics = button.graphics;
			
			g.lineStyle(1, 0, 0.5);
			g.beginFill(0xA0A0A0, 0.5);
			g.moveTo(X - SIZE / F, Y - SIZE);
			g.lineTo(X + SIZE / F, Y);
			g.lineTo(X - SIZE / F, Y + SIZE);
			g.lineTo(X - SIZE / F, Y - SIZE);
			g.endFill();
			
			return button;
		}
		
		private function togglePlayingState(event:MouseEvent):void
		{
			if (mediaPlayer.playing)
			{
				mediaPlayer.pause();
				addChild(playButton);
			} else {
				mediaPlayer.play();
				removeChild(playButton);
			}
		}
	}
}