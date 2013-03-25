/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller
{
    import com.destroytoday.core.IPromise;
    import com.pauluz.bbapps.kontomierz.model.vo.ErrorVO;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ErrorSignal;

    import org.robotlegs.mvcs.SignalCommand;

    public class BaseOnlineCommand extends SignalCommand
    {
        [Inject]
        public var errorSignal:ErrorSignal;

        protected function onError(promise:IPromise):void
        {
            var error:ErrorVO = new ErrorVO("Wystąpił błąd: " + promise.error.message);
            errorSignal.dispatch(error)
        }
    }
}
