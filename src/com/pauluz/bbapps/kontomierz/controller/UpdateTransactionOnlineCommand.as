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
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.services.IKontomierzService;
    import com.pauluz.bbapps.kontomierz.services.ISQLKontomierzService;
    import com.pauluz.bbapps.kontomierz.signals.offline.GetAllTransactionsOfflineSignal;
    import com.pauluz.bbapps.kontomierz.signals.offline.GetAllWalletTransactionsOfflineSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideSelectedTransactionSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.TransactionSuccessfullySavedSignal;

    public final class UpdateTransactionOnlineCommand extends BaseOnlineCommand
    {
        /** PARAMETERS **/
        [Inject]
        public var transaction:TransactionVO;

        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var kontomierzService:IKontomierzService;

        [Inject]
        public var sqlService:ISQLKontomierzService;

        [Inject]
        public var transactionSuccessfullySavedSignal:TransactionSuccessfullySavedSignal;

        [Inject]
        public var provideSelectedTransactionSignal:ProvideSelectedTransactionSignal;

        [Inject]
        public var getAllTransactionsOfflineSignal:GetAllTransactionsOfflineSignal;

        [Inject]
        public var getAllWalletTransactionsOfflineSignal:GetAllWalletTransactionsOfflineSignal;

        /**
         * Method handle the logic for <code>UpdateTransactionCommand</code>
         */        
        override public function execute():void    
        {
            var promise:IPromise = kontomierzService.updateTransaction(transaction);
            promise.completed.addOnce(onUpdateTransaction);
            promise.failed.addOnce(onError);
        }

        /**
         *  COMPLETE HANDLER
         */
        private function onUpdateTransaction(promise:IPromise):void
        {
            sqlService.deleteSyncUpdatedTransaction(transaction.id);

            if (transaction.isWallet)
            {
                model.defaultWallet.isValid = false;
                getAllWalletTransactionsOfflineSignal.dispatch();
            }
            else
            {
                model.selectedAccount.isValid = false;
                getAllTransactionsOfflineSignal.dispatch();
            }

            transactionSuccessfullySavedSignal.dispatch();
            provideSelectedTransactionSignal.dispatch(transaction);
        }

        /**
         *  ERROR HANDLER
         */
        override protected function onError(promise:IPromise):void
        {
            model.syncRequired = true;
        }
    }
}
