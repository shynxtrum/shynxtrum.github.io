package gs.plugins
{
    import flash.filters.*;
    import gs.*;

    public class DropShadowFilterPlugin extends FilterPlugin
    {
        public static const VERSION:Number = 1;
        public static const API:Number = 1;

        public function DropShadowFilterPlugin()
        {
            this.propName = "dropShadowFilter";
            this.overwriteProps = ["dropShadowFilter"];
            return;
        }// end function

        override public function onInitTween(param1:Object, param2, param3:TweenLite) : Boolean
        {
            _target = param1;
            _type = DropShadowFilter;
            initFilter(param2, new DropShadowFilter(0, 45, 0, 0, 0, 0, 1, param2.quality || 2, param2.inner, param2.knockout, param2.hideObject));
            return true;
        }// end function

    }
}
