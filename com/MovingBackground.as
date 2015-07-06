package com
{
    import com.loaders.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import gs.*;
    import gs.easing.*;

    public class MovingBackground extends MovieClip
    {
        var elementPath:String;
        var plane2DeltaHeight:int = 200;
        var plane2:MovingBackgroundPlane;
        var plane2Width:int;
        var plane1Height:int;
        var plane2Height:int;
        var plane3Height:int;
        var plane1DeltaWidth:int = 400;
        var plane2DeltaWidth:int = 320;
        var plane3:MovingBackgroundPlane;
        var plane3DeltaHeight:int = 120;
        var plane1DeltaHeight:int = 280;
        var plane:MovingBackgroundPlane;
        var plane3DeltaWidth:int = 240;
        var plane3Width:int;
        var loaderImg:ImageLoader;
        var plane1Width:int;

        public function MovingBackground(param1:String)
        {
            elementPath = param1;
            addEventListener(Event.ADDED_TO_STAGE, init);
            return;
        }// end function

        public function completeLoadingPic(event:Event) : void
        {
            var _loc_2:* = Bitmap(loaderImg.urlImgData);
            var _loc_3:* = new BitmapData(_loc_2.width, _loc_2.height, true, 16777215);
            _loc_3.draw(_loc_2, new Matrix());
            plane1Width = stage.stageWidth + plane1DeltaWidth;
            plane1Height = stage.stageHeight + plane1DeltaHeight;
            plane = new MovingBackgroundPlane(_loc_3, plane1Width, plane1Height, 1, 0.7, 1, 0.7, 10);
            addChild(plane);
            plane2Width = stage.stageWidth + plane2DeltaWidth;
            plane2Height = stage.stageHeight + plane2DeltaHeight;
            plane2 = new MovingBackgroundPlane(_loc_3, plane2Width, plane2Height, 0.7, 0.4, 0.7, 0.4, 30);
            addChild(plane2);
            plane3Width = stage.stageWidth + plane3DeltaWidth;
            plane3Height = stage.stageHeight + plane3DeltaHeight;
            plane3 = new MovingBackgroundPlane(_loc_3, plane3Width, plane3Height, 0.4, 0.1, 0.4, 0.1, 50);
            addChild(plane3);
            if (stage != null)
            {
                stage.addEventListener(MouseEvent.MOUSE_MOVE, planeMove);
            }
            return;
        }// end function

        function onResize(event:Event) : void
        {
            plane1Width = stage.stageWidth + plane1DeltaWidth;
            plane1Height = stage.stageHeight + plane1DeltaHeight;
            plane.rebuidPlane(plane1Width, plane1Height);
            plane2Width = stage.stageWidth + plane2DeltaWidth;
            plane2Height = stage.stageHeight + plane2DeltaHeight;
            plane2.rebuidPlane(plane2Width, plane2Height);
            plane3Width = stage.stageWidth + plane3DeltaWidth;
            plane3Height = stage.stageHeight + plane3DeltaHeight;
            plane3.rebuidPlane(plane3Width, plane3Height);
            return;
        }// end function

        function planeMove(event:MouseEvent) : void
        {
            var _loc_2:* = (stage.stageWidth - plane1Width) / stage.stageWidth * stage.mouseX;
            var _loc_3:* = (stage.stageWidth - plane2Width) / stage.stageWidth * stage.mouseX;
            var _loc_4:* = (stage.stageWidth - plane3Width) / stage.stageWidth * stage.mouseX;
            var _loc_5:* = (stage.stageHeight - plane1Height) / stage.stageHeight * stage.mouseY;
            var _loc_6:* = (stage.stageHeight - plane2Height) / stage.stageHeight * stage.mouseY;
            var _loc_7:* = (stage.stageHeight - plane3Height) / stage.stageHeight * stage.mouseY;
            TweenLite.to(plane, 0.7, {x:_loc_2, y:_loc_5, ease:Cubic.easeOut});
            TweenLite.to(plane2, 0.7, {x:_loc_3, y:_loc_6, ease:Cubic.easeOut});
            TweenLite.to(plane3, 0.7, {x:_loc_4, y:_loc_7, ease:Cubic.easeOut});
            return;
        }// end function

        function init(event:Event) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            addEventListener(Event.REMOVED_FROM_STAGE, removed);
            stage.addEventListener(Event.RESIZE, onResize);
            loadElementPic(elementPath);
            return;
        }// end function

        function removed(event:Event) : void
        {
            stage.removeEventListener(Event.RESIZE, onResize);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, planeMove);
            return;
        }// end function

        public function loadElementPic(param1:String) : void
        {
            loaderImg = new ImageLoader(param1);
            loaderImg.addEventListener(Event.INIT, completeLoadingPic);
            return;
        }// end function

    }
}
