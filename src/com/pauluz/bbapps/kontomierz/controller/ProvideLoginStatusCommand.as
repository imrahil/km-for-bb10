/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller 
{
    import com.pauluz.bbapps.kontomierz.constants.ApplicationConstants;
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideLoginStatusSignal;

    import flash.net.SharedObject;

    import org.robotlegs.mvcs.SignalCommand;

    public final class ProvideLoginStatusCommand extends SignalCommand
    {
        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var provideLoginStatusSignal:ProvideLoginStatusSignal;

        /**
         * Method handle the logic for <code>ProvideLoginStatusCommand</code>
         */        
        override public function execute():void    
        {
            var sessionSO:SharedObject = SharedObject.getLocal(ApplicationConstants.KONTOMIERZ_SO_NAME);

            if (sessionSO.data.apiKey != undefined)
            {
                model.apiKey = sessionSO.data.apiKey;

                provideLoginStatusSignal.dispatch(ApplicationConstants.LOGIN_STATUS_REMEMBERED);
            }
            else
            {
                provideLoginStatusSignal.dispatch(ApplicationConstants.LOGIN_STATUS_NEW);
            }
        }
    }
}
