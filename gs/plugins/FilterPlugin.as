package gs.plugins
{
    import flash.filters.*;
    import gs.utils.tween.*;

    public class FilterPlugin extends TweenPlugin
    {
        protected var _index:int;
        protected var _remove:Boolean;
        protected var _target:Object;
        protected var _filter:BitmapFilter;
        protected var _type:Class;
        public static const VERSION:Number = 1.03;
        public static const API:Number = 1;

        public function FilterPlugin()
        {
            return;
        }// end function

        protected function initFilter(param1:Object, param2:BitmapFilter) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = _target.filters;
            _index = -1;
            if (param1.index == null)
            {
                _loc_4 = _loc_6.length - 1;
                while (_loc_4 > -1)
                {
                    
                    if (_loc_6[_loc_4] is _type)
                    {
                        _index = _loc_4;
                    }
                    _loc_4 = _loc_4 - 1;
                }
            }
            else
            {
                _index = param1.index;
            }
            if (_index == -1 || _loc_6[_index] == null || param1.addFilter == true)
            {
                _index = param1.index == null ? (_loc_6.length) : (param1.index);
                _loc_6[_index] = param2;
                _target.filters = _loc_6;
            }
            _filter = _loc_6[_index];
            _remove = Boolean(param1.remove == true);
            if (_remove)
            {
                this.onComplete = onCompleteTween;
            }
            var _loc_7:* = param1.isTV != true ? (param1) : (param1.exposedVars);
            var _loc_8:* = 0;
            var _loc_9:* = _loc_7;
            for (_loc_3 in _loc_9)
            {
                
                if (!(_loc_3 in _filter) || _filter[_loc_3] == _loc_7[_loc_3] || _loc_3 == "remove" || _loc_3 == "index" || _loc_3 == "addFilter")
                {
                    continue;
                }
                if (_loc_3 == "color" || _loc_3 == "highlightColor" || _loc_3 == "shadowColor")
                {
                    var _loc_12:* = new HexColorsPlugin();
                    _loc_5 = new HexColorsPlugin();
                    _loc_12.initColor(_filter, _loc_3, _filter[_loc_3], _loc_7[_loc_3]);
                    _tweens[_tweens.length] = new TweenInfo(_loc_5, "changeFactor", 0, 1, _loc_3, false);
                    continue;
                }
                if (_loc_3 == "quality" || _loc_3 == "inner" || _loc_3 == "knockout" || _loc_3 == "hideObject")
                {
                    _filter[_loc_3] = _loc_7[_loc_3];
                    continue;
                }
                addTween(_filter, _loc_3, _filter[_loc_3], _loc_7[_loc_3], _loc_3);
            }
            return;
        }// end function

        public function onCompleteTween() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            if (_remove)
            {
                _loc_2 = _target.filters;
                if (_loc_2[_index] is _type)
                {
                    _loc_2.splice(_index, 1);
                }
                else
                {
                    _loc_1 = _loc_2.length - 1;
                    while (_loc_1 > -1)
                    {
                        
                        if (_loc_2[_loc_1] is _type)
                        {
                            _loc_2.splice(_loc_1, 1);
                            break;
                        }
                        _loc_1 = _loc_1 - 1;
                    }
                }
                _target.filters = _loc_2;
            }
            return;
        }// end function

        override public function set changeFactor(param1:Number) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = _target.filters;
            _loc_2 = _tweens.length - 1;
            while (_loc_2 > -1)
            {
                
                _loc_3 = _tweens[_loc_2];
                _loc_3.target[_loc_3.property] = _loc_3.start + _loc_3.change * param1;
                _loc_2 = _loc_2 - 1;
            }
            if (!(_loc_4[_index] is _type))
            {
                _index = _loc_4.length - 1;
                _loc_2 = _loc_4.length - 1;
                while (_loc_2 > -1)
                {
                    
                    if (_loc_4[_loc_2] is _type)
                    {
                        _index = _loc_2;
                    }
                    _loc_2 = _loc_2 - 1;
                }
            }
            _loc_4[_index] = _filter;
            _target.filters = _loc_4;
            return;
        }// end function

    }
}
