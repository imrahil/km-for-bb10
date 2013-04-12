/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.services.helpers
{
    import com.pauluz.bbapps.kontomierz.constants.SQLStatements;
    import com.pauluz.bbapps.kontomierz.signals.configure.ConfigureModelSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.probertson.data.QueuedStatement;
    import com.probertson.data.SQLRunner;

    import flash.data.SQLResult;
    import flash.errors.SQLError;
    import flash.events.SQLErrorEvent;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.Actor;

    public class DatabaseCreator extends Actor
    {
        protected var logger:ILogger;

        [Inject]
        public var sqlRunner:SQLRunner;

        [Inject]
        public var nextStepSignal:ConfigureModelSignal;

          // ------- SQL statements -------
        private static const CREATE_ACCOUNTS_TABLE_SQL:String = new SQLStatements.CreateAccountsTableStatementText();

        private static const CREATE_TRANSACTIONS_TABLE_SQL:String = new SQLStatements.CreateTransactionsTableStatementText();
        private static const CREATE_SYNC_INSERT_TABLE_SQL:String = new SQLStatements.CreateSyncInsertTableStatementText();
        private static const CREATE_SYNC_UPDATE_TABLE_SQL:String = new SQLStatements.CreateSyncUpdateTableStatementText();
        private static const CREATE_SYNC_DELETE_TABLE_SQL:String = new SQLStatements.CreateSyncDeleteTableStatementText();
        private static const CREATE_SYNC_TRANSACTION_INSERT_TRIGGER_SQL:String = new SQLStatements.CreateSyncTransactionInsertTriggerStatementText();
        private static const CREATE_SYNC_TRANSACTION_UPDATE_TRIGGER_SQL:String = new SQLStatements.CreateSyncTransactionUpdateTriggerStatementText();
        private static const CREATE_SYNC_TRANSACTION_DELETE_TRIGGER_SQL:String = new SQLStatements.CreateSyncTransactionDeleteTriggerStatementText();

        private static const CREATE_CATEGORIES_TABLE_SQL:String = new SQLStatements.CreateCategoriesTableStatementText();
        private static const CREATE_CURRENCIES_TABLE_SQL:String = new SQLStatements.CreateCurrenciesTableStatementText();
        private static const CREATE_USER_TABLE_SQL:String = new SQLStatements.CreateUserTableStatementText();


        public function DatabaseCreator()
        {
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        public function createDatabaseStructure():void
        {
            var stmts:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
            stmts[stmts.length] = new QueuedStatement(CREATE_ACCOUNTS_TABLE_SQL);

            stmts[stmts.length] = new QueuedStatement(CREATE_TRANSACTIONS_TABLE_SQL);
            stmts[stmts.length] = new QueuedStatement(CREATE_SYNC_INSERT_TABLE_SQL);
            stmts[stmts.length] = new QueuedStatement(CREATE_SYNC_UPDATE_TABLE_SQL);
            stmts[stmts.length] = new QueuedStatement(CREATE_SYNC_DELETE_TABLE_SQL);

            // triggers for transactions table
            stmts[stmts.length] = new QueuedStatement(CREATE_SYNC_TRANSACTION_INSERT_TRIGGER_SQL);
            stmts[stmts.length] = new QueuedStatement(CREATE_SYNC_TRANSACTION_UPDATE_TRIGGER_SQL);
            stmts[stmts.length] = new QueuedStatement(CREATE_SYNC_TRANSACTION_DELETE_TRIGGER_SQL);

            // TODO - add triggers for other editable tables

            stmts[stmts.length] = new QueuedStatement(CREATE_CATEGORIES_TABLE_SQL);
            stmts[stmts.length] = new QueuedStatement(CREATE_CURRENCIES_TABLE_SQL);
            stmts[stmts.length] = new QueuedStatement(CREATE_USER_TABLE_SQL);

            sqlRunner.executeModify(stmts, allQueriesComplete, executeBatchError, null);
        }

        private function allQueriesComplete(results:Vector.<SQLResult>):void
        {
            logger.debug(": allQueriesComplete");

            nextStepSignal.dispatch();
        }

        private function executeBatchError(error:SQLError):void
        {
            logger.debug(": executeBatchError - " + error.details);

            dispatch(new SQLErrorEvent(SQLErrorEvent.ERROR, false, false, error));
        }
    }
}