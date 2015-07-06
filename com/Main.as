package com
{
    import com.footer.*;
    import com.loaders.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;
    import gs.*;
    import gs.easing.*;

    public class Main extends MovieClip
    {
        var Switcher:Class;
        var globalXml:XML;
        var Mask:Class;
        const globalXmlLink:String = "xml/global.xml";
        var footer:MovieClip;
        var activeFlake:int = 1;
        var activeSnowing:int;
        var loaderImg:ImageLoader;
        var MainBlock:Class;
        var bgContainer:MovieClip;
        var typeArray:Array;
        var bg:Background;
        var bgMask:MovieClip;
        var mainBlock:MovieClip;
        var imgArray:Array;
        var snow:MovieClip;
        var myIndetifier:Timer;
        protected var urlLoader:URLLoader;
        var activeYear:int;
        var thisHeight:int;
        var switcher:MovieClip;
        var activeBg:int = 1;
        var active1stBg:Boolean = true;
        protected var contLoader:Loader;
        var activeImage:int = 0;

        public function Main()
        {
            imgArray = new Array();
            typeArray = new Array();
            if (stage)
            {
                init();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, init);
            }
            return;
        }// end function

        function reInitSnow() : void
        {
            if (getChildByName("snow") != null)
            {
                removeChild(getChildByName("snow"));
            }
            var _loc_1:* = "assets/flakes/flake" + activeFlake + ".png";
            if (activeSnowing != 1)
            {
                snow = new Snowing(_loc_1);
            }
            else
            {
                snow = new MovingBackground(_loc_1);
            }
            snow.name = "snow";
            snow.blendMode = "overlay";
            addChild(snow);
            return;
        }// end function

        function loadGlobalXmlComplete(event:Event) : void
        {
            removeEventListener(Event.COMPLETE, loadGlobalXmlComplete);
            globalXml = new XML(urlLoader.data);
            loadingAssets("assets/assets.swf");
            return;
        }// end function

        function reInitBg() : void
        {
            imgArray = new Array();
            typeArray = new Array();
            var _loc_1:* = 0;
            while (_loc_1 < globalXml.slideshow[activeBg].image.length())
            {
                
                imgArray[_loc_1] = globalXml.slideshow[activeBg].image[_loc_1].@path;
                typeArray[_loc_1] = globalXml.slideshow[activeBg].image[_loc_1].@type;
                _loc_1 = _loc_1 + 1;
            }
            if (myIndetifier != null)
            {
                myIndetifier.stop();
                myIndetifier = null;
            }
            activeImage = 0;
            loadBg(imgArray[activeImage]);
            return;
        }// end function

        function btnFlakeClick(event:MouseEvent) : void
        {
            var _loc_2:* = null;
            if (event.currentTarget.index != activeFlake)
            {
                _loc_2 = MovieClip(switcher.toolsBlock.flakesType.getChildByName("flake" + activeFlake));
                MovieClip(_loc_2.getChildByName("ico")).gotoAndPlay("out");
                activeFlake = event.currentTarget.index;
                event.currentTarget.getChildByName("ico").gotoAndStop("click");
                reInitSnow();
            }
            return;
        }// end function

        function init(event:Event = null) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.addEventListener(Event.RESIZE, onResize);
            getXml(globalXmlLink, loadGlobalXmlComplete);
            return;
        }// end function

        function initSwitcher() : void
        {
            var _loc_1:* = null;
            switcher = new Switcher();
            switcher.name = "switcher";
            switcher.bg.width = stage.stageWidth;
            switcher.y = stage.stageHeight - switcher.height;
            var _loc_2:* = 1;
            while (_loc_2 < 4)
            {
                
                _loc_1 = MovieClip(switcher.toolsBlock.year.getChildByName("year" + _loc_2));
                _loc_1.index = _loc_2;
                _loc_1.addEventListener(MouseEvent.ROLL_OVER, btnYearOver);
                _loc_1.addEventListener(MouseEvent.ROLL_OUT, btnYearOut);
                _loc_1.addEventListener(MouseEvent.CLICK, btnYearClick);
                if (_loc_2 != activeYear)
                {
                    MovieClip(_loc_1.getChildByName("ico")).gotoAndPlay("out");
                }
                else
                {
                    MovieClip(_loc_1.getChildByName("ico")).gotoAndPlay("click");
                }
                _loc_2 = _loc_2 + 1;
            }
            _loc_2 = 0;
            while (_loc_2 < 3)
            {
                
                _loc_1 = MovieClip(switcher.toolsBlock.bgSwitcher.getChildByName("bg" + _loc_2));
                _loc_1.index = _loc_2;
                _loc_1.addEventListener(MouseEvent.ROLL_OVER, btnBgOver);
                _loc_1.addEventListener(MouseEvent.ROLL_OUT, btnBgOut);
                _loc_1.addEventListener(MouseEvent.CLICK, btnBgClick);
                if (_loc_2 != activeBg)
                {
                    MovieClip(_loc_1.getChildByName("ico")).gotoAndPlay("out");
                }
                else
                {
                    MovieClip(_loc_1.getChildByName("ico")).gotoAndPlay("click");
                }
                _loc_2 = _loc_2 + 1;
            }
            _loc_2 = 1;
            while (_loc_2 < 4)
            {
                
                _loc_1 = MovieClip(switcher.toolsBlock.flakesType.getChildByName("flake" + _loc_2));
                _loc_1.index = _loc_2;
                _loc_1.addEventListener(MouseEvent.ROLL_OVER, btnFlakeOver);
                _loc_1.addEventListener(MouseEvent.ROLL_OUT, btnFlakeOut);
                _loc_1.addEventListener(MouseEvent.CLICK, btnFlakeClick);
                if (_loc_2 != activeFlake)
                {
                    MovieClip(_loc_1.getChildByName("ico")).gotoAndPlay("out");
                }
                else
                {
                    MovieClip(_loc_1.getChildByName("ico")).gotoAndPlay("click");
                }
                _loc_2 = _loc_2 + 1;
            }
            _loc_2 = 0;
            while (_loc_2 < 2)
            {
                
                _loc_1 = MovieClip(switcher.toolsBlock.snowingSwitcher.getChildByName("snowing" + _loc_2));
                _loc_1.index = _loc_2;
                _loc_1.addEventListener(MouseEvent.ROLL_OVER, btnSnowingOver);
                _loc_1.addEventListener(MouseEvent.ROLL_OUT, btnSnowingOut);
                _loc_1.addEventListener(MouseEvent.CLICK, btnSnowingClick);
                if (_loc_2 != activeSnowing)
                {
                    MovieClip(_loc_1.getChildByName("ico")).gotoAndPlay("out");
                }
                else
                {
                    MovieClip(_loc_1.getChildByName("ico")).gotoAndPlay("click");
                }
                _loc_2 = _loc_2 + 1;
            }
            addChild(switcher);
            switcher.toolsBlock.x = Math.round((switcher.width - switcher.toolsBlock.width) / 2);
            addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
            return;
        }// end function

        protected function assetsLoadingComplete(event:Event) : void
        {
            MainBlock = getClass(contLoader, "MainBlock");
            Switcher = getClass(contLoader, "Switcher");
            initBanner();
            return;
        }// end function

        function btnFlakeOut(event:MouseEvent) : void
        {
            if (event.target.index != activeFlake)
            {
                event.target.getChildByName("ico").gotoAndPlay("out");
            }
            return;
        }// end function

        function mouseMove(event:MouseEvent) : void
        {
            if (event.stageY > stage.stageHeight / 2)
            {
                TweenLite.to(switcher, 1, {y:stage.stageHeight - switcher.height, ease:Strong.easeOut});
            }
            else
            {
                TweenLite.to(switcher, 1, {y:stage.stageHeight, ease:Strong.easeOut});
            }
            return;
        }// end function

        function videoCompleted(event:Event) : void
        {
            if (event.target is VideoBgPlayer)
            {
                setSlideshow(0);
            }
            return;
        }// end function

        function timerListener(event:TimerEvent) : void
        {
            var _loc_2:* = undefined;
            myIndetifier.stop();
            myIndetifier = null;
            var _loc_4:* = activeImage + 1;
            activeImage = _loc_4;
            if (activeImage >= imgArray.length)
            {
                activeImage = 0;
            }
            loadBg(imgArray[activeImage]);
            return;
        }// end function

        function initMainBlock() : void
        {
            var loc1:*;
            mainBlock = new MainBlock();
            mainBlock.name = "mainBlock";
            mainBlock.x = Math.round((stage.stageWidth - mainBlock.width) / 2);
            mainBlock.y = Math.round((stage.stageHeight - mainBlock.height) / 2);
            activeYear = Number(globalXml.yeartype.@number);
            mainBlock.gotoAndStop(activeYear);
            mainBlock.title1._txt.htmlText = globalXml.title1[0];
            MyFunc.colorElements(globalXml.title1[0].@color, mainBlock.title1);
            mainBlock.title1.visible = false;
            TweenMax.to(mainBlock.title1, 0.1, {blurFilter:{blurX:28, blurY:10, quality:5}, alpha:0.5, onComplete:function ()
            {
                mainBlock.title1.visible = true;
                TweenMax.to(mainBlock.title1, 1.2, {alpha:1, blurFilter:{blurX:0, blurY:0, quality:5}});
                return;
            }// end function
            });
            mainBlock.title2._txt.htmlText = globalXml.title2[0];
            MyFunc.colorElements(globalXml.title2[0].@color, mainBlock.title2);
            mainBlock.title2.visible = false;
            TweenMax.to(mainBlock.title2, 0.1, {delay:1.2, blurFilter:{blurX:20, blurY:10, quality:5}, alpha:0.5, onComplete:function ()
            {
                mainBlock.title2.visible = true;
                TweenMax.to(mainBlock.title2, 1.2, {alpha:1, blurFilter:{blurX:0, blurY:0, quality:5}});
                return;
            }// end function
            });
            addChild(mainBlock);
            return;
        }// end function

        function btnYearOver(event:MouseEvent) : void
        {
            if (event.target.index != activeYear)
            {
                event.target.getChildByName("ico").gotoAndPlay("over");
            }
            return;
        }// end function

        function initSnow() : void
        {
            if (globalXml.snow.@type != "3D")
            {
                activeSnowing = 0;
                snow = new Snowing(globalXml.snow.@flake);
            }
            else
            {
                activeSnowing = 1;
                snow = new MovingBackground(globalXml.snow.@flake);
            }
            snow.name = "snow";
            snow.blendMode = "overlay";
            addChild(snow);
            return;
        }// end function

        function btnBgOver(event:MouseEvent) : void
        {
            if (event.target.index != activeBg)
            {
                event.target.getChildByName("ico").gotoAndPlay("over");
            }
            return;
        }// end function

        protected function getClass(param1:Loader, param2:String) : Class
        {
            return param1.contentLoaderInfo.applicationDomain.getDefinition(param2) as Class;
        }// end function

        function btnSnowingClick(event:MouseEvent) : void
        {
            var _loc_2:* = null;
            if (event.currentTarget.index != activeSnowing)
            {
                _loc_2 = MovieClip(switcher.toolsBlock.snowingSwitcher.getChildByName("snowing" + activeSnowing));
                MovieClip(_loc_2.getChildByName("ico")).gotoAndPlay("out");
                activeSnowing = event.currentTarget.index;
                event.currentTarget.getChildByName("ico").gotoAndStop("click");
                reInitSnow();
            }
            return;
        }// end function

        function btnBgClick(event:MouseEvent) : void
        {
            var _loc_2:* = null;
            if (event.currentTarget.index != activeBg)
            {
                _loc_2 = MovieClip(switcher.toolsBlock.bgSwitcher.getChildByName("bg" + activeBg));
                MovieClip(_loc_2.getChildByName("ico")).gotoAndPlay("out");
                activeBg = event.currentTarget.index;
                event.currentTarget.getChildByName("ico").gotoAndStop("click");
                reInitBg();
            }
            return;
        }// end function

        function btnSnowingOut(event:MouseEvent) : void
        {
            if (event.target.index != activeSnowing)
            {
                event.target.getChildByName("ico").gotoAndPlay("out");
            }
            return;
        }// end function

        function btnBgOut(event:MouseEvent) : void
        {
            if (event.target.index != activeBg)
            {
                event.target.getChildByName("ico").gotoAndPlay("out");
            }
            return;
        }// end function

        function btnYearClick(event:MouseEvent) : void
        {
            var _loc_2:* = null;
            if (event.currentTarget.index != activeYear)
            {
                _loc_2 = MovieClip(switcher.toolsBlock.year.getChildByName("year" + activeYear));
                MovieClip(_loc_2.getChildByName("ico")).gotoAndPlay("out");
                activeYear = event.currentTarget.index;
                event.currentTarget.getChildByName("ico").gotoAndStop("click");
                mainBlock.gotoAndStop(activeYear);
            }
            return;
        }// end function

        function loadBg(param1:String) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (bg != null)
            {
                if (bg.getChildByName("videoBg") != null)
                {
                    _loc_2 = MovieClip(bg.getChildByName("videoBg"));
                    _loc_2.ns.pause();
                }
            }
            var _loc_4:* = String(param1).substr((String(param1).lastIndexOf(".") + 1), 3);
            if (String(param1).substr((String(param1).lastIndexOf(".") + 1), 3) == "flv" || _loc_4 == "f4v" || _loc_4 == "mp4" || _loc_4 == "mov")
            {
                bg = new Background(typeArray[activeImage], stage, false, true, null, param1);
                if (active1stBg)
                {
                    active1stBg = false;
                    bg.name = "bg1";
                    if (bgContainer.getChildByName("bg1") != null)
                    {
                        bgContainer.removeChild(bgContainer.getChildByName("bg1"));
                    }
                }
                else
                {
                    active1stBg = true;
                    bg.name = "bg2";
                    if (bgContainer.getChildByName("bg2") != null)
                    {
                        bgContainer.removeChild(bgContainer.getChildByName("bg2"));
                    }
                }
                if (bgContainer.getChildByName("bgbg") != null)
                {
                    bgContainer.removeChild(bgContainer.getChildByName("bgbg"));
                }
                var _loc_5:* = new MovieClip();
                _loc_3 = new MovieClip();
                _loc_5.name = "bgbg";
                MyFunc.drawShape(_loc_3, 0, 1, 0, 0, stage.stageWidth, stage.stageHeight);
                bgContainer.addChild(_loc_3);
                bgContainer.addChild(bg);
            }
            else
            {
                loaderImg = new ImageLoader(param1);
                loaderImg.addEventListener(Event.INIT, initLoadBg);
            }
            return;
        }// end function

        function btnYearOut(event:MouseEvent) : void
        {
            if (event.target.index != activeYear)
            {
                event.target.getChildByName("ico").gotoAndPlay("out");
            }
            return;
        }// end function

        function initFooter() : void
        {
            var _loc_1:* = 0;
            if (globalXml.switcher[0].@enabled != "true")
            {
            }
            footer = new Footer(globalXml.sound.@enabled, globalXml.sound.@link, _loc_1, globalXml.fullscreen.@enabled);
            footer.alpha = 0;
            addChild(footer);
            TweenLite.to(footer, 1, {alpha:1});
            return;
        }// end function

        function initBanner() : void
        {
            if (globalXml.switcher[0].@enabled != "true")
            {
                thisHeight = stage.stageHeight;
            }
            else
            {
                thisHeight = stage.stageHeight - 112;
            }
            if (globalXml.switcher[0].@enabled != "true")
            {
                activeBg = 0;
            }
            else
            {
                activeBg = 1;
            }
            initBg();
            initMainBlock();
            if (globalXml.snow[0].@enabled == "true")
            {
                initSnow();
            }
            if (globalXml.switcher[0].@enabled == "true")
            {
                initSwitcher();
            }
            initFooter();
            return;
        }// end function

        protected function loadingAssets(param1:String) : void
        {
            var _loc_2:* = new LoaderContext(true, ApplicationDomain.currentDomain);
            contLoader = new Loader();
            contLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, assetsLoadingComplete);
            contLoader.load(new URLRequest(param1), _loc_2);
            return;
        }// end function

        protected function getXml(param1:String, param2:Function) : void
        {
            var xmlUrl:String;
            var completeFunc:Function;
            var loc1:*;
            var arg1:* = param1;
            var arg2:* = param2;
            xmlUrl = arg1;
            completeFunc = arg2;
            urlLoader = new URLLoader();
            urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
            urlLoader.addEventListener(Event.COMPLETE, completeFunc);
            try
            {
                urlLoader.load(new URLRequest(xmlUrl));
            }
            catch (e:Error)
            {
                trace("can\'t get xml from " + xmlUrl);
            }
            return;
        }// end function

        function setSlideshow(param1:int) : void
        {
            myIndetifier = new Timer(param1);
            myIndetifier.addEventListener(TimerEvent.TIMER, timerListener);
            myIndetifier.start();
            return;
        }// end function

        function btnFlakeOver(event:MouseEvent) : void
        {
            if (event.target.index != activeFlake)
            {
                event.target.getChildByName("ico").gotoAndPlay("over");
            }
            return;
        }// end function

        function onResize(event:Event) : void
        {
            if (getChildByName("switcher") == null)
            {
                thisHeight = stage.stageHeight;
            }
            else
            {
                switcher.bg.width = stage.stageWidth;
                switcher.y = stage.stageHeight - switcher.height;
                switcher.toolsBlock.x = Math.round((switcher.width - switcher.toolsBlock.width) / 2);
                thisHeight = stage.stageHeight - switcher.height;
            }
            if (bgMask != null)
            {
                bgMask.width = stage.stageWidth;
            }
            if (getChildByName("mainBlock") != null)
            {
                mainBlock.x = Math.round((stage.stageWidth - mainBlock.width) / 2);
                mainBlock.y = Math.round((stage.stageHeight - mainBlock.height) / 2);
            }
            return;
        }// end function

        function initBg() : void
        {
            bgContainer = new MovieClip();
            bgContainer.name = "bgContainer";
            bgContainer.blendMode = "screen";
            addChild(bgContainer);
            var _loc_1:* = 0;
            while (_loc_1 < globalXml.slideshow[activeBg].image.length())
            {
                
                imgArray[_loc_1] = globalXml.slideshow[activeBg].image[_loc_1].@path;
                typeArray[_loc_1] = globalXml.slideshow[activeBg].image[_loc_1].@type;
                _loc_1 = _loc_1 + 1;
            }
            addEventListener(Event.COMPLETE, videoCompleted);
            loadBg(imgArray[activeImage]);
            return;
        }// end function

        function btnSnowingOver(event:MouseEvent) : void
        {
            if (event.target.index != activeSnowing)
            {
                event.target.getChildByName("ico").gotoAndPlay("over");
            }
            return;
        }// end function

        public function initLoadBg(event:Event) : void
        {
            var evt:Event;
            var bgbg:MovieClip;
            var prevBg:MovieClip;
            var _imageMc:MovieClip;
            var _loadedImageBtm:Bitmap;
            var bitmap:BitmapData;
            var _imageBitmap:Bitmap;
            var loc1:*;
            var arg1:* = event;
            prevBg;
            _imageMc;
            _loadedImageBtm;
            bitmap;
            _imageBitmap;
            evt = arg1;
            var loc2:* = String(globalXml.slideshow[activeBg].image.@path).substr((String(globalXml.slideshow[activeBg].image.@path).lastIndexOf(".") + 1), 3);
            switch(loc2)
            {
                case "swf":
                {
                    _imageMc = new MovieClip();
                    _imageMc.name = "_imageBitmap00";
                    _imageMc.addChild(loaderImg.urlImgData);
                    bg = new Background(typeArray[activeImage], stage, true, false);
                    bg.addChildAt(_imageMc, 0);
                    break;
                }
                default:
                {
                    _loadedImageBtm = Bitmap(loaderImg.urlImgData);
                    bitmap = new BitmapData(_loadedImageBtm.width, _loadedImageBtm.height, false, 0);
                    bitmap.draw(_loadedImageBtm, new Matrix());
                    _imageBitmap = new Bitmap(bitmap);
                    _imageBitmap.name = "_imageBitmap00";
                    _imageBitmap.smoothing = true;
                    bg = new Background(typeArray[activeImage], stage, false, false, bitmap);
                    bg.addChildAt(_imageBitmap, 0);
                    break;
                    break;
                }
            }
            if (active1stBg)
            {
                active1stBg = false;
                bg.name = "bg1";
                if (bgContainer.getChildByName("bg1") != null)
                {
                    bgContainer.removeChild(bgContainer.getChildByName("bg1"));
                }
            }
            else
            {
                active1stBg = true;
                bg.name = "bg2";
                if (bgContainer.getChildByName("bg2") != null)
                {
                    bgContainer.removeChild(bgContainer.getChildByName("bg2"));
                }
            }
            if (bgContainer.getChildByName("bgbg") != null)
            {
                bgContainer.removeChild(bgContainer.getChildByName("bgbg"));
            }
            bgbg = new MovieClip();
            bgbg.name = "bgbg";
            MyFunc.drawShape(bgbg, 0, 1, 0, 0, stage.stageWidth, stage.stageHeight);
            bgContainer.addChild(bgbg);
            bgContainer.addChild(bg);
            if (bgContainer.getChildByName("bg2") != null)
            {
                bgContainer.swapChildren(bgContainer.getChildByName("bg1"), bgContainer.getChildByName("bg2"));
            }
            if (bgContainer.getChildByName("bgMask") != null)
            {
                bgContainer.removeChild(bgContainer.getChildByName("bgMask"));
            }
            bgMask = new MovieClip();
            bgMask.name = "bgMask";
            MyFunc.drawShape(bgMask, 0, 0, 0, 0, stage.stageWidth, stage.stageHeight);
            addChild(bgMask);
            if (active1stBg)
            {
                prevBg = MovieClip(bgContainer.getChildByName("bg1"));
            }
            else
            {
                prevBg = MovieClip(bgContainer.getChildByName("bg2"));
            }
            if (prevBg != null)
            {
                prevBg.mask = bgMask;
            }
            TweenLite.to(bgbg, 2.5, {height:0, ease:Cubic.easeOut});
            TweenLite.to(bgMask, 2.5, {height:0, ease:Cubic.easeOut, onComplete:function ()
            {
                if (imgArray.length > 1)
                {
                    setSlideshow(4000);
                }
                return;
            }// end function
            });
            return;
        }// end function

    }
}
