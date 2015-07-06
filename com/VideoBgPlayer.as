package com
{
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;

    public class VideoBgPlayer extends MovieClip
    {
        public var repeat:Boolean;
        public var mySound:SoundTransform;
        var intro:Boolean;
        public var path:String;
        public var ns:NetStream;
        public var myVideo:Video;
        public var nc:NetConnection;

        public function VideoBgPlayer(param1:String, param2:Boolean, param3:Boolean)
        {
            path = param1;
            repeat = param2;
            intro = param3;
            addEventListener(Event.ADDED_TO_STAGE, init);
            return;
        }// end function

        protected function removed(event:Event) : void
        {
            removeEventListener(Event.REMOVED_FROM_STAGE, removed);
            ns.pause();
            return;
        }// end function

        public function onXMPData(param1:Object) : void
        {
            return;
        }// end function

        public function onMetaData(param1:Object) : void
        {
            myVideo.width = param1.width;
            myVideo.height = param1.height;
            var _loc_2:* = new Event(Event.INIT, true);
            dispatchEvent(_loc_2);
            return;
        }// end function

        function init(event:Event) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            addEventListener(Event.REMOVED_FROM_STAGE, removed);
            nc = new NetConnection();
            nc.connect(null);
            ns = new NetStream(nc);
            ns.client = this;
            ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            myVideo = new Video();
            addChild(myVideo);
            myVideo.attachNetStream(ns);
            myVideo.smoothing = true;
            ns.play(path);
            mySound = ns.soundTransform;
            mySound.volume = 0.5;
            ns.soundTransform = mySound;
            return;
        }// end function

        function netStatusHandler(event:NetStatusEvent) : void
        {
            var evt:NetStatusEvent;
            var e:Event;
            var loc1:*;
            var arg1:* = event;
            e;
            evt = arg1;
            var loc2:* = evt.info.code;
            switch(loc2)
            {
                case "NetStream.FileStructureInvalid":
                {
                    trace("The MP4\'s file structure is invalid.");
                    break;
                }
                case "NetStream.NoSupportedTrackFound":
                {
                    trace("The MP4 doesn\'t contain any supported tracks");
                    break;
                }
                case "NetConnection.Call.BadVersion":
                {
                    break;
                }
                case "NetConnection.Call.Failed":
                {
                    break;
                }
                case "NetConnection.Call.Prohibited":
                {
                    break;
                }
                case "NetConnection.Connect.Closed":
                {
                    break;
                }
                case "NetConnection.Connect.Failed":
                {
                    break;
                }
                case "NetConnection.Connect.Success":
                {
                    break;
                }
                case "NetConnection.Connect.Rejected":
                {
                    break;
                }
                case "NetConnection.Connect.AppShutdown":
                {
                    break;
                }
                case "NetConnection.Connect.InvalidApp":
                {
                    break;
                }
                case "NetStream.Failed":
                {
                    break;
                }
                case "NetStream.Play.Failed":
                {
                    break;
                }
                case "NetStream.Play.Stop":
                {
                    try
                    {
                        if (repeat)
                        {
                            ns.seek(0);
                        }
                        else
                        {
                            ns.pause();
                        }
                    }
                    catch (_error:Error)
                    {
                    }
                    e = new Event(Event.COMPLETE, true);
                    dispatchEvent(e);
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                {
                    break;
                }
                case "NetStream.Publish.BadName":
                {
                    break;
                }
                case "NetStream.Seek.Failed":
                {
                    break;
                }
                case "NetStream.Seek.InvalidTime":
                {
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

    }
}
