package gs
{

    public class OverwriteManager extends Object
    {
        public static const ALL:int = 1;
        public static var mode:int;
        public static const CONCURRENT:int = 3;
        public static const NONE:int = 0;
        public static var enabled:Boolean;
        public static const AUTO:int = 2;
        public static const version:Number = 3.12;

        public function OverwriteManager()
        {
            return;
        }// end function

        public static function killVars(param1:Object, param2:Object, param3:Array) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            _loc_4 = param3.length - 1;
            while (_loc_4 > -1)
            {
                
                var _loc_9:* = param3[_loc_4];
                _loc_6 = param3[_loc_4];
                if (_loc_9.name in param1)
                {
                    param3.splice(_loc_4, 1);
                }
                else if (_loc_6.isPlugin && _loc_6.name == "_MULTIPLE_")
                {
                    _loc_6.target.killProps(param1);
                    if (_loc_6.target.overwriteProps.length == 0)
                    {
                        param3.splice(_loc_4, 1);
                    }
                }
                _loc_4 = _loc_4 - 1;
            }
            var _loc_7:* = 0;
            var _loc_8:* = param1;
            for (_loc_5 in _loc_8)
            {
                
                delete param2[_loc_5];
            }
            return;
        }// end function

        public static function manageOverwrites(param1:TweenLite, param2:Array) : void
        {
            var _loc_11:* = undefined;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = param1.vars;
            var _loc_15:* = param1.vars.overwrite != undefined ? (int(_loc_10.overwrite)) : (mode);
            _loc_11 = param1.vars.overwrite != undefined ? (int(_loc_10.overwrite)) : (mode);
            if (_loc_15 < 2 || param2 == null)
            {
                return;
            }
            var _loc_12:* = param1.startTime;
            var _loc_13:* = [];
            var _loc_14:* = -1;
            _loc_3 = param2.length - 1;
            while (_loc_3 > -1)
            {
                
                var _loc_15:* = param2[_loc_3];
                _loc_4 = param2[_loc_3];
                if (_loc_15 != param1)
                {
                    if (_loc_3 < _loc_14 && _loc_4.startTime <= _loc_12 && _loc_4.startTime + _loc_4.duration * 1000 / _loc_4.combinedTimeScale > _loc_12)
                    {
                        _loc_13[_loc_13.length] = _loc_4;
                    }
                }
                else
                {
                    _loc_14 = _loc_3;
                }
                _loc_3 = _loc_3 - 1;
            }
            if (_loc_13.length == 0 || param1.tweens.length == 0)
            {
                return;
            }
            if (_loc_11 != AUTO)
            {
                _loc_3 = _loc_13.length - 1;
                while (_loc_3 > -1)
                {
                    
                    _loc_13[_loc_3].enabled = false;
                    _loc_3 = _loc_3 - 1;
                }
            }
            else
            {
                _loc_5 = param1.tweens;
                _loc_6 = {};
                _loc_3 = _loc_5.length - 1;
                while (_loc_3 > -1)
                {
                    
                    var _loc_15:* = _loc_5[_loc_3];
                    _loc_8 = _loc_5[_loc_3];
                    if (_loc_15.isPlugin)
                    {
                        if (_loc_8.name != "_MULTIPLE_")
                        {
                            _loc_6[_loc_8.name] = true;
                        }
                        else
                        {
                            var _loc_15:* = _loc_8.target.overwriteProps;
                            _loc_9 = _loc_8.target.overwriteProps;
                            _loc_7 = _loc_15.length - 1;
                            while (_loc_7 > -1)
                            {
                                
                                _loc_6[_loc_9[_loc_7]] = true;
                                _loc_7 = _loc_7 - 1;
                            }
                        }
                        _loc_6[_loc_8.target.propName] = true;
                    }
                    else
                    {
                        _loc_6[_loc_8.name] = true;
                    }
                    _loc_3 = _loc_3 - 1;
                }
                _loc_3 = _loc_13.length - 1;
                while (_loc_3 > -1)
                {
                    
                    killVars(_loc_6, _loc_13[_loc_3].exposedVars, _loc_13[_loc_3].tweens);
                    _loc_3 = _loc_3 - 1;
                }
            }
            return;
        }// end function

        public static function init(param1:int = 2) : int
        {
            if (TweenLite.version < 10.09)
            {
                trace("TweenLite warning: Your TweenLite class needs to be updated to work with OverwriteManager (or you may need to clear your ASO files). Please download and install the latest version from http://www.tweenlite.com.");
            }
            TweenLite.overwriteManager = OverwriteManager;
            mode = param1;
            enabled = true;
            return mode;
        }// end function

    }
}
