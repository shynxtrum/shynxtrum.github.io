package com
{
    import flash.display.*;
    import flash.events.*;
    import gs.*;
    import gs.easing.*;

    public class MovingBackgroundPlane extends MovieClip
    {
        var elementsNumber:int;
        var planeHeight:int;
        var planeWidth:int;
        var maxScale:Number;
        var minAlpha:Number;
        var minScale:Number;
        var maxAlpha:Number;
        var elementBtm:BitmapData;

        public function MovingBackgroundPlane(param1:BitmapData, param2:int, param3:int, param4:Number, param5:Number, param6:Number, param7:Number, param8:int)
        {
            elementBtm = param1;
            planeWidth = param2;
            planeHeight = param3;
            maxScale = param4;
            minScale = param5;
            maxAlpha = param6;
            minAlpha = param7;
            elementsNumber = param8;
            addEventListener(Event.ADDED_TO_STAGE, init);
            return;
        }// end function

        function range(param1:Number, param2:Number) : Number
        {
            return Math.random() * (param2 - param1) + param1;
        }// end function

        function buidingPlane() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = 0;
            while (_loc_3 < elementsNumber)
            {
                
                _loc_1 = new MovieClip();
                _loc_1.name = "element" + _loc_3;
                _loc_2 = new Bitmap(elementBtm);
                _loc_2.name = "_imageBitmap" + _loc_3;
                _loc_2.smoothing = true;
                _loc_1.addChild(_loc_2);
                itemParameters(_loc_1);
                this.addChildAt(_loc_1, _loc_3);
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

        function init(event:Event) : void
        {
            buidingPlane();
            return;
        }// end function

        public function rebuidPlane(param1:int, param2:int) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = planeWidth / param1;
            var _loc_5:* = planeHeight / param2;
            planeWidth = param1;
            planeHeight = param2;
            var _loc_6:* = 0;
            while (_loc_6 < elementsNumber)
            {
                
                _loc_3 = MovieClip(this.getChildByName("element" + _loc_6));
                _loc_3.x = _loc_3.x / _loc_4;
                _loc_3.y = _loc_3.y / _loc_5;
                _loc_6 = _loc_6 + 1;
            }
            return;
        }// end function

        function itemParameters(param1:MovieClip) : void
        {
            var _loc_2:* = range(minScale, maxScale);
            var _loc_3:* = range(minAlpha, maxAlpha);
            var _loc_4:* = range(0, 360);
            var _loc_5:* = Math.random() * planeWidth;
            var _loc_6:* = Math.random() * planeHeight;
            param1.scaleX = 0.01;
            param1.scaleY = 0.01;
            param1.x = stage.stageWidth / 2;
            param1.y = stage.stageHeight / 2;
            TweenLite.to(param1, 1, {alpha:_loc_3, scaleX:_loc_2, scaleY:_loc_2, rotation:_loc_4, x:_loc_5, y:_loc_6, ease:Strong.easeOut});
            return;
        }// end function

    }
}
