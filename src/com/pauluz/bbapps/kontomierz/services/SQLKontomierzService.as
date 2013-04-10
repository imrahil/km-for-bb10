/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.services
{
    import com.pauluz.bbapps.kontomierz.constants.ApplicationConstants;
    import com.pauluz.bbapps.kontomierz.constants.SQLStatements;
    import com.pauluz.bbapps.kontomierz.constants.SQLStatements;
    import com.pauluz.bbapps.kontomierz.constants.SQLStatements;
    import com.pauluz.bbapps.kontomierz.constants.SQLStatements;
    import com.pauluz.bbapps.kontomierz.constants.SQLStatements;
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.model.vo.AccountVO;
    import com.pauluz.bbapps.kontomierz.model.vo.ErrorVO;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.signals.*;
    import com.pauluz.bbapps.kontomierz.signals.offline.CheckSyncStatusSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.*;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.probertson.data.QueuedStatement;
    import com.probertson.data.SQLRunner;

    import flash.data.SQLResult;
    import flash.errors.SQLError;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.Actor;

    import qnx.ui.data.DataProvider;

    public class SQLKontomierzService extends Actor implements ISQLKontomierzService
    {
        protected var logger:ILogger;

        /** MODEL **/
        [Inject]
        public var model:IKontomierzModel;

        /** INJECTS */
        [Inject]
        public var sqlRunner:SQLRunner;

        /** NOTIFICATION SIGNALS */
        [Inject]
        public var provideLoginStatusSignal:ProvideLoginStatusSignal;

        [Inject]
        public var getAllAccountsOnlineSignal:GetAllAccountsOnlineSignal;

        [Inject]
        public var provideAllAccountsDataSignal:ProvideAllAccountsDataSignal;

        [Inject]
        public var provideAllTransactionsSignal:ProvideAllTransactionsSignal;

        [Inject]
        public var provideAllWithdrawalCategoriesSignal:ProvideAllWithdrawalCategoriesSignal;

        [Inject]
        public var provideAllDepositCategoriesSignal:ProvideAllDepositCategoriesSignal;


        [Inject]
        public var transactionSuccessfullySavedSignal:TransactionSuccessfullySavedSignal;


        [Inject]
        public var checkSyncStatusSignal:CheckSyncStatusSignal;

        [Inject]
        public var getAllTransactionsOnlineSignal:GetAllTransactionsOnlineSignal;

        [Inject]
        public var getAllWalletTransactionsOnlineSignal:GetAllWalletTransactionsOnlineSignal;

        [Inject]
        public var getAllCategoriesOnlineSignal:GetAllCategoriesOnlineSignal;

        [Inject]
        public var provideAllCurrenciesSignal:ProvideAllCurrenciesSignal;

        [Inject]
        public var storeDefaultWalletSignal:StoreDefaultWalletSignal;

        [Inject]
        public var addTransactionOnlineSignal:AddTransactionOnlineSignal;

        [Inject]
        public var syncAddTransactionSignal:SyncAddTransactionSignal;

        [Inject]
        public var syncUpdateTransactionSignal:SyncUpdateTransactionSignal;

        [Inject]
        public var syncDeleteTransactionSignal:SyncDeleteTransactionSignal;

        [Inject]
        public var errorSignal:ErrorSignal;

        private static const INSERT_API_KEY_SQL:String = new SQLStatements.InsertAPIKeyStatementText();
        private static const LOAD_API_KEY_SQL:String = new SQLStatements.LoadAPIKeyStatementText();
        private static const DELETE_API_KEY_SQL:String = new SQLStatements.DeleteAPIKeyStatementText();

        // ACCOUNTS
        private static const INSERT_ACCOUNT_SQL:String = new SQLStatements.InsertAccountStatementText();
        private static const LOAD_ACCOUNTS_SQL:String = new SQLStatements.LoadAccountsStatementText();
        private static const DELETE_ACCOUNTS_SQL:String = new SQLStatements.DeleteAccountsStatementText();

        // TRANSACTIONS
        private static const INSERT_TRANSACTION_SQL:String = new SQLStatements.InsertTransactionStatementText();
        private static const INSERT_NEW_TRANSACTION_SQL:String = new SQLStatements.InsertNewTransactionStatementText();
        private static const DELETE_TRANSACTIONS_SQL:String = new SQLStatements.DeleteTransactionsStatementText();
        private static const DELETE_TRANSACTIONS_FROM_ACCOUNT_SQL:String = new SQLStatements.DeleteTransactionsFromAccountStatementText();

        private static const LOAD_TRANSACTIONS_SQL:String = new SQLStatements.LoadTransactionsStatementText();

        private static const CHECK_SYNC_STATUS:String = new SQLStatements.CheckSyncStatusStatementText();

        private static const LOAD_SYNC_TRANSACTIONS_INSERTED_SQL:String = new SQLStatements.LoadSyncTransactionsInsertedStatementText();
        private static const LOAD_SYNC_TRANSACTIONS_UPDATED_SQL:String = new SQLStatements.LoadSyncTransactionsUpdatedStatementText();
        private static const LOAD_SYNC_TRANSACTIONS_DELETED_SQL:String = new SQLStatements.LoadSyncTransactionsDeletedStatementText();

        private static const DELETE_SYNC_TRANSACTIONS_INSERTED_SQL:String = new SQLStatements.DeleteSyncTransactionsInsertedStatementText();
        private static const DELETE_SYNC_TRANSACTIONS_INSERTED_BY_ID_SQL:String = new SQLStatements.DeleteSyncTransactionsInsertedByIdStatementText();
        private static const DELETE_SYNC_TRANSACTIONS_UPDATED_SQL:String = new SQLStatements.DeleteSyncTransactionsUpdatedStatementText();
        private static const DELETE_SYNC_TRANSACTIONS_UPDATED_BY_ID_SQL:String = new SQLStatements.DeleteSyncTransactionsUpdatedByIdStatementText();
        private static const DELETE_SYNC_TRANSACTIONS_DELETED_SQL:String = new SQLStatements.DeleteSyncTransactionsDeletedStatementText();
        private static const DELETE_SYNC_TRANSACTIONS_DELETED_BY_ID_SQL:String = new SQLStatements.DeleteSyncTransactionsDeletedByIdStatementText();



        /** Constructor */
        public function SQLKontomierzService()
        {
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        /*
         *  LOAD USER API KEY
         */
        public function loadUserAPIKey():void
        {
            logger.debug(": loadUserAPIKey");

            sqlRunner.execute(LOAD_API_KEY_SQL, null, loadUserAPIKeyResult, null, databaseErrorHandler);
        }

        private function loadUserAPIKeyResult(result:SQLResult):void
        {
            logger.debug(": loadUserAPIKeyResult");

            if (result.data != null && result.data.length > 0)
            {
                model.apiKey = result.data[0].apiKey;
                model.rememberMe = true;

                if (model.isConnected)
                {
                    checkSyncStatusSignal.dispatch();
                }

                provideLoginStatusSignal.dispatch(ApplicationConstants.LOGIN_STATUS_REMEMBERED);
            }
            else
            {
                provideLoginStatusSignal.dispatch(ApplicationConstants.LOGIN_STATUS_NEW);
            }
        }

        /*
         *  SAVE USER API KEY
         */
        public function saveUserAPIKey(apiKey:String):void
        {
            logger.debug(": saveUserAPIKey");

            sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(INSERT_API_KEY_SQL, {apiKey:apiKey})]), null, databaseErrorHandler);
        }


        /*
         *  GET ALL ACCOUNTS
         */
        public function getAllAccounts():void
        {
            logger.debug(": getAllAccounts");

            sqlRunner.execute(LOAD_ACCOUNTS_SQL, null, loadAccountsResult, AccountVO, databaseErrorHandler);
        }

        private function loadAccountsResult(result:SQLResult):void
        {
            logger.debug(": loadAccountsResult");

            var accountsList:DataProvider = new DataProvider();
            var defaultWallet:AccountVO;

            for each (var account:AccountVO in result.data)
            {
                if (account.bankPluginName != ApplicationConstants.WALLET_ACCOUNT_NAME)
                {
                    accountsList.addItem(account);
                }

                if (account.is_default_wallet)
                {
                    defaultWallet = account;
                }
            }

            model.accountsList = accountsList;
            provideAllAccountsDataSignal.dispatch(accountsList);

            if (defaultWallet)
            {
                storeDefaultWalletSignal.dispatch(defaultWallet);
            }

            if (model.isConnected)
            {
                getAllAccountsOnlineSignal.dispatch();
            }
        }


        /*
         *  SAVE ALL ACCOUNTS
         */
        public function saveAllAccounts(accountsList:Array):void
        {
            logger.debug(": saveAllAccounts");

            var stmts:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
            var params:Object;

            stmts[stmts.length] = new QueuedStatement(DELETE_ACCOUNTS_SQL);

            for each (var account:AccountVO in accountsList)
            {
                params = {};
                params["accountId"] = account.accountId;
                params["balance"] = account.balance;
                params["bankName"] = account.bankName;
                params["bankPluginName"] = account.bankPluginName;
                params["currencyBalance"] = account.currencyBalance;
                params["currencyName"] = account.currencyName;
                params["displayName"] = account.displayName;
                params["iban"] = account.iban;
                params["ibanChecksum"] = account.ibanChecksum;
                params["is_default_wallet"] = (account.is_default_wallet) ? 1 : 0;

                stmts[stmts.length] = new QueuedStatement(INSERT_ACCOUNT_SQL, params);
            }

            sqlRunner.executeModify(stmts, null, databaseErrorHandler);
        }


        /*
         *  GET ALL TRANSACTIONS
         */
        public function getAllTransactions(accountId:int):void
        {
            logger.debug(": getAllTransactions");

            sqlRunner.execute(LOAD_TRANSACTIONS_SQL, {userAccountId: accountId}, loadTransactionsResult, TransactionVO, databaseErrorHandler);
        }

        private function loadTransactionsResult(result:SQLResult):void
        {
            logger.debug(": loadTransactionsResult");

            if (result.data != null && result.data.length > 0)
            {
                var transactionsData:DataProvider = new DataProvider(result.data);
                provideAllTransactionsSignal.dispatch(transactionsData);
            }

            if (model.isConnected)
            {
                if (!model.selectedAccount.isValid)
                {
                    getAllTransactionsOnlineSignal.dispatch();
                }
            }
            else
            {
                model.selectedAccount.isValid = true;
            }
        }

        /*
         *  GET ALL WALLET TRANSACTIONS
         */
        public function getAllWalletTransactions():void
        {
            logger.debug(": getAllWalletTransactions");

            sqlRunner.execute(LOAD_TRANSACTIONS_SQL, {userAccountId: model.defaultWallet.accountId}, loadWalletTransactionsResult, TransactionVO, databaseErrorHandler);
        }

        private function loadWalletTransactionsResult(result:SQLResult):void
        {
            logger.debug(": loadWalletTransactionsResult");

            if (result.data != null && result.data.length > 0)
            {
                var transactionsData:DataProvider = new DataProvider(result.data);
                model.walletTransactionsList = transactionsData;

                provideAllTransactionsSignal.dispatch(transactionsData);
            }

            if (model.isConnected)
            {
                if (!model.defaultWallet.isValid)
                {
                    getAllWalletTransactionsOnlineSignal.dispatch();
                }
            }
            else
            {
                model.defaultWallet.isValid = true;
            }
        }


        /*
         *  GET ALL TRANSACTIONS FOR CATEGORY
         */
        public function getAllTransactionsForCategory(categoryId:int):void
        {
            throw new Error("Override this method!");
        }


        /*
         *  SAVE ALL TRANSACTIONS
         */
        public function saveAllTransactions(accountId:int, transactionsList:Array, isWallet:Boolean):void
        {
            logger.debug(": saveAllTransactions");

            var stmts:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
            var params:Object;

            stmts[stmts.length] = new QueuedStatement(SQLStatements.DROP_SYNC_TRANSACTION_INSERT_TRIGGER_SQL);
            stmts[stmts.length] = new QueuedStatement(SQLStatements.DROP_SYNC_TRANSACTION_DELETE_TRIGGER_SQL);
            stmts[stmts.length] = new QueuedStatement(DELETE_TRANSACTIONS_FROM_ACCOUNT_SQL, {userAccountId: accountId});

            for each (var transaction:TransactionVO in transactionsList)
            {
                params = {};

                params["transactionId"] = transaction.transactionId;
                params["userAccountId"] = transaction.userAccountId;
                params["currencyAmount"] = transaction.currencyAmount;
                params["currencyName"] = transaction.currencyName;
                params["amount"] = transaction.amount;
                params["transactionOn"] = transaction.transactionOn;
                params["bookedOn"] = transaction.bookedOn;
                params["description"] = transaction.description;
                params["categoryName"] = transaction.categoryName;
                params["categoryId"] = transaction.categoryId;
                params["tagString"] = transaction.tagString;
                params["direction"] = transaction.direction;

                params["isWallet"] = (transaction.isWallet) ? 1 : 0;

                stmts[stmts.length] = new QueuedStatement(INSERT_TRANSACTION_SQL, params);
            }

            stmts[stmts.length] = new QueuedStatement(SQLStatements.CREATE_SYNC_TRANSACTION_INSERT_TRIGGER_SQL);
            stmts[stmts.length] = new QueuedStatement(SQLStatements.CREATE_SYNC_TRANSACTION_DELETE_TRIGGER_SQL);

            sqlRunner.executeModify(stmts, function(results:Vector.<SQLResult>):void { onSaveAllTransactionsComplete(accountId, isWallet)}, databaseErrorHandler);
        }

        private function onSaveAllTransactionsComplete(accountId:int, isWallet:Boolean):void
        {
            logger.debug(": onSaveAllTransactionsComplete");

            if (isWallet)
            {
                model.defaultWallet.isValid = true;
                getAllWalletTransactions();
            }
            else
            {
                model.selectedAccount.isValid = true;
                getAllTransactions(accountId);
            }
        }


        /*
         *  CHECK SYNC STATUS
         */
        public function checkSyncStatus():void
        {
            logger.debug(": checkSyncStatus");

            sqlRunner.execute(CHECK_SYNC_STATUS, null, onCheckSyncStatus, null, databaseErrorHandler);
        }

        private function onCheckSyncStatus(result:SQLResult):void
        {
            if (result.data != null && result.data.length > 0)
            {
                var deletedItemsCount:int = result.data[0].count;
                var insertedItemsCount:int = result.data[1].count;
                var updatedItemsCount:int = result.data[2].count;

                model.totalSyncCount = deletedItemsCount + insertedItemsCount + updatedItemsCount;

                if (model.totalSyncCount > 0)
                {
                    model.syncRequired = true;

                    if (model.isConnected)
                    {
                        syncOfflineChanges();
                    }
                }
            }
        }

        /*
         *  SYNC OFFLINE CHANGES
         */
        public function syncOfflineChanges():void
        {
            logger.debug(": syncOfflineChanges");

            model.syncInProgress = true;

            syncDeletedItems();
            syncInsertedItems();
            syncUpdatedItems();
        }

        private function syncDeletedItems():void
        {
            logger.debug(": syncDeletedItems");

            sqlRunner.execute(LOAD_SYNC_TRANSACTIONS_DELETED_SQL, null, onSyncDeletedItems, null, databaseErrorHandler);
        }

        private function onSyncDeletedItems(result:SQLResult):void
        {
            if (result.data != null && result.data.length > 0)
            {
                for each (var obj:Object in result.data)
                {
                    syncDeleteTransactionSignal.dispatch(obj.id);
                }
            }
        }

        private function syncInsertedItems():void
        {
            logger.debug(": syncInsertedItems");

            sqlRunner.execute(LOAD_SYNC_TRANSACTIONS_INSERTED_SQL, null, onSyncInsertedItems, TransactionVO, databaseErrorHandler);
        }

        private function onSyncInsertedItems(result:SQLResult):void
        {
             if (result.data != null && result.data.length > 0)
             {
                 for each (var transaction:TransactionVO in result.data)
                 {
                     syncAddTransactionSignal.dispatch(transaction);
                 }
             }
        }

        private function syncUpdatedItems():void
        {
            logger.debug(": syncUpdatedItems");

            sqlRunner.execute(LOAD_SYNC_TRANSACTIONS_UPDATED_SQL, null, onSyncUpdatedItems, TransactionVO, databaseErrorHandler);
        }

        private function onSyncUpdatedItems(result:SQLResult):void
        {
             if (result.data != null && result.data.length > 0)
             {
                 for each (var transaction:TransactionVO in result.data)
                 {
                     syncUpdateTransactionSignal.dispatch(transaction);
                 }
             }
        }

        /*
         *  CREATE TRANSACTION
         */
        public function createTransaction(transaction:TransactionVO):void
        {
            logger.debug(": createTransaction");

            var params:Object = {};

            params["transactionId"] = -1;
            params["amount"] = 0;
            params["bookedOn"] = transaction.transactionOn;
            params["tagString"] = "";

            params["userAccountId"] = model.defaultWallet.accountId;
            params["currencyAmount"] = transaction.currencyAmount;
            params["currencyName"] = transaction.currencyName;
            params["transactionOn"] = transaction.transactionOn;
            params["description"] = transaction.description;
            params["categoryName"] = transaction.categoryName;
            params["categoryId"] = transaction.categoryId;
            params["direction"] = transaction.direction;

            params["isWallet"] = 1;

            sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(INSERT_NEW_TRANSACTION_SQL, params)]), function(results:Vector.<SQLResult>):void { onCreateTransactionComplete(results, transaction) }, databaseErrorHandler);
        }

        private function onCreateTransactionComplete(results:Vector.<SQLResult>, transaction:TransactionVO):void
        {
            logger.debug(": onCreateTransactionComplete");

            if (model.isConnected)
            {
                if (results && results.length > 0)
                {
                    transaction.id = results[0].lastInsertRowID;
                    addTransactionOnlineSignal.dispatch(transaction);
                }
            }
            else
            {
                model.syncRequired = true;
                model.defaultWallet.isValid = false;
                transactionSuccessfullySavedSignal.dispatch();
            }
        }



        /*
         *  DELETE TRANSACTION
         */
        public function deleteTransaction(transaction:TransactionVO):void
        {
            logger.debug(": deleteTransaction");

        }




        /*
         *  DELETE SYNC DELETED TRANSACTION
         */
        public function deleteSyncDeletedTransaction(id:int):void
        {
            logger.debug(": deleteSyncDeletedTransaction");

            sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(DELETE_SYNC_TRANSACTIONS_DELETED_BY_ID_SQL, {id: id})]), null, databaseErrorHandler);
        }


        /*
         *  DELETE SYNC INSERT TRANSACTION
         */
        public function deleteSyncInsertTransaction(id:int):void
        {
            logger.debug(": deleteSyncInsertTransaction");

            sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(DELETE_SYNC_TRANSACTIONS_INSERTED_BY_ID_SQL, {id: id})]), null, databaseErrorHandler);
        }


        /*
         *  DELETE SYNC UPDATED TRANSACTION
         */
        public function deleteSyncUpdatedTransaction(id:int):void
        {
            logger.debug(": deleteSyncUpdatedTransaction");

            sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(DELETE_SYNC_TRANSACTIONS_UPDATED_BY_ID_SQL, {id: id})]), null, databaseErrorHandler);
        }


        /*
         *  DELETE ALL STUFF ON LOGOUT
         */
        public function deleteOnLogout():void
        {
            var stmts:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();

            stmts[stmts.length] = new QueuedStatement(DELETE_API_KEY_SQL);
            stmts[stmts.length] = new QueuedStatement(DELETE_ACCOUNTS_SQL);
            stmts[stmts.length] = new QueuedStatement(DELETE_TRANSACTIONS_SQL);
            stmts[stmts.length] = new QueuedStatement(DELETE_SYNC_TRANSACTIONS_INSERTED_SQL);
            stmts[stmts.length] = new QueuedStatement(DELETE_SYNC_TRANSACTIONS_UPDATED_SQL);
            stmts[stmts.length] = new QueuedStatement(DELETE_SYNC_TRANSACTIONS_DELETED_SQL);
            stmts[stmts.length] = new QueuedStatement(SQLStatements.DELETE_CATEGORIES_SQL);
            stmts[stmts.length] = new QueuedStatement(SQLStatements.DELETE_CURRENCIES_SQL);

            sqlRunner.executeModify(stmts, null, databaseErrorHandler);
        }

        /*
         *  DATABASE ERROR HANDLER
         */
        private function databaseErrorHandler(sqlError:SQLError):void
        {
            logger.debug("databaseError: " + sqlError.details);

            var error:ErrorVO = new ErrorVO(sqlError.details);
            errorSignal.dispatch(error);
        }
    }
}
