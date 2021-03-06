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
    import com.pauluz.bbapps.kontomierz.signals.GetAllAccountsOnlineSignal;
    import com.pauluz.bbapps.kontomierz.signals.offline.GetAllAccountsOfflineSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllAccountsDataSignal;

    import org.robotlegs.mvcs.SignalCommand;

    public final class ProvideAllAccountsCommand extends SignalCommand
    {
        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var provideAllAccountsDataSignal:ProvideAllAccountsDataSignal;

        [Inject]
        public var getAllAccountsOnlineSignal:GetAllAccountsOnlineSignal;

        [Inject]
        public var getAllAccountsOfflineSignal:GetAllAccountsOfflineSignal;

        /**
         * Method handle the logic for <code>GetAllAccountsCommand</code>
         */
        override public function execute():void
        {
            if (model.accountsList)
            {
                provideAllAccountsDataSignal.dispatch(model.accountsList);
            }
            else
            {
                if (model.demoMode)
                {
                    getAllAccountsOnlineSignal.dispatch();
                }
                else
                {
                    getAllAccountsOfflineSignal.dispatch();
                }
            }
        }
    }
}
