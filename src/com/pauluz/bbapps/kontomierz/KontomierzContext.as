/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz
{
    import com.pauluz.bbapps.kontomierz.controller.bootstraps.BootstrapCommands;
    import com.pauluz.bbapps.kontomierz.controller.bootstraps.BootstrapModels;
    import com.pauluz.bbapps.kontomierz.controller.bootstraps.BootstrapSignaltons;
    import com.pauluz.bbapps.kontomierz.controller.bootstraps.BootstrapViewMediators;
    import com.pauluz.bbapps.kontomierz.signals.RequestLoginStatusSignal;

    import flash.display.DisplayObjectContainer;

    import org.osflash.signals.Signal;
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
            new BootstrapModels(injector);
            new BootstrapSignaltons(injector);
            new BootstrapCommands(signalCommandMap);
            new BootstrapViewMediators(mediatorMap);

            var signal:Signal = this.injector.getInstance(RequestLoginStatusSignal);
            signal.dispatch();
        }
    }
}
