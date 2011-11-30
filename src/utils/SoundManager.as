package utils 
{
	import flash.media.*;
	import flash.media.SoundMixer;

	/**
	 * ...
	 * @author Steve Fulton and Jeff Fulton
	 * Simplfied SoundManager
	 */
	public class SoundManager 
	{
		private var sounds:Array;
		
		private var soundTrackChannel:SoundChannel = new SoundChannel();
		private var soundChannels:Array = [];
		
		private var tempSoundTransform:SoundTransform = new SoundTransform();
		private var tempSound:Sound;
		
		private var muteSoundTransform:SoundTransform = new SoundTransform(); 
		private var soundMute:Boolean = false;
		
		public function SoundManager() 	
		{			
			sounds = new Array();
		}
		
		public function addSound(soundName:String, sound:Sound):void 
		{
			sounds[soundName] = sound;
		}
		
		public function playSound(soundName:String, isSoundTrack:Boolean = false, loops:int = 1, offset:Number = 0, volume:Number = 1):void
		{
			tempSoundTransform.volume = volume;
			tempSound = sounds[soundName];
			
			if (isSoundTrack) 
			{
				if (soundTrackChannel != null) 
				{
					soundTrackChannel.stop();
				}
				soundTrackChannel = tempSound.play(offset,loops);								
				soundTrackChannel.soundTransform = tempSoundTransform;
			}
			else 
			{
				soundChannels[soundName] = tempSound.play(offset, loops);
				soundChannels[soundName].soundTransform = tempSoundTransform;
			}
		}
		
		public function stopSound(soundName:String, isSoundTrack:Boolean = false):void 
		{
			if (isSoundTrack) 
			{
				soundTrackChannel.stop();
			}
			else 
			{
				soundChannels[soundName].stop();
			}
		}
		
		public function muteSound():void 
		{
			if (soundMute) 
			{
				soundMute = false;
				muteSoundTransform.volume = 1;
				SoundMixer.soundTransform = muteSoundTransform;
			}
			else
			{
				muteSoundTransform.volume = 0;
				SoundMixer.soundTransform = muteSoundTransform;
				soundMute = true;
			}
		}
	}
	
}
