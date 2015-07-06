package com
{
    import flash.display.*;
    import flash.events.*;
    import gs.*;
    import gs.easing.*;

    public class Background extends MovieClip
    {
        var repeatVideo:Boolean;
        var intro:Boolean;
        var bitM:BitmapData;
        var isVideoLoaded:Boolean;
        var videoPath:String;
        var isSwfLoaded:Boolean;
        var bgType:String;

        public function Background(param1:String, param2:Stage, param3:Boolean, param4:Boolean, param5:BitmapData = null, param6:String = "", param7:Boolean = false, param8:Boolean = false)
        {
            isSwfLoaded = param3;
            isVideoLoaded = param4;
            bgType = param1;
            bitM = param5;
            videoPath = param6;
            repeatVideo = param7;
            intro = param8;
            addEventListener(Event.ADDED_TO_STAGE, init);
            return;
        }// end function

        function fitImageResize(param1:MovieClip, param2:Number, param3:Number) : void
        {
            var _loc_4:* = param2 / param1.width;
            var _loc_5:* = param3 / param1.height;
            if (_loc_4 < _loc_5)
            {
                param1.width = param2;
                param1.height = param1.height * _loc_4;
            }
            else
            {
                param1.width = param1.width * _loc_5;
                param1.height = param3;
            }
            param1.x = (param2 - param1.width) / 2;
            param1.y = (param3 - param1.height) / 2;
            return;
        }// end function

        function patternImageResize(param1:MovieClip, param2:Number, param3:Number) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = Math.ceil(param2 / bitM.width);
            var _loc_7:* = Math.ceil(param3 / bitM.height);
            var _loc_8:* = 0;
            while (_loc_8 < _loc_6)
            {
                
                _loc_4 = 0;
                while (_loc_4 < _loc_7)
                {
                    
                    if (this.getChildByName("_imageBitmap" + _loc_8 + _loc_4) == null)
                    {
                        var _loc_9:* = new Bitmap(bitM);
                        _loc_5 = new Bitmap(bitM);
                        _loc_9.name = "_imageBitmap" + _loc_8 + _loc_4;
                        _loc_5.smoothing = true;
                        this.addChild(_loc_5);
                        _loc_5.x = bitM.width * _loc_8;
                        _loc_5.y = bitM.height * _loc_4;
                    }
                    else
                    {
                        this.getChildByName("_imageBitmap" + _loc_8 + _loc_4).x = bitM.width * _loc_8;
                        this.getChildByName("_imageBitmap" + _loc_8 + _loc_4).y = bitM.height * _loc_4;
                    }
                    _loc_4 = _loc_4 + 1;
                }
                _loc_8 = _loc_8 + 1;
            }
            return;
        }// end function

        protected function removed(event:Event) : void
        {
            removeEventListener(Event.REMOVED_FROM_STAGE, removed);
            stage.removeEventListener(Event.RESIZE, onResize);
            return;
        }// end function

        function fillImageResize(param1:MovieClip, param2:Number, param3:Number) : void
        {
            var _loc_4:* = param2 / param1.width;
            var _loc_5:* = param3 / param1.height;
            if (_loc_4 > _loc_5)
            {
                param1.width = param2;
                param1.height = param1.height * _loc_4;
            }
            else
            {
                param1.width = param1.width * _loc_5;
                param1.height = param3;
            }
            param1.x = (param2 - param1.width) / 2;
            param1.y = (param3 - param1.height) / 2;
            return;
        }// end function

        function init(event:Event) : void
        {
            var _loc_2:* = null;
            removeEventListener(Event.ADDED_TO_STAGE, init);
            addEventListener(Event.REMOVED_FROM_STAGE, removed);
            if (isVideoLoaded)
            {
                _loc_2 = new VideoBgPlayer(videoPath, repeatVideo, intro);
                _loc_2.name = "videoBg";
                addChild(_loc_2);
                this.addEventListener(Event.INIT, onVideoInit);
            }
            else
            {
                this.alpha = 0;
                TweenLite.to(this, 1.2, {alpha:1, ease:Cubic.easeOut});
                stage.addEventListener(Event.RESIZE, onResize);
                onResize(null);
            }
            return;
        }// end function

        function onResize(event:Event) : void
        {
            var _loc_2:* = bgType;
            switch(_loc_2)
            {
                case "FIT":
                {
                    fitImageResize(this, stage.stageWidth, stage.stageHeight);
                    break;
                }
                case "FILL":
                {
                    fillImageResize(this, stage.stageWidth, stage.stageHeight);
                    break;
                }
                case "PATTERN":
                {
                    if (isSwfLoaded || isVideoLoaded)
                    {
                        fillImageResize(this, stage.stageWidth, stage.stageHeight);
                    }
                    else
                    {
                        patternImageResize(this, stage.stageWidth, stage.stageHeight);
                    }
                    break;
                }
                case "STRETCH":
                {
                    this.width = stage.stageWidth;
                    this.height = stage.stageHeight;
                    break;
                }
                case "CENTER":
                {
                    this.x = (stage.stageWidth - this.width) / 2;
                    this.y = (stage.stageHeight - this.height) / 2;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        function onVideoInit(event:Event) : void
        {
            if (event.target is VideoBgPlayer)
            {
                stage.addEventListener(Event.RESIZE, onResize);
                onResize(null);
            }
            return;
        }// end function

    }
}
