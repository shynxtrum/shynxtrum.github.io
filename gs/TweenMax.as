package gs
{
    import flash.events.*;
    import flash.utils.*;
    import gs.events.*;
    import gs.plugins.*;
    import gs.utils.tween.*;

    public class TweenMax extends TweenLite implements IEventDispatcher
    {
        protected var _callbacks:Object;
        protected var _dispatcher:EventDispatcher;
        public var pauseTime:Number;
        protected var _repeatCount:Number;
        protected var _timeScale:Number;
        public static var removeTween:Function = TweenLite.removeTween;
        static var _overwriteMode:int = OverwriteManager.enabled ? (OverwriteManager.mode) : (OverwriteManager.init());
        static var _globalTimeScale:Number = 1;
        public static var killTweensOf:Function = TweenLite.killTweensOf;
        public static const version:Number = 10.12;
        static var _pausedTweens:Dictionary = new Dictionary(false);
        public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
        static var _activatedPlugins:Boolean = TweenPlugin.activate([TintPlugin, RemoveTintPlugin, FramePlugin, AutoAlphaPlugin, VisiblePlugin, VolumePlugin, EndArrayPlugin, HexColorsPlugin, BlurFilterPlugin, ColorMatrixFilterPlugin, BevelFilterPlugin, DropShadowFilterPlugin, GlowFilterPlugin, RoundPropsPlugin, BezierPlugin, BezierThroughPlugin, ShortRotationPlugin]);

        public function TweenMax(param1:Object, param2:Number, param3:Object)
        {
            super(param1, param2, param3);
            if (TweenLite.version < 10.092)
            {
                trace("TweenMax error! Please update your TweenLite class or try deleting your ASO files. TweenMax requires a more recent version. Download updates at http://www.TweenMax.com.");
            }
            if (this.combinedTimeScale != 1 && this.target is TweenMax)
            {
                _timeScale = 1;
                this.combinedTimeScale = _globalTimeScale;
            }
            else
            {
                _timeScale = this.combinedTimeScale;
                this.combinedTimeScale = this.combinedTimeScale * _globalTimeScale;
            }
            if (this.combinedTimeScale != 1 && this.delay != 0)
            {
                this.startTime = this.initTime + this.delay * 1000 / this.combinedTimeScale;
            }
            if (this.vars.onCompleteListener != null || this.vars.onUpdateListener != null || this.vars.onStartListener != null)
            {
                initDispatcher();
                if (param2 == 0 && this.delay == 0)
                {
                    onUpdateDispatcher();
                    onCompleteDispatcher();
                }
            }
            _repeatCount = 0;
            if (!isNaN(this.vars.yoyo) || !isNaN(this.vars.loop))
            {
                this.vars.persist = true;
            }
            if (this.delay == 0 && this.vars.startAt != null)
            {
                this.vars.startAt.overwrite = 0;
                new TweenMax(this.target, 0, this.vars.startAt);
            }
            return;
        }// end function

        public function dispatchEvent(event:Event) : Boolean
        {
            if (_dispatcher == null)
            {
                return false;
            }
            return _dispatcher.dispatchEvent(event);
        }// end function

        public function invalidate(param1:Boolean = true) : void
        {
            var _loc_2:* = NaN;
            if (this.initted)
            {
                _loc_2 = this.progress;
                if (!param1 && _loc_2 != 0)
                {
                    this.progress = 0;
                }
                this.tweens = [];
                _hasPlugins = false;
                this.exposedVars = this.vars.isTV != true ? (this.vars) : (this.vars.exposedProps);
                initTweenVals();
                _timeScale = this.vars.timeScale || 1;
                this.combinedTimeScale = _timeScale * _globalTimeScale;
                this.delay = this.vars.delay || 0;
                if (isNaN(this.pauseTime))
                {
                    this.startTime = this.initTime + this.delay * 1000 / this.combinedTimeScale;
                }
                if (this.vars.onCompleteListener != null || this.vars.onUpdateListener != null || this.vars.onStartListener != null)
                {
                    if (_dispatcher != null)
                    {
                        this.vars.onStart = _callbacks.onStart;
                        this.vars.onUpdate = _callbacks.onUpdate;
                        this.vars.onComplete = _callbacks.onComplete;
                        _dispatcher = null;
                    }
                    initDispatcher();
                }
                if (_loc_2 != 0)
                {
                    if (param1)
                    {
                        adjustStartValues();
                    }
                    else
                    {
                        this.progress = _loc_2;
                    }
                }
            }
            return;
        }// end function

        public function get repeatCount() : Number
        {
            return _repeatCount;
        }// end function

        public function set reversed(param1:Boolean) : void
        {
            if (this.reversed != param1)
            {
                reverse();
            }
            return;
        }// end function

        public function willTrigger(param1:String) : Boolean
        {
            if (_dispatcher == null)
            {
                return false;
            }
            return _dispatcher.willTrigger(param1);
        }// end function

        public function get reversed() : Boolean
        {
            return this.ease == reverseEase;
        }// end function

        public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
        {
            if (_dispatcher != null)
            {
                _dispatcher.removeEventListener(param1, param2, param3);
            }
            return;
        }// end function

        public function setDestination(param1:String, param2, param3:Boolean = true) : void
        {
            var _loc_13:* = undefined;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = false;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_12:* = this.progress;
            if (this.initted)
            {
                if (!param3)
                {
                    _loc_4 = this.tweens.length - 1;
                    while (_loc_4 > -1)
                    {
                        
                        var _loc_14:* = this.tweens[_loc_4];
                        _loc_5 = this.tweens[_loc_4];
                        if (_loc_14.name == param1)
                        {
                            _loc_5.target[_loc_5.property] = _loc_5.start;
                        }
                        _loc_4 = _loc_4 - 1;
                    }
                }
                _loc_6 = this.vars;
                _loc_7 = this.exposedVars;
                _loc_8 = this.tweens;
                _loc_9 = _hasPlugins;
                this.tweens = [];
                var _loc_14:* = {};
                _loc_13 = {};
                this.exposedVars = _loc_14;
                this.vars = _loc_13;
                this.vars[param1] = param2;
                initTweenVals();
                if (this.ease != reverseEase && _loc_6.ease is Function)
                {
                    this.ease = _loc_6.ease;
                }
                if (param3 && _loc_12 != 0)
                {
                    adjustStartValues();
                }
                _loc_10 = this.tweens;
                this.vars = _loc_6;
                this.exposedVars = _loc_7;
                this.tweens = _loc_8;
                var _loc_14:* = {};
                _loc_11 = {};
                _loc_14[param1] = true;
                _loc_4 = this.tweens.length - 1;
                while (_loc_4 > -1)
                {
                    
                    var _loc_14:* = this.tweens[_loc_4];
                    _loc_5 = this.tweens[_loc_4];
                    if (_loc_14.name != param1)
                    {
                        if (_loc_5.isPlugin && _loc_5.name == "_MULTIPLE_")
                        {
                            _loc_5.target.killProps(_loc_11);
                            if (_loc_5.target.overwriteProps.length == 0)
                            {
                                this.tweens.splice(_loc_4, 1);
                            }
                        }
                    }
                    else
                    {
                        this.tweens.splice(_loc_4, 1);
                    }
                    _loc_4 = _loc_4 - 1;
                }
                this.tweens = this.tweens.concat(_loc_10);
                _hasPlugins = Boolean(_loc_9 || _hasPlugins);
            }
            var _loc_14:* = param2;
            _loc_13 = param2;
            this.exposedVars[param1] = _loc_14;
            this.vars[param1] = _loc_13;
            return;
        }// end function

        public function restart(param1:Boolean = false) : void
        {
            if (param1)
            {
                this.initTime = currentTime;
                this.startTime = currentTime + this.delay * 1000 / this.combinedTimeScale;
            }
            else
            {
                this.startTime = currentTime;
                this.initTime = currentTime - this.delay * 1000 / this.combinedTimeScale;
            }
            _repeatCount = 0;
            if (this.target != this.vars.onComplete)
            {
                render(this.startTime);
            }
            this.pauseTime = NaN;
            _pausedTweens[this] = null;
            delete _pausedTweens[this];
            this.enabled = true;
            return;
        }// end function

        protected function onStartDispatcher(... args) : void
        {
            if (_callbacks.onStart != null)
            {
                _callbacks.onStart.apply(null, this.vars.onStartParams);
            }
            _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.START));
            return;
        }// end function

        override public function initTweenVals() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            if (this.vars.startAt != null && this.delay != 0)
            {
                this.vars.startAt.overwrite = 0;
                new TweenMax(this.target, 0, this.vars.startAt);
            }
            super.initTweenVals();
            if (this.exposedVars.roundProps is Array && TweenLite.plugins.roundProps != null)
            {
                var _loc_8:* = this.exposedVars.roundProps;
                _loc_5 = this.exposedVars.roundProps;
                _loc_1 = _loc_8.length - 1;
                while (_loc_1 > -1)
                {
                    
                    _loc_3 = _loc_5[_loc_1];
                    _loc_2 = this.tweens.length - 1;
                    while (_loc_2 > -1)
                    {
                        
                        var _loc_8:* = this.tweens[_loc_2];
                        _loc_7 = this.tweens[_loc_2];
                        if (_loc_8.name != _loc_3)
                        {
                            if (_loc_7.isPlugin && _loc_7.name == "_MULTIPLE_" && !_loc_7.target.round)
                            {
                                var _loc_8:* = " " + _loc_7.target.overwriteProps.join(" ") + " ";
                                _loc_4 = " " + _loc_7.target.overwriteProps.join(" ") + " ";
                                if (_loc_8.indexOf(" " + _loc_3 + " ") != -1)
                                {
                                    _loc_7.target.round = true;
                                }
                            }
                        }
                        else if (_loc_7.isPlugin)
                        {
                            _loc_7.target.round = true;
                        }
                        else if (_loc_6 != null)
                        {
                            _loc_6.add(_loc_7.target, _loc_3, _loc_7.start, _loc_7.change);
                            this.tweens.splice(_loc_2, 1);
                        }
                        else
                        {
                            var _loc_8:* = new TweenLite.plugins.roundProps();
                            _loc_6 = new TweenLite.plugins.roundProps();
                            _loc_8.add(_loc_7.target, _loc_3, _loc_7.start, _loc_7.change);
                            _hasPlugins = true;
                            this.tweens[_loc_2] = new TweenInfo(_loc_6, "changeFactor", 0, 1, _loc_3, true);
                        }
                        _loc_2 = _loc_2 - 1;
                    }
                    _loc_1 = _loc_1 - 1;
                }
            }
            return;
        }// end function

        override public function render(param1:uint) : void
        {
            var _loc_2:* = NaN;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = (param1 - this.startTime) * 0.001 * this.combinedTimeScale;
            if ((param1 - this.startTime) * 0.001 * this.combinedTimeScale >= this.duration)
            {
                _loc_5 = this.duration;
                _loc_2 = this.ease == this.vars.ease || this.duration == 0.001 ? (1) : (0);
            }
            else
            {
                _loc_2 = this.ease(_loc_5, 0, 1, this.duration);
            }
            _loc_4 = this.tweens.length - 1;
            while (_loc_4 > -1)
            {
                
                var _loc_6:* = this.tweens[_loc_4];
                _loc_3 = this.tweens[_loc_4];
                _loc_6.target[_loc_3.property] = _loc_3.start + _loc_2 * _loc_3.change;
                _loc_4 = _loc_4 - 1;
            }
            if (_hasUpdate)
            {
                this.vars.onUpdate.apply(null, this.vars.onUpdateParams);
            }
            if (_loc_5 == this.duration)
            {
                complete(true);
            }
            return;
        }// end function

        protected function initDispatcher() : void
        {
            var _loc_3:* = undefined;
            var _loc_4:* = undefined;
            var _loc_1:* = null;
            var _loc_2:* = null;
            if (_dispatcher == null)
            {
                _dispatcher = new EventDispatcher(this);
                _callbacks = {onStart:this.vars.onStart, onUpdate:this.vars.onUpdate, onComplete:this.vars.onComplete};
                if (this.vars.isTV != true)
                {
                    _loc_1 = {};
                    _loc_3 = 0;
                    _loc_4 = this.vars;
                    for (_loc_2 in _loc_4)
                    {
                        
                        _loc_1[_loc_2] = this.vars[_loc_2];
                    }
                    this.vars = _loc_1;
                }
                else
                {
                    this.vars = this.vars.clone();
                }
                this.vars.onStart = onStartDispatcher;
                this.vars.onComplete = onCompleteDispatcher;
                if (this.vars.onStartListener is Function)
                {
                    _dispatcher.addEventListener(TweenEvent.START, this.vars.onStartListener, false, 0, true);
                }
                if (this.vars.onUpdateListener is Function)
                {
                    _dispatcher.addEventListener(TweenEvent.UPDATE, this.vars.onUpdateListener, false, 0, true);
                    this.vars.onUpdate = onUpdateDispatcher;
                    _hasUpdate = true;
                }
                if (this.vars.onCompleteListener is Function)
                {
                    _dispatcher.addEventListener(TweenEvent.COMPLETE, this.vars.onCompleteListener, false, 0, true);
                }
            }
            return;
        }// end function

        override public function set enabled(param1:Boolean) : void
        {
            if (!param1)
            {
                _pausedTweens[this] = null;
                delete _pausedTweens[this];
            }
            super.enabled = param1;
            if (param1)
            {
                this.combinedTimeScale = _timeScale * _globalTimeScale;
            }
            return;
        }// end function

        protected function adjustStartValues() : void
        {
            var _loc_1:* = NaN;
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = this.progress;
            if (this.progress != 0)
            {
                _loc_1 = this.ease(_loc_6, 0, 1, 1);
                _loc_2 = 1 / (1 - _loc_1);
                _loc_5 = this.tweens.length - 1;
                while (_loc_5 > -1)
                {
                    
                    var _loc_7:* = this.tweens[_loc_5];
                    _loc_4 = this.tweens[_loc_5];
                    _loc_3 = _loc_7.start + _loc_4.change;
                    if (_loc_4.isPlugin)
                    {
                        _loc_4.change = (_loc_3 - _loc_1) * _loc_2;
                    }
                    else
                    {
                        _loc_4.change = (_loc_3 - _loc_4.target[_loc_4.property]) * _loc_2;
                    }
                    _loc_4.start = _loc_3 - _loc_4.change;
                    _loc_5 = _loc_5 - 1;
                }
            }
            return;
        }// end function

        protected function onUpdateDispatcher(... args) : void
        {
            if (_callbacks.onUpdate != null)
            {
                _callbacks.onUpdate.apply(null, this.vars.onUpdateParams);
            }
            _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
            return;
        }// end function

        public function set progress(param1:Number) : void
        {
            this.startTime = currentTime - this.duration * param1 * 1000;
            this.initTime = this.startTime - this.delay * 1000 / this.combinedTimeScale;
            if (!this.started)
            {
                activate();
            }
            render(currentTime);
            if (!isNaN(this.pauseTime))
            {
                this.pauseTime = currentTime;
                this.startTime = 1000000000000000;
                this.active = false;
            }
            return;
        }// end function

        public function reverse(param1:Boolean = true, param2:Boolean = true) : void
        {
            this.ease = this.vars.ease != this.ease ? (this.vars.ease) : (reverseEase);
            var _loc_3:* = this.progress;
            if (param1 && _loc_3 > 0)
            {
                this.startTime = currentTime - (1 - _loc_3) * this.duration * 1000 / this.combinedTimeScale;
                this.initTime = this.startTime - this.delay * 1000 / this.combinedTimeScale;
            }
            if (param2 != false)
            {
                if (_loc_3 < 1)
                {
                    resume();
                }
                else
                {
                    restart();
                }
            }
            return;
        }// end function

        public function set paused(param1:Boolean) : void
        {
            if (param1)
            {
                pause();
            }
            else
            {
                resume();
            }
            return;
        }// end function

        public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
        {
            if (_dispatcher == null)
            {
                initDispatcher();
            }
            if (param1 == TweenEvent.UPDATE && this.vars.onUpdate != onUpdateDispatcher)
            {
                this.vars.onUpdate = onUpdateDispatcher;
                _hasUpdate = true;
            }
            _dispatcher.addEventListener(param1, param2, param3, param4, param5);
            return;
        }// end function

        public function set repeatCount(param1:Number) : void
        {
            _repeatCount = param1;
            return;
        }// end function

        public function resume() : void
        {
            this.enabled = true;
            if (!isNaN(this.pauseTime))
            {
                this.initTime = this.initTime + currentTime - this.pauseTime;
                this.startTime = this.initTime + this.delay * 1000 / this.combinedTimeScale;
                this.pauseTime = NaN;
                if (!this.started && currentTime >= this.startTime)
                {
                    activate();
                }
                else
                {
                    this.active = this.started;
                }
                _pausedTweens[this] = null;
                delete _pausedTweens[this];
            }
            return;
        }// end function

        public function get paused() : Boolean
        {
            return !isNaN(this.pauseTime);
        }// end function

        public function reverseEase(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            return this.vars.ease(param4 - param1, param2, param3, param4);
        }// end function

        public function killProperties(param1:Array) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = {};
            _loc_2 = param1.length - 1;
            while (_loc_2 > -1)
            {
                
                _loc_3[param1[_loc_2]] = true;
                _loc_2 = _loc_2 - 1;
            }
            killVars(_loc_3);
            return;
        }// end function

        public function hasEventListener(param1:String) : Boolean
        {
            if (_dispatcher == null)
            {
                return false;
            }
            return _dispatcher.hasEventListener(param1);
        }// end function

        public function pause() : void
        {
            if (isNaN(this.pauseTime))
            {
                this.pauseTime = currentTime;
                this.startTime = 1000000000000000;
                this.enabled = false;
                _pausedTweens[this] = this;
            }
            return;
        }// end function

        override public function complete(param1:Boolean = false) : void
        {
            var _loc_2:* = undefined;
            if (!isNaN(this.vars.yoyo) && (_repeatCount < this.vars.yoyo || this.vars.yoyo == 0) || !isNaN(this.vars.loop) && (_repeatCount < this.vars.loop || this.vars.loop == 0))
            {
                var _loc_4:* = _repeatCount + 1;
                _repeatCount = _loc_4;
                if (!isNaN(this.vars.yoyo))
                {
                    this.ease = this.vars.ease != this.ease ? (this.vars.ease) : (reverseEase);
                }
                this.startTime = param1 ? (this.startTime + this.duration * 1000 / this.combinedTimeScale) : (currentTime);
                this.initTime = this.startTime - this.delay * 1000 / this.combinedTimeScale;
            }
            else if (this.vars.persist == true)
            {
                pause();
            }
            super.complete(param1);
            return;
        }// end function

        public function set timeScale(param1:Number) : void
        {
            var _loc_2:* = undefined;
            if (param1 < 1e-005)
            {
                var _loc_3:Number = 1e-005;
                _loc_2 = 1e-005;
                _timeScale = _loc_3;
                param1 = _loc_2;
            }
            else
            {
                _timeScale = param1;
                param1 = param1 * _globalTimeScale;
            }
            this.initTime = currentTime - (currentTime - this.initTime - this.delay * 1000 / this.combinedTimeScale) * this.combinedTimeScale * 1 / param1 - this.delay * 1000 / param1;
            if (this.startTime != 1000000000000000)
            {
                this.startTime = this.initTime + this.delay * 1000 / param1;
            }
            this.combinedTimeScale = param1;
            return;
        }// end function

        public function get progress() : Number
        {
            var _loc_1:* = isNaN(this.pauseTime) ? (currentTime) : (this.pauseTime);
            var _loc_2:* = ((_loc_1 - this.initTime) * 0.001 - this.delay / this.combinedTimeScale) / this.duration * this.combinedTimeScale;
            if (_loc_2 > 1)
            {
                return 1;
            }
            if (_loc_2 < 0)
            {
                return 0;
            }
            return _loc_2;
        }// end function

        public function get timeScale() : Number
        {
            return _timeScale;
        }// end function

        protected function onCompleteDispatcher(... args) : void
        {
            if (_callbacks.onComplete != null)
            {
                _callbacks.onComplete.apply(null, this.vars.onCompleteParams);
            }
            _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
            return;
        }// end function

        public static function to(param1:Object, param2:Number, param3:Object) : TweenMax
        {
            return new TweenMax(param1, param2, param3);
        }// end function

        public static function pauseAll(param1:Boolean = true, param2:Boolean = false) : void
        {
            changePause(true, param1, param2);
            return;
        }// end function

        public static function getTweensOf(param1:Object) : Array
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = masterList[param1];
            var _loc_5:* = [];
            if (_loc_4 != null)
            {
                _loc_3 = _loc_4.length - 1;
                while (_loc_3 > -1)
                {
                    
                    if (!_loc_4[_loc_3].gc)
                    {
                        _loc_5[_loc_5.length] = _loc_4[_loc_3];
                    }
                    _loc_3 = _loc_3 - 1;
                }
            }
            var _loc_6:* = 0;
            var _loc_7:* = _pausedTweens;
            for each (_loc_2 in _loc_7)
            {
                
                if (_loc_2.target != param1)
                {
                    continue;
                }
                _loc_5[_loc_5.length] = _loc_2;
            }
            return _loc_5;
        }// end function

        public static function killAllDelayedCalls(param1:Boolean = false) : void
        {
            killAll(param1, false, true);
            return;
        }// end function

        public static function setGlobalTimeScale(param1:Number) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            if (param1 < 1e-005)
            {
                param1 = 1e-005;
            }
            var _loc_4:* = masterList;
            _globalTimeScale = param1;
            var _loc_5:* = 0;
            var _loc_6:* = _loc_4;
            for each (_loc_3 in _loc_6)
            {
                
                _loc_2 = _loc_3.length - 1;
                while (_loc_2 > -1)
                {
                    
                    if (_loc_3[_loc_2] is TweenMax)
                    {
                        _loc_3[_loc_2].timeScale = _loc_3[_loc_2].timeScale * 1;
                    }
                    _loc_2 = _loc_2 - 1;
                }
            }
            return;
        }// end function

        public static function get globalTimeScale() : Number
        {
            return _globalTimeScale;
        }// end function

        public static function delayedCall(param1:Number, param2:Function, param3:Array = null, param4:Boolean = false) : TweenMax
        {
            return new TweenMax(param2, 0, {delay:param1, onComplete:param2, onCompleteParams:param3, persist:param4, overwrite:0});
        }// end function

        public static function isTweening(param1:Object) : Boolean
        {
            var _loc_2:* = getTweensOf(param1);
            var _loc_3:* = _loc_2.length - 1;
            while (_loc_3 > -1)
            {
                
                if ((_loc_2[_loc_3].active || _loc_2[_loc_3].startTime == currentTime) && !_loc_2[_loc_3].gc)
                {
                    return true;
                }
                _loc_3 = _loc_3 - 1;
            }
            return false;
        }// end function

        public static function killAll(param1:Boolean = false, param2:Boolean = true, param3:Boolean = true) : void
        {
            var _loc_6:* = undefined;
            var _loc_4:* = false;
            var _loc_5:* = 0;
            var _loc_7:* = getAllTweens();
            _loc_6 = getAllTweens();
            _loc_5 = _loc_7.length - 1;
            while (_loc_5 > -1)
            {
                
                var _loc_7:* = _loc_6[_loc_5].target == _loc_6[_loc_5].vars.onComplete;
                _loc_4 = _loc_6[_loc_5].target == _loc_6[_loc_5].vars.onComplete;
                if (_loc_7 == param3 || _loc_4 != param2)
                {
                    if (param1)
                    {
                        _loc_6[_loc_5].complete(false);
                        _loc_6[_loc_5].clear();
                    }
                    else
                    {
                        TweenLite.removeTween(_loc_6[_loc_5], true);
                    }
                }
                _loc_5 = _loc_5 - 1;
            }
            return;
        }// end function

        public static function changePause(param1:Boolean, param2:Boolean = true, param3:Boolean = false) : void
        {
            var _loc_5:* = undefined;
            var _loc_4:* = false;
            var _loc_7:* = getAllTweens();
            _loc_5 = getAllTweens();
            var _loc_6:* = _loc_7.length - 1;
            while (_loc_6 > -1)
            {
                
                _loc_4 = _loc_5[_loc_6].target == _loc_5[_loc_6].vars.onComplete;
                if (_loc_5[_loc_6] is TweenMax && (_loc_4 == param3 || _loc_4 != param2))
                {
                    _loc_5[_loc_6].paused = param1;
                }
                _loc_6 = _loc_6 - 1;
            }
            return;
        }// end function

        public static function from(param1:Object, param2:Number, param3:Object) : TweenMax
        {
            param3.runBackwards = true;
            return new TweenMax(param1, param2, param3);
        }// end function

        public static function killAllTweens(param1:Boolean = false) : void
        {
            killAll(param1, true, false);
            return;
        }// end function

        public static function getAllTweens() : Array
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = masterList;
            var _loc_5:* = [];
            var _loc_6:* = 0;
            var _loc_7:* = _loc_4;
            for each (_loc_1 in _loc_7)
            {
                
                _loc_2 = _loc_1.length - 1;
                while (_loc_2 > -1)
                {
                    
                    if (!_loc_1[_loc_2].gc)
                    {
                        _loc_5[_loc_5.length] = _loc_1[_loc_2];
                    }
                    _loc_2 = _loc_2 - 1;
                }
            }
            _loc_6 = 0;
            _loc_7 = _pausedTweens;
            for each (_loc_3 in _loc_7)
            {
                
                _loc_5[_loc_5.length] = _loc_3;
            }
            return _loc_5;
        }// end function

        public static function resumeAll(param1:Boolean = true, param2:Boolean = false) : void
        {
            changePause(false, param1, param2);
            return;
        }// end function

        public static function set globalTimeScale(param1:Number) : void
        {
            setGlobalTimeScale(param1);
            return;
        }// end function

        _globalTimeScale = 1;
    }
}
