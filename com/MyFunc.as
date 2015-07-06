package com
{
    import flash.display.*;
    import flash.net.*;

    public class MyFunc extends Object
    {

        public function MyFunc()
        {
            return;
        }// end function

        public static function colorElements(param1:String, param2:MovieClip) : void
        {
            var _loc_4:* = undefined;
            var _loc_3:* = NaN;
            param1 = "0x" + param1.substring(1);
            _loc_3 = Number(param1);
            var _loc_5:* = param2.transform.colorTransform;
            _loc_4 = param2.transform.colorTransform;
            _loc_5.color = _loc_3;
            param2.transform.colorTransform = _loc_4;
            return;
        }// end function

        public static function colorString(param1:String) : String
        {
            param1 = "0x" + param1.substring(1);
            return param1;
        }// end function

        public static function drawShape(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : void
        {
            param1.graphics.beginFill(param2, param3);
            param1.graphics.drawRect(param4, param5, param6, param7);
            param1.graphics.endFill();
            return;
        }// end function

        public static function gotoLink(param1:String) : void
        {
            var _loc_2:* = null;
            _loc_2 = new URLRequest(param1);
            navigateToURL(_loc_2, "_blank");
            return;
        }// end function

        public static function colorNumber(param1:String) : Number
        {
            var _loc_2:* = NaN;
            param1 = "0x" + param1.substring(1);
            _loc_2 = Number(param1);
            return _loc_2;
        }// end function

    }
}
