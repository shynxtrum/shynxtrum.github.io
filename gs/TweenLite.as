package gs
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import gs.plugins.*;
    import gs.utils.tween.*;

    public class TweenLite extends Object
    {
        public var delay:Number;
        protected var _hasUpdate:Boolean;
        protected var _hasPlugins:Boolean;
        public var started:Boolean;
        public var initted:Boolean;
        public var startTime:Number;
        public var target:Object;
        public var duration:Number;
        public var active:Boolean;
        public var gc:Boolean;
        public var vars:Object;
        public var ease:Function;
        public var tweens:Array;
        public var combinedTimeScale:Number;
        public var exposedVars:Object;
        public var initTime:Number;
        static var _timer:Timer = new Timer(2000);
        public static var defaultEase:Function = TweenLite.easeOut;
        public static const version:Number = 10.092;
        public static var currentTime:uint;
        public static var plugins:Object = {};
        static var _reservedProps:Object = {ease:1, delay:1, overwrite:1, onComplete:1, onCompleteParams:1, runBackwards:1, startAt:1, onUpdate:1, onUpdateParams:1, roundProps:1, onStart:1, onStartParams:1, persist:1, renderOnStart:1, proxiedEase:1, easeParams:1, yoyo:1, loop:1, onCompleteListener:1, onUpdateListener:1, onStartListener:1, orientToBezier:1, timeScale:1};
        static var _tlInitted:Boolean;
        public static var masterList:Dictionary = new Dictionary(false);
        public static var overwriteManager:Object;
        public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
        public static var timingSprite:Sprite = new Sprite();

        public function TweenLite(param1:Object, param2:Number, param3:Object)
        {
            if (param1 == null)
            {
                return;
            }
            if (!_tlInitted)
            {
                TweenPlugin.activate([TintPlugin, RemoveTintPlugin, FramePlugin, AutoAlphaPlugin, VisiblePlugin, VolumePlugin, EndArrayPlugin]);
                currentTime = getTimer();
                timingSprite.addEventListener(Event.ENTER_FRAME, updateAll, false, 0, true);
                if (overwriteManager == null)
                {
                    overwriteManager = {mode:1, enabled:false};
                }
                _timer.addEventListener("timer", killGarbage, false, 0, true);
                _timer.start();
                _tlInitted = true;
            }
            this.vars = param3;
            this.duration = param2 || 0.001;
            this.delay = param3.delay || 0;
            this.combinedTimeScale = param3.timeScale || 1;
            this.active = Boolean(param2 == 0 && this.delay == 0);
            this.target = param1;
            if (typeof(this.vars.ease) != "function")
            {
                this.vars.ease = defaultEase;
            }
            if (this.vars.easeParams != null)
            {
                this.vars.proxiedEase = this.vars.ease;
                this.vars.ease = easeProxy;
            }
            this.ease = this.vars.ease;
            this.exposedVars = this.vars.isTV != true ? (this.vars) : (this.vars.exposedVars);
            this.tweens = [];
            this.initTime = currentTime;
            this.startTime = this.initTime + this.delay * 1000;
            var _loc_4:* = param3.overwrite == undefined || !overwriteManager.enabled && param3.overwrite > 1 ? (overwriteManager.mode) : (int(param3.overwrite));
            if (!(param1 in masterList) || _loc_4 == 1)
            {
                masterList[param1] = [this];
            }
            else
            {
                masterList[param1].push(this);
            }
            if (this.vars.runBackwards == true && this.vars.renderOnStart != true || this.active)
            {
                initTweenVals();
                if (this.active)
                {
                    render((this.startTime + 1));
                }
                else
                {
                    render(this.startTime);
                }
                if (this.exposedVars.visible != null && this.vars.runBackwards == true && this.target is DisplayObject)
                {
                    this.target.visible = this.exposedVars.visible;
                }
            }
            return;
        }// end function

        public function get enabled() : Boolean
        {
            return this.gc ? (false) : (true);
        }// end function

        public function set enabled(param1:Boolean) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = false;
            var _loc_4:* = 0;
            if (param1)
            {
                if (this.target in masterList)
                {
                    _loc_2 = masterList[this.target];
                    _loc_4 = _loc_2.length - 1;
                    while (_loc_4 > -1)
                    {
                        
                        if (_loc_2[_loc_4] == this)
                        {
                            _loc_3 = true;
                            break;
                        }
                        _loc_4 = _loc_4 - 1;
                    }
                    if (!_loc_3)
                    {
                        _loc_2[_loc_2.length] = this;
                    }
                }
                else
                {
                    masterList[this.target] = [this];
                }
            }
            this.gc = param1 ? (false) : (true);
            if (this.gc)
            {
                this.active = false;
            }
            else
            {
                this.active = this.started;
            }
            return;
        }// end function

        public function initTweenVals() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            var _loc_3:* = undefined;
            var _loc_4:* = null;
            if (this.exposedVars.timeScale != undefined && this.target.hasOwnProperty("timeScale"))
            {
                this.tweens[this.tweens.length] = new TweenInfo(this.target, "timeScale", this.target.timeScale, this.exposedVars.timeScale - this.target.timeScale, "timeScale", false);
            }
            var _loc_5:* = 0;
            var _loc_6:* = this.exposedVars;
            for (_loc_1 in _loc_6)
            {
                
                if (_loc_1 in _reservedProps)
                {
                    continue;
                }
                if (_loc_1 in plugins)
                {
                    _loc_3 = new plugins[_loc_1];
                    if (_loc_3.onInitTween(this.target, this.exposedVars[_loc_1], this) != false)
                    {
                        this.tweens[this.tweens.length] = new TweenInfo(_loc_3, "changeFactor", 0, 1, _loc_3.overwriteProps.length != 1 ? ("_MULTIPLE_") : (_loc_3.overwriteProps[0]), true);
                        _hasPlugins = true;
                    }
                    else
                    {
                        this.tweens[this.tweens.length] = new TweenInfo(this.target, _loc_1, this.target[_loc_1], typeof(this.exposedVars[_loc_1]) != "number" ? (Number(this.exposedVars[_loc_1])) : (this.exposedVars[_loc_1] - this.target[_loc_1]), _loc_1, false);
                    }
                    continue;
                }
                this.tweens[this.tweens.length] = new TweenInfo(this.target, _loc_1, this.target[_loc_1], typeof(this.exposedVars[_loc_1]) != "number" ? (Number(this.exposedVars[_loc_1])) : (this.exposedVars[_loc_1] - this.target[_loc_1]), _loc_1, false);
            }
            if (this.vars.runBackwards == true)
            {
                _loc_2 = this.tweens.length - 1;
                while (_loc_2 > -1)
                {
                    
                    _loc_4 = this.tweens[_loc_2];
                    this.tweens[_loc_2].start = _loc_4.start + _loc_4.change;
                    _loc_4.change = -_loc_4.change;
                    _loc_2 = _loc_2 - 1;
                }
            }
            if (this.vars.onUpdate != null)
            {
                _hasUpdate = true;
            }
            if (TweenLite.overwriteManager.enabled && this.target in masterList)
            {
                overwriteManager.manageOverwrites(this, masterList[this.target]);
            }
            this.initted = true;
            return;
        }// end function

        public function render(param1:uint) : void
        {
            var _loc_2:* = NaN;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = (param1 - this.startTime) * 0.001;
            if ((param1 - this.startTime) * 0.001 >= this.duration)
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

        public function clear() : void
        {
            var _loc_1:* = undefined;
            this.tweens = [];
            var _loc_2:* = {ease:this.vars.ease};
            _loc_1 = {ease:this.vars.ease};
            this.exposedVars = _loc_2;
            this.vars = _loc_1;
            _hasUpdate = false;
            return;
        }// end function

        protected function easeProxy(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            return this.vars.proxiedEase.apply(null, arguments.concat(this.vars.easeParams));
        }// end function

        public function killVars(param1:Object) : void
        {
            if (overwriteManager.enabled)
            {
                overwriteManager.killVars(param1, this.exposedVars, this.tweens);
            }
            return;
        }// end function

        public function complete(param1:Boolean = false) : void
        {
            var _loc_2:* = 0;
            if (!param1)
            {
                if (!this.initted)
                {
                    initTweenVals();
                }
                this.startTime = currentTime - this.duration * 1000 / this.combinedTimeScale;
                render(currentTime);
                return;
            }
            if (_hasPlugins)
            {
                _loc_2 = this.tweens.length - 1;
                while (_loc_2 > -1)
                {
                    
                    if (this.tweens[_loc_2].isPlugin && this.tweens[_loc_2].target.onComplete != null)
                    {
                        this.tweens[_loc_2].target.onComplete();
                    }
                    _loc_2 = _loc_2 - 1;
                }
            }
            if (this.vars.persist != true)
            {
                this.enabled = false;
            }
            if (this.vars.onComplete != null)
            {
                this.vars.onComplete.apply(null, this.vars.onCompleteParams);
            }
            return;
        }// end function

        public function activate() : void
        {
            var _loc_1:* = undefined;
            var _loc_2:Boolean = true;
            _loc_1 = true;
            this.active = _loc_2;
            this.started = _loc_1;
            if (!this.initted)
            {
                initTweenVals();
            }
            if (this.vars.onStart != null)
            {
                this.vars.onStart.apply(null, this.vars.onStartParams);
            }
            if (this.duration == 0.001)
            {
                var _loc_2:String = this;
                var _loc_3:* = this.startTime - 1;
                _loc_2.startTime = _loc_3;
            }
            return;
        }// end function

        public static function easeOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            var _loc_5:* = undefined;
            var _loc_6:* = param1 / param4;
            _loc_5 = param1 / param4;
            param1 = _loc_6;
            return (-param3) * _loc_5 * (param1 - 2) + param2;
        }// end function

        public static function updateAll(event:Event = null) : void
        {
            var _loc_5:* = undefined;
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_9:* = getTimer();
            _loc_5 = getTimer();
            currentTime = _loc_9;
            var _loc_6:* = _loc_5;
            var _loc_7:* = masterList;
            _loc_5 = 0;
            var _loc_8:* = _loc_7;
            for each (_loc_2 in _loc_8)
            {
                
                _loc_3 = _loc_2.length - 1;
                while (_loc_3 > -1)
                {
                    
                    var _loc_11:* = _loc_2[_loc_3];
                    _loc_4 = _loc_2[_loc_3];
                    if (_loc_11.active)
                    {
                        _loc_4.render(_loc_6);
                    }
                    else if (_loc_4.gc)
                    {
                        _loc_2.splice(_loc_3, 1);
                    }
                    else if (_loc_6 >= _loc_4.startTime)
                    {
                        _loc_4.activate();
                        _loc_4.render(_loc_6);
                    }
                    _loc_3 = _loc_3 - 1;
                }
            }
            return;
        }// end function

        public static function removeTween(param1:TweenLite, param2:Boolean = true) : void
        {
            if (param1 != null)
            {
                if (param2)
                {
                    param1.clear();
                }
                param1.enabled = false;
            }
            return;
        }// end function

        public static function killTweensOf(param1:Object = null, param2:Boolean = false) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            if (param1 != null && param1 in masterList)
            {
                _loc_3 = masterList[param1];
                _loc_4 = _loc_3.length - 1;
                while (_loc_4 > -1)
                {
                    
                    _loc_5 = _loc_3[_loc_4];
                    if (param2 && !_loc_5.gc)
                    {
                        _loc_5.complete(false);
                    }
                    _loc_5.clear();
                    _loc_4 = _loc_4 - 1;
                }
                delete masterList[param1];
            }
            return;
        }// end function

        public static function delayedCall(param1:Number, param2:Function, param3:Array = null) : TweenLite
        {
            return new TweenLite(param2, 0, {delay:param1, onComplete:param2, onCompleteParams:param3, overwrite:0});
        }// end function

        public static function from(param1:Object, param2:Number, param3:Object) : TweenLite
        {
            param3.runBackwards = true;
            return new TweenLite(param1, param2, param3);
        }// end function

        static function killGarbage(event:TimerEvent) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = masterList;
            var _loc_4:* = 0;
            var _loc_5:* = _loc_3;
            for (_loc_2 in _loc_5)
            {
                
                if (_loc_3[_loc_2].length != 0)
                {
                    continue;
                }
                delete _loc_3[_loc_2];
            }
            return;
        }// end function

        public static function to(param1:Object, param2:Number, param3:Object) : TweenLite
        {
            return new TweenLite(param1, param2, param3);
        }// end function

    }
}
