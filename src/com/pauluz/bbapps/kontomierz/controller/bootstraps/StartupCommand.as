/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller.bootstraps
{
    import com.pauluz.bbapps.kontomierz.signals.configure.*;

    import org.osflash.signals.ISignal;

    import org.robotlegs.mvcs.SignalCommand;

    public class StartupCommand extends SignalCommand
    {
        override public function execute():void
        {
            signalCommandMap.mapSignalClass(ConfigureControllerSignal, ConfigureControllerCommand);
            signalCommandMap.mapSignalClass(ConfigureSignaltonsSignal, ConfigureSignaltonsCommand);
            signalCommandMap.mapSignalClass(ConfigureDatabaseSignal, ConfigureDatabaseCommand);
            signalCommandMap.mapSignalClass(ConfigureServiceSignal, ConfigureServiceCommand);
            signalCommandMap.mapSignalClass(ConfigureModelSignal, ConfigureModelCommand);
            signalCommandMap.mapSignalClass(ConfigureViewMediatorsSignal, ConfigureViewMediatorsCommand);
            signalCommandMap.mapSignalClass(ConfigureMainViewSignal, ConfigureMainViewCommand);

            var nextStepSignal:ISignal = injector.getInstance(ConfigureControllerSignal);
            nextStepSignal.dispatch();
        }
    }
}
