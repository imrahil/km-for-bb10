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
    import com.pauluz.bbapps.kontomierz.services.IKontomierzService;
    import com.pauluz.bbapps.kontomierz.services.ISQLKontomierzService;
    import com.pauluz.bbapps.kontomierz.signals.offline.GetAllTransactionsOfflineSignal;
    import com.pauluz.bbapps.kontomierz.signals.offline.GetAllWalletTransactionsOfflineSignal;

    public final class DeleteTransactionOnlineCommand extends BaseOnlineCommand
    {
        /** PARAMETERS **/
        [Inject]
        public var transactionId:int;

        [Inject]
        public var isWallet:Boolean;

        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var kontomierzService:IKontomierzService;

        [Inject]
        public var sqlService:ISQLKontomierzService;

        [Inject]
        public var getAllTransactionsOfflineSignal:GetAllTransactionsOfflineSignal;

        [Inject]
        public var getAllWalletTransactionsOfflineSignal:GetAllWalletTransactionsOfflineSignal;


        /**
         * Method handle the logic for <code>DeleteTransactionCommand</code>
         */        
        override public function execute():void    
        {
            var promise:IPromise = kontomierzService.deleteTransaction(transactionId);
            promise.completed.addOnce(onDeleteTransaction);
            promise.failed.addOnce(onError);
        }

        /**
         *  COMPLETE HANDLER
         */
        private function onDeleteTransaction(promise:IPromise):void
        {
            sqlService.deleteSyncDeletedTransaction(transactionId);

            if (isWallet)
            {
                model.defaultWallet.isValid = false;
                getAllWalletTransactionsOfflineSignal.dispatch();
            }
            else
            {
                model.selectedAccount.isValid = false;
                getAllTransactionsOfflineSignal.dispatch();
            }
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
