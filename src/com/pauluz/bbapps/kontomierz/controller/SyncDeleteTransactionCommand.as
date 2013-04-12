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

    public final class SyncDeleteTransactionCommand extends BaseOnlineCommand
    {
        /** PARAMETERS **/
        [Inject]
        public var transactionId:int;

        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var kontomierzService:IKontomierzService;

        [Inject]
        public var sqlService:ISQLKontomierzService;

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
