package com.footer
{
    import com.*;
    import flash.display.*;
    import flash.events.*;

    public class Footer extends FooterBase
    {
        var fullsEnebled:String;
        var footY:int;
        var soundPlaing:Boolean = false;
        var _fulls:Boolean = false;
        var soundLink:String;
        var soundEnebled:String;
        var playSound:PlaySound;

        public function Footer(param1:String, param2:String, param3:int, param4:String)
        {
            fullsEnebled = param4;
            soundLink = param2;
            soundEnebled = param1;
            footY = param3;
            addEventListener(Event.ADDED_TO_STAGE, init);
            return;
        }// end function

        function addMouseMovingEvent(event:MouseEvent) : void
        {
            _soundVolume.base.addEventListener(MouseEvent.MOUSE_MOVE, volumeMouseMove);
            return;
        }// end function

        function removeMouseMovingEvent(event:MouseEvent) : void
        {
            _soundVolume.base.removeEventListener(MouseEvent.MOUSE_MOVE, volumeMouseMove);
            return;
        }// end function

        function init(event:Event) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            stage.addEventListener(Event.RESIZE, onResize);
            if (soundEnebled == "true")
            {
                playSound = new PlaySound();
                playSound.playSong(soundLink);
                _soundVolume.volumeMask.width = 25;
                playSound.volumeChange(0.6);
                soundPlaing = true;
            }
            if (soundEnebled != "true")
            {
                _soundVolume.visible = false;
            }
            else
            {
                _soundVolume.buttonMode = true;
                _soundVolume.soundOnOff.addEventListener(MouseEvent.CLICK, soundBtnPressed);
                _soundVolume.base.addEventListener(MouseEvent.CLICK, volumeMouseMove);
                _soundVolume.base.addEventListener(MouseEvent.MOUSE_DOWN, addMouseMovingEvent);
                _soundVolume.base.addEventListener(MouseEvent.MOUSE_UP, removeMouseMovingEvent);
                _soundVolume.base.addEventListener(MouseEvent.MOUSE_OUT, removeMouseMovingEvent);
            }
            if (fullsEnebled != "true")
            {
                this.removeChild(_fullscr);
            }
            else
            {
                _fullscr.buttonMode = true;
                _fullscr.addEventListener(MouseEvent.CLICK, fullscrBtnPressed);
            }
            onResize(null);
            return;
        }// end function

        function soundBtnPressed(event:MouseEvent) : void
        {
            if (soundPlaing)
            {
                playSound.pause();
                soundPlaing = false;
                event.target.gotoAndStop(2);
                _soundVolume.volumeMask.width = 1;
            }
            else
            {
                playSound.play();
                soundPlaing = true;
                event.target.gotoAndStop(1);
                _soundVolume.volumeMask.width = 49;
            }
            return;
        }// end function

        function fullscrBtnPressed(event:MouseEvent = null) : void
        {
            stage.displayState = _fulls ? (StageDisplayState.NORMAL) : (StageDisplayState.FULL_SCREEN);
            return;
        }// end function

        function onResize(event:Event) : void
        {
            if (stage.displayState != "normal")
            {
                _fulls = true;
            }
            else
            {
                _fulls = false;
            }
            this.x = stage.stageWidth - this.width - 20;
            this.y = stage.stageHeight - this.height - 16 - footY;
            return;
        }// end function

        function volumeMouseMove(event:MouseEvent) : void
        {
            if (!soundPlaing)
            {
                playSound.play();
                soundPlaing = true;
            }
            if (event.localX < 2)
            {
                _soundVolume.volumeMask.width = 1;
                playSound.volumeChange(0);
            }
            else if (event.localX < 13)
            {
                _soundVolume.volumeMask.width = 7;
                playSound.volumeChange(0.2);
            }
            else if (event.localX < 22)
            {
                _soundVolume.volumeMask.width = 16;
                playSound.volumeChange(0.4);
            }
            else if (event.localX < 32)
            {
                _soundVolume.volumeMask.width = 25;
                playSound.volumeChange(0.6);
            }
            else if (event.localX < 42)
            {
                _soundVolume.volumeMask.width = 35;
                playSound.volumeChange(0.8);
            }
            else
            {
                _soundVolume.volumeMask.width = 45;
                playSound.volumeChange(1);
            }
            return;
        }// end function

    }
}
