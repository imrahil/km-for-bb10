/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz
{
    import com.pauluz.bbapps.kontomierz.controller.bootstraps.StartupCommand;
    import com.pauluz.bbapps.kontomierz.signals.configure.StartupSignal;

    import flash.display.DisplayObjectContainer;

    import org.osflash.signals.ISignal;
    import org.robotlegs.mvcs.SignalContext;

    public class KontomierzContext extends SignalContext
    {
        public function KontomierzContext(contextView:DisplayObjectContainer = null, autoStartup:Boolean = true)
        {
            super(contextView, autoStartup);
        }

        /**
         *  The Startup Hook
         */
        override public function startup():void
        {
            signalCommandMap.mapSignalClass(StartupSignal, StartupCommand);

            var startupSignal:ISignal = injector.getInstance(StartupSignal);
            startupSignal.dispatch();
        }
    }
}
