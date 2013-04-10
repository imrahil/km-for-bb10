/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller.offline
{
    import com.pauluz.bbapps.kontomierz.constants.SQLStatements;
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.signals.UpdateTransactionOnlineSignal;
    import com.pauluz.bbapps.kontomierz.signals.offline.GetAllTransactionsOfflineSignal;
    import com.pauluz.bbapps.kontomierz.signals.offline.GetAllWalletTransactionsOfflineSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideSelectedTransactionSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.TransactionSuccessfullySavedSignal;
    import com.probertson.data.QueuedStatement;
    import com.probertson.data.SQLRunner;

    import flash.data.SQLResult;

    public final class UpdateTransactionOfflineCommand extends BaseOfflineCommand
    {
        /** PARAMETERS **/
        [Inject]
        public var transaction:TransactionVO;

        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var sqlRunner:SQLRunner;

        [Inject]
        public var transactionSuccessfullySavedSignal:TransactionSuccessfullySavedSignal;

        [Inject]
        public var provideSelectedTransactionSignal:ProvideSelectedTransactionSignal;

        [Inject]
        public var updateTransactionOnlineSignal:UpdateTransactionOnlineSignal;

        [Inject]
        public var getAllTransactionsOfflineSignal:GetAllTransactionsOfflineSignal;

        [Inject]
        public var getAllWalletTransactionsOfflineSignal:GetAllWalletTransactionsOfflineSignal;

        /**
         * Method handle the logic for <code>UpdateTransactionOfflineCommand</code>
         */        
        override public function execute():void    
        {
            var params:Object = {};

            params["id"] = transaction.id;

            params["currencyAmount"] = transaction.currencyAmount;
            params["transactionOn"] = transaction.transactionOn;
            params["description"] = transaction.description;
            params["currencyName"] = transaction.currencyName;
            params["categoryId"] = transaction.categoryId;
            params["categoryName"] = transaction.categoryName;

            var stmts:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();

            if (transaction.id == -1)
            {
                stmts[stmts.length] = new QueuedStatement(SQLStatements.DROP_SYNC_TRANSACTION_UPDATE_TRIGGER_SQL);
                stmts[stmts.length] = new QueuedStatement(SQLStatements.UPDATE_TRANSACTION_BY_ID, params);
                stmts[stmts.length] = new QueuedStatement(SQLStatements.CREATE_SYNC_TRANSACTION_UPDATE_TRIGGER_SQL);
            }
            else
            {
                stmts[stmts.length] = new QueuedStatement(SQLStatements.UPDATE_TRANSACTION_BY_ID, params);
            }

            sqlRunner.executeModify(stmts, function(results:Vector.<SQLResult>):void { onUpdateTransactionComplete(results, transaction) }, databaseErrorHandler);
        }

        private function onUpdateTransactionComplete(results:Vector.<SQLResult>, transaction:TransactionVO):void
        {
            logger.debug(": onUpdateTransactionComplete");

            if (model.isConnected)
            {
                if (results && results.length > 0)
                {
                    updateTransactionOnlineSignal.dispatch(transaction);
                }
            }
            else
            {
                model.syncRequired = true;

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
        }
    }
}
