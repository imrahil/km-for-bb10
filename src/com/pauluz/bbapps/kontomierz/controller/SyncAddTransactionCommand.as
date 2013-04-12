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

    import org.robotlegs.mvcs.SignalCommand;

    public final class SyncAddTransactionCommand extends BaseOnlineCommand
    {
        /** PARAMETERS **/
        [Inject]
        public var transaction:TransactionVO;

        /** MODEL **/
        [Inject]
        public var model:IKontomierzModel;

        /** INJECTIONS **/
        [Inject]
        public var kontomierzService:IKontomierzService;

        [Inject]
        public var sqlService:ISQLKontomierzService;

        /**
         * Method handle the logic for <code>SyncAddTransactionCommand</code>
         */        
        override public function execute():void    
        {
            var promise:IPromise = kontomierzService.createTransaction(transaction);
            promise.completed.addOnce(onAddTransaction);
            promise.failed.addOnce(onError);
        }

        /**
         *  COMPLETE HANDLER
         */
        private function onAddTransaction(promise:IPromise):void
        {
            sqlService.deleteSyncInsertTransaction(transaction.id);
            sqlService.deleteSyncUpdatedTransaction(transaction.id);

            if (model.totalSyncCount > 0)
            {
                model.totalSyncCount--;

                if (model.totalSyncCount == 0)
                {
                    model.syncRequired = false;
                    model.syncInProgress = false;
                }
            }
        }

        /**
         *  ERROR HANDLER
         */
        override protected function onError(promise:IPromise):void
        {
        }
    }
}
