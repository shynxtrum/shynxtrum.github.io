package com
{
    import com.loaders.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class Snowing extends MovieClip
    {
        var path:String;
        var _loaderImg:ImageLoader;

        public function Snowing(param1:String)
        {
            path = param1;
            addEventListener(Event.ADDED_TO_STAGE, init);
            return;
        }// end function

        function init(event:Event) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            logoLoad(path);
            return;
        }// end function

        function logoLoad(param1:String) : void
        {
            _loaderImg = new ImageLoader(param1);
            _loaderImg.addEventListener(Event.INIT, initLoadPreImg);
            return;
        }// end function

        function initLoadPreImg(event:Event) : void
        {
            var _loc_2:* = Bitmap(_loaderImg.urlImgData);
            var _loc_3:* = new BitmapData(_loc_2.width, _loc_2.height, true, 0);
            _loc_3.draw(_loc_2, new Matrix());
            makeItSnow(_loc_3);
            return;
        }// end function

        function makeItSnow(param1:BitmapData)
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            while (_loc_3 < 70)
            {
                
                _loc_2 = new Snowflake(param1);
                this.addChild(_loc_2);
                _loc_2.SetInitialProperties();
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

    }
}
