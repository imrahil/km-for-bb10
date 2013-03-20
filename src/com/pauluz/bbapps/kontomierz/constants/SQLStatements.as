/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.constants
{
    public class SQLStatements
    {
        // CREATE TABLES
        [Embed(source="/assets/sql/CreateAccountsTable.sql", mimeType="application/octet-stream")]
        public static const CreateAccountsTableStatementText:Class;

        [Embed(source="/assets/sql/CreateTransactionsTable.sql", mimeType="application/octet-stream")]
        public static const CreateTransactionsTableStatementText:Class;

        [Embed(source="/assets/sql/CreateCategoriesTable.sql", mimeType="application/octet-stream")]
        public static const CreateCategoriesTableStatementText:Class;

        [Embed(source="/assets/sql/CreateCurrenciesTable.sql", mimeType="application/octet-stream")]
        public static const CreateCurrenciesTableStatementText:Class;

        [Embed(source="/assets/sql/CreateUserTable.sql", mimeType="application/octet-stream")]
        public static const CreateUserTableStatementText:Class;


        // SYNC TABLES
        [Embed(source="/assets/sql/sync/CreateSyncInsertTable.sql", mimeType="application/octet-stream")]
        public static const CreateSyncInsertTableStatementText:Class;

        [Embed(source="/assets/sql/sync/CreateSyncUpdateTable.sql", mimeType="application/octet-stream")]
        public static const CreateSyncUpdateTableStatementText:Class;

        [Embed(source="/assets/sql/sync/CreateSyncDeleteTable.sql", mimeType="application/octet-stream")]
        public static const CreateSyncDeleteTableStatementText:Class;


        // TRIGGERS
        [Embed(source="/assets/sql/sync/CreateSyncTransactionInsertTrigger.sql", mimeType="application/octet-stream")]
        public static const CreateSyncTransactionInsertTriggerStatementText:Class;

        [Embed(source="/assets/sql/sync/CreateSyncTransactionUpdateTrigger.sql", mimeType="application/octet-stream")]
        public static const CreateSyncTransactionUpdateTriggerStatementText:Class;

        [Embed(source="/assets/sql/sync/CreateSyncTransactionDeleteTrigger.sql", mimeType="application/octet-stream")]
        public static const CreateSyncTransactionDeleteTriggerStatementText:Class;

        [Embed(source="/assets/sql/sync/DropSyncTransactionInsertTrigger.sql", mimeType="application/octet-stream")]
        public static const DropSyncTransactionInsertTriggerStatementText:Class;

        [Embed(source="/assets/sql/sync/DropSyncTransactionUpdateTrigger.sql", mimeType="application/octet-stream")]
        public static const DropSyncTransactionUpdateTriggerStatementText:Class;

        [Embed(source="/assets/sql/sync/DropSyncTransactionDeleteTrigger.sql", mimeType="application/octet-stream")]
        public static const DropSyncTransactionDeleteTriggerStatementText:Class;


        // API
        [Embed(source="/assets/sql/InsertAPIKey.sql", mimeType="application/octet-stream")]
        public static const InsertAPIKeyStatementText:Class;

        [Embed(source="/assets/sql/LoadAPIKey.sql", mimeType="application/octet-stream")]
        public static const LoadAPIKeyStatementText:Class;

        [Embed(source="/assets/sql/DeleteAPIKey.sql", mimeType="application/octet-stream")]
        public static const DeleteAPIKeyStatementText:Class;


        // ACCOUNTS
        [Embed(source="/assets/sql/InsertAccount.sql", mimeType="application/octet-stream")]
        public static const InsertAccountStatementText:Class;

        [Embed(source="/assets/sql/LoadAccounts.sql", mimeType="application/octet-stream")]
        public static const LoadAccountsStatementText:Class;

        [Embed(source="/assets/sql/DeleteAccounts.sql", mimeType="application/octet-stream")]
        public static const DeleteAccountsStatementText:Class;


        // TRANSACTIONS
        [Embed(source="/assets/sql/InsertTransaction.sql", mimeType="application/octet-stream")]
        public static const InsertTransactionStatementText:Class;

        [Embed(source="/assets/sql/DeleteTransactions.sql", mimeType="application/octet-stream")]
        public static const DeleteTransactionsStatementText:Class;

        [Embed(source="/assets/sql/DeleteTransactionsFromAccount.sql", mimeType="application/octet-stream")]
        public static const DeleteTransactionsFromAccountStatementText:Class;

        [Embed(source="/assets/sql/LoadTransactions.sql", mimeType="application/octet-stream")]
        public static const LoadTransactionsStatementText:Class;

        // TRANSACTIONS SYNC
        [Embed(source="/assets/sql/sync/LoadSyncTransactionsInserted.sql", mimeType="application/octet-stream")]
        public static const LoadSyncTransactionsInsertedStatementText:Class;

        [Embed(source="/assets/sql/sync/LoadSyncTransactionsUpdated.sql", mimeType="application/octet-stream")]
        public static const LoadSyncTransactionsUpdatedStatementText:Class;

        [Embed(source="/assets/sql/sync/LoadSyncTransactionsDeleted.sql", mimeType="application/octet-stream")]
        public static const LoadSyncTransactionsDeletedStatementText:Class;

        [Embed(source="/assets/sql/sync/DeleteSyncTransactionsInserted.sql", mimeType="application/octet-stream")]
        public static const DeleteSyncTransactionsInsertedStatementText:Class;

        [Embed(source="/assets/sql/sync/DeleteSyncTransactionsUpdated.sql", mimeType="application/octet-stream")]
        public static const DeleteSyncTransactionsUpdatedStatementText:Class;

        [Embed(source="/assets/sql/sync/DeleteSyncTransactionsDeleted.sql", mimeType="application/octet-stream")]
        public static const DeleteSyncTransactionsDeletedStatementText:Class;


        // CATEGORIES
        [Embed(source="/assets/sql/InsertCategory.sql", mimeType="application/octet-stream")]
        public static const InsertCategoryStatementText:Class;

        [Embed(source="/assets/sql/DeleteCategories.sql", mimeType="application/octet-stream")]
        public static const DeleteCategoriesStatementText:Class;

        [Embed(source="/assets/sql/LoadCategories.sql", mimeType="application/octet-stream")]
        public static const LoadCategoriesStatementText:Class;

        [Embed(source="/assets/sql/LoadUsedCategories.sql", mimeType="application/octet-stream")]
        public static const LoadUsedCategoriesStatementText:Class;


        // CURRENCIES
        [Embed(source="/assets/sql/InsertCurrency.sql", mimeType="application/octet-stream")]
        public static const InsertCurrencyStatementText:Class;

        [Embed(source="/assets/sql/DeleteCurrencies.sql", mimeType="application/octet-stream")]
        public static const DeleteCurrenciesStatementText:Class;

        [Embed(source="/assets/sql/LoadCurrencies.sql", mimeType="application/octet-stream")]
        public static const LoadCurrenciesStatementText:Class;
    }
}
