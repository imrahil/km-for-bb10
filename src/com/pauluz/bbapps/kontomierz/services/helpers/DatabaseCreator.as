/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.services.helpers
{
    import com.pauluz.bbapps.kontomierz.signals.configure.ConfigureModelSignal;
    import com.probertson.data.QueuedStatement;
    import com.probertson.data.SQLRunner;

    import flash.data.SQLResult;
    import flash.errors.SQLError;
    import flash.events.SQLErrorEvent;

    import org.robotlegs.mvcs.Actor;

    public class DatabaseCreator extends Actor
    {
        [Inject]
        public var sqlRunner:SQLRunner;

        [Inject]
        public var nextStepSignal:ConfigureModelSignal;

          // ------- SQL statements -------
        [Embed(source="/assets/sql/CreateAccountsTable.sql", mimeType="application/octet-stream")]
        private static const CreateAccountsTableStatementText:Class;

        [Embed(source="/assets/sql/CreateTransactionsTable.sql", mimeType="application/octet-stream")]
        private static const CreateTransactionsTableStatementText:Class;

        [Embed(source="/assets/sql/CreateCategoriesTable.sql", mimeType="application/octet-stream")]
        private static const CreateCategoriesTableStatementText:Class;

        [Embed(source="/assets/sql/CreateCurrenciesTable.sql", mimeType="application/octet-stream")]
        private static const CreateCurrenciesTableStatementText:Class;

        [Embed(source="/assets/sql/CreateUserTable.sql", mimeType="application/octet-stream")]
        private static const CreateUserTableStatementText:Class;

        private static const CREATE_ACCOUNTS_TABLE_SQL:String = new CreateAccountsTableStatementText();
        private static const CREATE_TRANSACTIONS_TABLE_SQL:String = new CreateTransactionsTableStatementText();
        private static const CREATE_CATEGORIES_TABLE_SQL:String = new CreateCategoriesTableStatementText();
        private static const CREATE_CURRENCIES_TABLE_SQL:String = new CreateCurrenciesTableStatementText();
        private static const CREATE_USER_TABLE_SQL:String = new CreateUserTableStatementText();

        public function createDatabaseStructure():void
        {
            var stmts:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
            stmts[stmts.length] = new QueuedStatement(CREATE_ACCOUNTS_TABLE_SQL);
            stmts[stmts.length] = new QueuedStatement(CREATE_TRANSACTIONS_TABLE_SQL);
            stmts[stmts.length] = new QueuedStatement(CREATE_CATEGORIES_TABLE_SQL);
            stmts[stmts.length] = new QueuedStatement(CREATE_CURRENCIES_TABLE_SQL);
            stmts[stmts.length] = new QueuedStatement(CREATE_USER_TABLE_SQL);

            sqlRunner.executeModify(stmts, executeBatchComplete, executeBatchError, null);
        }
        
        private function executeBatchComplete(results:Vector.<SQLResult>):void
        {
            nextStepSignal.dispatch();
        }
        
        private function executeBatchError(error:SQLError):void
        {
            dispatch(new SQLErrorEvent(SQLErrorEvent.ERROR, false, false, error));
        }
    }
}