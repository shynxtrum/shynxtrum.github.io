package com.loaders
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;

    public class ImageLoader extends EventDispatcher
    {
        var _content:DisplayObject;
        var _imgURL:String;
        var _loader:Loader;
        var _request:URLRequest;
        var _bytesLoaded:Number = 0;
        var _bytesTotal:Number = 0;

        public function ImageLoader(param1:String)
        {
            _loader = new Loader();
            _imgURL = param1;
            _request = new URLRequest(_imgURL);
            _loader.load(_request);
            _loader.contentLoaderInfo.addEventListener(Event.OPEN, openHandler);
            _loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
            _loader.contentLoaderInfo.addEventListener(Event.INIT, initHandler);
            _loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, HTTPStatusHandler);
            _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
            return;
        }// end function

        function openHandler(event:Event) : void
        {
            dispatchEvent(new Event(Event.OPEN));
            return;
        }// end function

        function IOErrorHandler(event:IOErrorEvent) : void
        {
            trace("A loading error occurred:\n", event.text);
            return;
        }// end function

        public function get progressImgArr() : Array
        {
            return [_bytesLoaded, _bytesTotal];
        }// end function

        function HTTPStatusHandler(event:HTTPStatusEvent) : void
        {
            return;
        }// end function

        function completeHandler(event:Event) : void
        {
            _content = _loader.content;
            dispatchEvent(new Event(Event.COMPLETE));
            return;
        }// end function

        function initHandler(event:Event) : void
        {
            _content = _loader.content;
            dispatchEvent(new Event(Event.INIT));
            removeListeners();
            return;
        }// end function

        function removeListeners() : void
        {
            _loader.contentLoaderInfo.removeEventListener(Event.OPEN, openHandler);
            _loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
            _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
            _loader.contentLoaderInfo.removeEventListener(Event.INIT, initHandler);
            _loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, HTTPStatusHandler);
            _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
            return;
        }// end function

        function progressHandler(event:ProgressEvent) : void
        {
            _bytesLoaded = event.bytesLoaded;
            _bytesTotal = event.bytesTotal;
            dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
            return;
        }// end function

        public function get urlImgData() : DisplayObject
        {
            return _content;
        }// end function

    }
}
