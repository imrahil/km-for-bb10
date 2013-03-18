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
        // CREATE
        [Embed(source="/assets/sql/CreateAccountsTable.sql", mimeType="application/octet-stream")]
        public static const CreateAccountsTableStatementText:Class;

        [Embed(source="/assets/sql/CreateTransactionsTable.sql", mimeType="application/octet-stream")]
        public static const CreateTransactionsTableStatementText:Class;

        [Embed(source="/assets/sql/CreateSyncInsertTable.sql", mimeType="application/octet-stream")]
        public static const CreateSyncInsertTableStatementText:Class;

        [Embed(source="/assets/sql/CreateSyncUpdateTable.sql", mimeType="application/octet-stream")]
        public static const CreateSyncUpdateTableStatementText:Class;

        [Embed(source="/assets/sql/CreateSyncDeleteTable.sql", mimeType="application/octet-stream")]
        public static const CreateSyncDeleteTableStatementText:Class;

        [Embed(source="/assets/sql/CreateSyncTransactionInsertTrigger.sql", mimeType="application/octet-stream")]
        public static const CreateSyncTransactionInsertTriggerStatementText:Class;

        [Embed(source="/assets/sql/CreateSyncTransactionUpdateTrigger.sql", mimeType="application/octet-stream")]
        public static const CreateSyncTransactionUpdateTriggerStatementText:Class;

        [Embed(source="/assets/sql/CreateSyncTransactionDeleteTrigger.sql", mimeType="application/octet-stream")]
        public static const CreateSyncTransactionDeleteTriggerStatementText:Class;


        [Embed(source="/assets/sql/CreateCategoriesTable.sql", mimeType="application/octet-stream")]
        public static const CreateCategoriesTableStatementText:Class;

        [Embed(source="/assets/sql/CreateCurrenciesTable.sql", mimeType="application/octet-stream")]
        public static const CreateCurrenciesTableStatementText:Class;

        [Embed(source="/assets/sql/CreateUserTable.sql", mimeType="application/octet-stream")]
        public static const CreateUserTableStatementText:Class;

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
