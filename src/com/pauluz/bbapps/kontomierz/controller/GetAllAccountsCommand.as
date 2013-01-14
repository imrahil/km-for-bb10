/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller 
{
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.services.IKontomierzService;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllAccountsDataSignal;

    import org.robotlegs.mvcs.SignalCommand;

    public final class GetAllAccountsCommand extends SignalCommand 
    {
        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var kontomierzService:IKontomierzService;

        [Inject]
        public var provideAllAccountsDataSignal:ProvideAllAccountsDataSignal;

        /**
         * Method handle the logic for <code>GetAllAccountsCommand</code>
         */        
        override public function execute():void    
        {
            if (model.accountsList && model.accountsList.length > 0)
            {
                provideAllAccountsDataSignal.dispatch(model.accountsList);
            }
            else
            {
                kontomierzService.getAllAccounts(model.apiKey);
            }
        }
    }
}
