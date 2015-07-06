package com
{
    import flash.display.*;
    import flash.events.*;

    public class Snowflake extends MovieClip
    {
        var maxWidth:Number = 0;
        var scale:Number = 0;
        var alphaValue:Number = 0;
        var ySpeed:Number = 0;
        var radius:Number = 0;
        var flakeBitmap:BitmapData;
        var yPos:Number = 0;
        var rotateDelta:int;
        var maxHeight:Number = 0;
        var xSpeed:Number = 0;
        var xPos:Number = 0;

        public function Snowflake(param1:BitmapData)
        {
            flakeBitmap = param1;
            addEventListener(Event.ADDED_TO_STAGE, init);
            return;
        }// end function

        function MoveSnowFlake(event:Event)
        {
            xPos = xPos + xSpeed;
            yPos = yPos + ySpeed;
            this.x = this.x + radius * Math.cos(xPos);
            this.y = this.y + ySpeed;
            this.rotation = this.rotation + rotateDelta;
            if (this.y - this.height > maxHeight)
            {
                this.y = -10 - this.height;
                this.x = Math.random() * maxWidth;
            }
            return;
        }// end function

        function init(event:Event) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            var _loc_2:* = new Bitmap(flakeBitmap);
            _loc_2.name = "_imageBitmap";
            _loc_2.smoothing = true;
            this.addChild(_loc_2);
            SetInitialProperties();
            return;
        }// end function

        public function SetInitialProperties()
        {
            var _loc_1:* = undefined;
            scale = range(0.2, 1);
            alphaValue = scale;
            xSpeed = scale * 0.03;
            ySpeed = scale * 2.3;
            radius = scale * 0.5;
            maxWidth = 2000;
            maxHeight = 1200;
            this.x = Math.random() * maxWidth;
            this.y = Math.random() * maxHeight;
            xPos = this.x;
            yPos = this.y;
            if (Math.random() < 0.5)
            {
                rotateDelta = -range(1, 3);
            }
            else
            {
                rotateDelta = range(1, 3);
            }
            var _loc_2:* = scale;
            _loc_1 = scale;
            this.scaleY = _loc_2;
            this.scaleX = _loc_1;
            this.alpha = alphaValue;
            this.addEventListener(Event.ENTER_FRAME, MoveSnowFlake);
            return;
        }// end function

        function range(param1:Number, param2:Number) : Number
        {
            return Math.random() * (param2 - param1) + param1;
        }// end function

    }
}
