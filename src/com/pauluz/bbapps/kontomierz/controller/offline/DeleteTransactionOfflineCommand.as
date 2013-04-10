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
    import com.pauluz.bbapps.kontomierz.services.ISQLKontomierzService;
    import com.pauluz.bbapps.kontomierz.signals.DeleteTransactionOnlineSignal;
    import com.pauluz.bbapps.kontomierz.signals.offline.GetAllTransactionsOfflineSignal;
    import com.pauluz.bbapps.kontomierz.signals.offline.GetAllWalletTransactionsOfflineSignal;
    import com.probertson.data.QueuedStatement;
    import com.probertson.data.SQLRunner;

    import flash.data.SQLResult;

    import org.robotlegs.mvcs.SignalCommand;

    public final class DeleteTransactionOfflineCommand extends BaseOfflineCommand
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
        public var deleteTransactionOnlineSignal:DeleteTransactionOnlineSignal;

        [Inject]
        public var getAllWalletTransactionsOfflineSignal:GetAllWalletTransactionsOfflineSignal;

        [Inject]
        public var getAllTransactionsOfflineSignal:GetAllTransactionsOfflineSignal;

        /**
         * Method handle the logic for <code>DeleteTransactionOfflineCommand</code>
         */        
        override public function execute():void    
        {
            var stmts:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();

            if (transaction.id == -1)
            {
                stmts[stmts.length] = new QueuedStatement(SQLStatements.DROP_SYNC_TRANSACTION_DELETE_TRIGGER_SQL);
                stmts[stmts.length] = new QueuedStatement(SQLStatements.DELETE_TRANSACTION_BY_ID, {id: transaction.id});
                stmts[stmts.length] = new QueuedStatement(SQLStatements.CREATE_SYNC_TRANSACTION_DELETE_TRIGGER_SQL);
            }
            else
            {
                stmts[stmts.length] = new QueuedStatement(SQLStatements.DELETE_TRANSACTION_BY_ID, {id: transaction.id});
            }

            sqlRunner.executeModify(stmts, function(results:Vector.<SQLResult>):void { onDeleteTransactionComplete(results, transaction) }, databaseErrorHandler);
        }

        private function onDeleteTransactionComplete(results:Vector.<SQLResult>, transaction:TransactionVO):void
        {
            logger.debug(": onDeleteTransactionComplete");

            if (model.isConnected)
            {
                if (results && results.length > 0)
                {
                    deleteTransactionOnlineSignal.dispatch(transaction);
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
                    getAllTransactionsOfflineSignal.dispatch(model.selectedAccount.accountId);
                }
            }
        }
    }
}
