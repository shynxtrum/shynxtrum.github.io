package com
{
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;

    public class PlaySound extends Object
    {
        var current_volume:Number = 1;
        var my_channel:SoundChannel;
        var song_position:Number;
        var current_song:String;
        var my_sound:Sound;
        var song_paused:Boolean = false;

        public function PlaySound()
        {
            return;
        }// end function

        public function loopMusic(event:Event) : void
        {
            if (my_channel != null)
            {
                my_channel.removeEventListener(Event.SOUND_COMPLETE, loopMusic);
                my_channel = my_sound.play();
                volumeChange(current_volume);
                my_channel.addEventListener(Event.SOUND_COMPLETE, loopMusic);
            }
            return;
        }// end function

        public function stop() : void
        {
            my_channel.stop();
            my_channel.removeEventListener(Event.SOUND_COMPLETE, loopMusic);
            return;
        }// end function

        public function playSong(param1:String) : void
        {
            current_song = param1;
            if (my_channel)
            {
                my_channel.stop();
            }
            my_sound = new Sound();
            my_sound.load(new URLRequest(param1));
            my_channel = my_sound.play();
            my_channel.addEventListener(Event.SOUND_COMPLETE, loopMusic);
            return;
        }// end function

        public function volumeChange(param1:Number) : void
        {
            var _loc_2:* = new SoundTransform();
            _loc_2.volume = param1;
            current_volume = param1;
            my_channel.soundTransform = _loc_2;
            return;
        }// end function

        public function play() : void
        {
            if (song_paused)
            {
                my_channel = my_sound.play(song_position);
                current_volume = 1;
                volumeChange(current_volume);
                song_paused = false;
                my_channel.addEventListener(Event.SOUND_COMPLETE, loopMusic);
            }
            else if (!my_channel)
            {
                playSong(current_song);
            }
            return;
        }// end function

        public function pause() : void
        {
            if (my_channel)
            {
                song_position = my_channel.position;
                my_channel.stop();
                my_channel.removeEventListener(Event.SOUND_COMPLETE, loopMusic);
                song_paused = true;
            }
            return;
        }// end function

    }
}
