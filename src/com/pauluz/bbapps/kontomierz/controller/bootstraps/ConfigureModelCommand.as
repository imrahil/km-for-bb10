/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller.bootstraps
{
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.model.KontomierzModel;
    import com.pauluz.bbapps.kontomierz.signals.configure.ConfigureViewMediatorsSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.SignalCommand;

    public class ConfigureModelCommand extends SignalCommand
    {
        [Inject]
        public var nextStepSignal:ConfigureViewMediatorsSignal;

        override public function execute():void
        {
            var logger:ILogger = LogUtil.getLogger(this);
            logger.debug(": execute");

            injector.mapSingletonOf(IKontomierzModel, KontomierzModel);

            nextStepSignal.dispatch();
        }
    }
}