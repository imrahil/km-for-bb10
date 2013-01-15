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
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllTransactionsSignal;

    import org.robotlegs.mvcs.SignalCommand;

    public final class GetAllWalletTransactionsCommand extends SignalCommand
    {
        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var kontomierzService:IKontomierzService;

        [Inject]
        public var provideAllTransactionsSignal:ProvideAllTransactionsSignal;

        /**
         * Method handle the logic for <code>GetAllTransactionsCommand</code>
         */
        override public function execute():void
        {
            if (!model.isWalletListExpired && model.walletTransactionsList && model.walletTransactionsList.length > 0)
            {
                provideAllTransactionsSignal.dispatch(model.walletTransactionsList);
            }
            else
            {
                kontomierzService.getAllTransactions(model.defaultWalletId, true);
            }
        }
    }
}
