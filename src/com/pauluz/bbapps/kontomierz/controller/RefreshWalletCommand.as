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
    import com.pauluz.bbapps.kontomierz.signals.GetAllWalletTransactionsOnlineSignal;
    import com.pauluz.bbapps.kontomierz.signals.offline.GetAllWalletTransactionsOfflineSignal;

    import org.robotlegs.mvcs.SignalCommand;

    public final class RefreshWalletCommand extends SignalCommand
    {
        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var getAllWalletTransactionsOnlineSignal:GetAllWalletTransactionsOnlineSignal;

        [Inject]
        public var getAllWalletTransactionsOfflineSignal:GetAllWalletTransactionsOfflineSignal;

        /**
         * Method handle the logic for <code>RefreshWalletCommand</code>
         */        
        override public function execute():void    
        {
            if (model.defaultWallet)
            {
                model.defaultWallet.isValid = false;

                if (model.isConnected)
                {
                    getAllWalletTransactionsOnlineSignal.dispatch();
                }
                else
                {
                    getAllWalletTransactionsOfflineSignal.dispatch();
                }
            }
        }
    }
}
