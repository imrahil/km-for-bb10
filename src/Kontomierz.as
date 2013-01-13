/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package
{
    import com.pauluz.bbapps.kontomierz.KontomierzContext;

    import flash.display.Sprite;

    import mx.logging.Log;
    import mx.logging.LogEventLevel;
    import mx.logging.targets.TraceTarget;

    import qnx.fuse.ui.theme.ThemeGlobals;

    [SWF(height="1280", width="768", backgroundColor="#0D1722", frameRate="30")]
    public class Kontomierz extends Sprite
    {
        protected var _context:KontomierzContext;

        public function Kontomierz()
        {
            ThemeGlobals.injectCSS( "CellRenderer{ mouseChildren:false; opaqueBackground:#FAFAFA;}" );

            CONFIG::debugMode
            {
                var logTarget:TraceTarget = new TraceTarget();
                logTarget.level = LogEventLevel.ALL;
                logTarget.includeDate = true;
                logTarget.includeTime = true;
                logTarget.includeCategory = true;
                logTarget.includeLevel = true;
                Log.addTarget(logTarget);
            }

            _context = new KontomierzContext(this);
        }
    }
}
