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
    import com.useitbetter.modules.minipanel.uMiniPanel;
    import com.useitbetter.uDash;
    import com.useitbetter.uSettings;

    import flash.display.Sprite;
    import flash.events.Event;

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
            if (stage)
            {
                init()
            }
            else
            {
                this.addEventListener(Event.ADDED_TO_STAGE, init)
            }
        }

        private function init(e:Event = null):void
        {
//            uSettings.uProjectName = "Kontomierz";
//            uSettings.uProjectApiPass = "b0bced19bf2f61b0484b5399c75405bb";
//            uSettings.uPort = 57932;
//
//            stage.addChild(uDash.init());
//            stage.addChild(new uMiniPanel());

            ThemeGlobals.injectCSS("CellRenderer{ mouseChildren:false; opaqueBackground:#FAFAFA;}");

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
