package gs.plugins
{
    import gs.*;
    import gs.utils.tween.*;

    public class EndArrayPlugin extends TweenPlugin
    {
        protected var _a:Array;
        protected var _info:Array;
        public static const VERSION:Number = 1.01;
        public static const API:Number = 1;

        public function EndArrayPlugin()
        {
            _info = [];
            this.propName = "endArray";
            this.overwriteProps = ["endArray"];
            return;
        }// end function

        public function init(param1:Array, param2:Array) : void
        {
            _a = param1;
            var _loc_3:* = param2.length - 1;
            while (_loc_3 > -1)
            {
                
                if (param1[_loc_3] != param2[_loc_3] && param1[_loc_3] != null)
                {
                    _info[_info.length] = new ArrayTweenInfo(_loc_3, _a[_loc_3], param2[_loc_3] - _a[_loc_3]);
                }
                _loc_3 = _loc_3 - 1;
            }
            return;
        }// end function

        override public function onInitTween(param1:Object, param2, param3:TweenLite) : Boolean
        {
            if (!(param1 is Array) || !(param2 is Array))
            {
                return false;
            }
            init(param1 as Array, param2);
            return true;
        }// end function

        override public function set changeFactor(param1:Number) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = NaN;
            var _loc_5:* = 0;
            if (this.round)
            {
                _loc_2 = _info.length - 1;
                while (_loc_2 > -1)
                {
                    
                    _loc_3 = _info[_loc_2];
                    var _loc_6:* = _loc_3.start + _loc_3.change * param1;
                    _loc_4 = _loc_3.start + _loc_3.change * param1;
                    _loc_5 = _loc_6 < 0 ? (-1) : (1);
                    _a[_loc_3.index] = _loc_4 % 1 * _loc_5 > 0.5 ? (int(_loc_4) + _loc_5) : (int(_loc_4));
                    _loc_2 = _loc_2 - 1;
                }
            }
            else
            {
                _loc_2 = _info.length - 1;
                while (_loc_2 > -1)
                {
                    
                    _loc_3 = _info[_loc_2];
                    _a[_loc_3.index] = _loc_3.start + _loc_3.change * param1;
                    _loc_2 = _loc_2 - 1;
                }
            }
            return;
        }// end function

    }
}
