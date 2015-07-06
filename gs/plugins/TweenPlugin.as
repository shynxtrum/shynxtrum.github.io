package gs.plugins
{
    import gs.*;
    import gs.utils.tween.*;

    public class TweenPlugin extends Object
    {
        public var overwriteProps:Array;
        protected var _tweens:Array;
        protected var _changeFactor:Number = 0;
        public var propName:String;
        public var round:Boolean;
        public var onComplete:Function;
        public static const VERSION:Number = 1.03;
        public static const API:Number = 1;

        public function TweenPlugin()
        {
            _tweens = [];
            return;
        }// end function

        public function onInitTween(param1:Object, param2, param3:TweenLite) : Boolean
        {
            addTween(param1, this.propName, param1[this.propName], param2, this.propName);
            return true;
        }// end function

        protected function updateTweens(param1:Number) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = NaN;
            var _loc_5:* = 0;
            if (this.round)
            {
                _loc_2 = _tweens.length - 1;
                while (_loc_2 > -1)
                {
                    
                    _loc_3 = _tweens[_loc_2];
                    var _loc_6:* = _loc_3.start + _loc_3.change * param1;
                    _loc_4 = _loc_3.start + _loc_3.change * param1;
                    _loc_5 = _loc_6 < 0 ? (-1) : (1);
                    _loc_3.target[_loc_3.property] = _loc_4 % 1 * _loc_5 > 0.5 ? (int(_loc_4) + _loc_5) : (int(_loc_4));
                    _loc_2 = _loc_2 - 1;
                }
            }
            else
            {
                _loc_2 = _tweens.length - 1;
                while (_loc_2 > -1)
                {
                    
                    _loc_3 = _tweens[_loc_2];
                    _loc_3.target[_loc_3.property] = _loc_3.start + _loc_3.change * param1;
                    _loc_2 = _loc_2 - 1;
                }
            }
            return;
        }// end function

        public function killProps(param1:Object) : void
        {
            var _loc_2:* = 0;
            _loc_2 = this.overwriteProps.length - 1;
            while (_loc_2 > -1)
            {
                
                if (this.overwriteProps[_loc_2] in param1)
                {
                    this.overwriteProps.splice(_loc_2, 1);
                }
                _loc_2 = _loc_2 - 1;
            }
            _loc_2 = _tweens.length - 1;
            while (_loc_2 > -1)
            {
                
                if (_tweens[_loc_2].name in param1)
                {
                    _tweens.splice(_loc_2, 1);
                }
                _loc_2 = _loc_2 - 1;
            }
            return;
        }// end function

        protected function addTween(param1:Object, param2:String, param3:Number, param4, param5:String = null) : void
        {
            var _loc_6:* = NaN;
            if (param4 != null)
            {
                var _loc_7:* = typeof(param4) != "number" ? (Number(param4)) : (param4 - param3);
                _loc_6 = typeof(param4) != "number" ? (Number(param4)) : (param4 - param3);
                if (_loc_7 != 0)
                {
                    _tweens[_tweens.length] = new TweenInfo(param1, param2, param3, _loc_6, param5 || param2, false);
                }
            }
            return;
        }// end function

        public function set changeFactor(param1:Number) : void
        {
            updateTweens(param1);
            _changeFactor = param1;
            return;
        }// end function

        public function get changeFactor() : Number
        {
            return _changeFactor;
        }// end function

        public static function activate(param1:Array) : Boolean
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            _loc_2 = param1.length - 1;
            while (_loc_2 > -1)
            {
                
                _loc_3 = new param1[_loc_2];
                TweenLite.plugins[_loc_3.propName] = param1[_loc_2];
                _loc_2 = _loc_2 - 1;
            }
            return true;
        }// end function

    }
}
