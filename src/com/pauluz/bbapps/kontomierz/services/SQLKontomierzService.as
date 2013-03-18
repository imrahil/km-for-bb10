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
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.model.vo.AccountVO;
    import com.pauluz.bbapps.kontomierz.model.vo.CategoryVO;
    import com.pauluz.bbapps.kontomierz.model.vo.CurrencyVO;
    import com.pauluz.bbapps.kontomierz.model.vo.ErrorVO;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.signals.GetAllAccountsOnlineSignal;
    import com.pauluz.bbapps.kontomierz.signals.GetAllCategoriesOnlineSignal;
    import com.pauluz.bbapps.kontomierz.signals.GetAllCurrenciesOnlineSignal;
    import com.pauluz.bbapps.kontomierz.signals.GetAllTransactionsOnlineSignal;
    import com.pauluz.bbapps.kontomierz.signals.StoreDefaultWalletIdSignal;
    import com.pauluz.bbapps.kontomierz.signals.offline.GetAllTransactionsOfflineSignal;
    import com.pauluz.bbapps.kontomierz.signals.offline.SyncOfflineChangesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ErrorSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllAccountsDataSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllCurrenciesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllDepositCategoriesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllTransactionsSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllWithdrawalCategoriesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideLoginStatusSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.probertson.data.QueuedStatement;
    import com.probertson.data.SQLRunner;

    import flash.data.SQLResult;
    import flash.errors.SQLError;
    import flash.utils.Dictionary;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.Actor;

    import qnx.ui.data.DataProvider;

    import qnx.ui.data.IDataProvider;
    import qnx.ui.data.SectionDataProvider;

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
        public var syncOfflineChangesSignal:SyncOfflineChangesSignal;

        [Inject]
        public var getAllTransactionsOnlineSignal:GetAllTransactionsOnlineSignal;

        [Inject]
        public var getAllCategoriesOnlineSignal:GetAllCategoriesOnlineSignal;

        [Inject]
        public var getAllCurrenciesOnlineSignal:GetAllCurrenciesOnlineSignal;

        [Inject]
        public var provideAllCurrenciesSignal:ProvideAllCurrenciesSignal;

        [Inject]
        public var storeDefaultWalletIdSignal:StoreDefaultWalletIdSignal;

        [Inject]
        public var errorSignal:ErrorSignal;

        private static const INSERT_API_KEY_SQL:String = new SQLStatements.InsertAPIKeyStatementText();
        private static const LOAD_API_KEY_SQL:String = new SQLStatements.LoadAPIKeyStatementText();
        private static const DELETE_API_KEY_SQL:String = new SQLStatements.DeleteAPIKeyStatementText();

        private static const INSERT_ACCOUNT_SQL:String = new SQLStatements.InsertAccountStatementText();
        private static const LOAD_ACCOUNTS_SQL:String = new SQLStatements.LoadAccountsStatementText();
        private static const DELETE_ACCOUNTS_SQL:String = new SQLStatements.DeleteAccountsStatementText();

        private static const INSERT_TRANSACTION_SQL:String = new SQLStatements.InsertTransactionStatementText();
        private static const DELETE_TRANSACTIONS_SQL:String = new SQLStatements.DeleteTransactionsStatementText();
        private static const DELETE_TRANSACTIONS_FROM_ACCOUNT_SQL:String = new SQLStatements.DeleteTransactionsFromAccountStatementText();
        private static const LOAD_TRANSACTIONS_SQL:String = new SQLStatements.LoadTransactionsStatementText();

        private static const INSERT_CATEGORY_SQL:String = new SQLStatements.InsertCategoryStatementText();
        private static const DELETE_CATEGORIES_SQL:String = new SQLStatements.DeleteCategoriesStatementText();
        private static const LOAD_CATEGORIES_SQL:String = new SQLStatements.LoadCategoriesStatementText();
        private static const LOAD_USED_CATEGORIES_SQL:String = new SQLStatements.LoadUsedCategoriesStatementText();

        private static const INSERT_CURRENCY_SQL:String = new SQLStatements.InsertCurrencyStatementText();
        private static const DELETE_CURRENCIES_SQL:String = new SQLStatements.DeleteCurrenciesStatementText();
        private static const LOAD_CURRENCIES_SQL:String = new SQLStatements.LoadCurrenciesStatementText();

        /** Constructor */
        public function SQLKontomierzService()
        {
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        public function saveUserAPIKey(apiKey:String):void
        {
            logger.debug(": saveUserAPIKey");

            sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(INSERT_API_KEY_SQL, {apiKey:apiKey})]), null, databaseErrorHandler);
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

                if (model.isConnected)
                {
                    syncOfflineChangesSignal.dispatch();
                }
                else
                {
                    provideLoginStatusSignal.dispatch(ApplicationConstants.LOGIN_STATUS_REMEMBERED);
                }
            }
            else
            {
                provideLoginStatusSignal.dispatch(ApplicationConstants.LOGIN_STATUS_NEW);
            }
        }


        /*
         *  DELETE USER API KEY
         */
        public function deleteUserAPIKey():void
        {
            logger.debug(": deleteUserAPIKey");

            sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(DELETE_API_KEY_SQL)]), null, databaseErrorHandler);
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
            var defaultWalletId:int;

            for each (var account:AccountVO in result.data)
            {
                if (account.bankPluginName != ApplicationConstants.WALLET_ACCOUNT_NAME)
                {
                    accountsList.addItem(account);
                }

                if (account.is_default_wallet)
                {
                    defaultWalletId = account.accountId;
                }
            }

            model.accountsList = accountsList;
            provideAllAccountsDataSignal.dispatch(accountsList);
            storeDefaultWalletIdSignal.dispatch(defaultWalletId);

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
         *  DELETE ACCOUNTS
         */
        public function deleteAccounts():void
        {
            logger.debug(": deleteAccounts");

            sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(DELETE_ACCOUNTS_SQL)]), null, databaseErrorHandler);
        }


        /*
         *  GET ALL TRANSACTIONS
         */
        public function getAllTransactions(accountId:int, isWallet:Boolean):void
        {
            logger.debug(": getAllTransactions - isWallet: " + isWallet);

            if (isWallet)
            {
                var wallet:int = (isWallet) ? 1 : 0;
                sqlRunner.execute(LOAD_TRANSACTIONS_SQL, {userAccountId: accountId, isWallet: wallet}, loadWalletTransactionsResult, TransactionVO, databaseErrorHandler);
            }
            else
            {
                sqlRunner.execute(LOAD_TRANSACTIONS_SQL, {userAccountId: accountId, isWallet: isWallet}, loadTransactionsResult, TransactionVO, databaseErrorHandler);
            }
        }

        private function loadWalletTransactionsResult(result:SQLResult):void
        {
            logger.debug(": loadWalletTransactionsResult");

            if (result.data != null && result.data.length > 0)
            {

            }
        }

        private function loadTransactionsResult(result:SQLResult):void
        {
            logger.debug(": loadTransactionsResult");

            if (result.data != null && result.data.length > 0)
            {
                model.selectedAccount.isValid = true;

                var transactionsData:DataProvider = new DataProvider(result.data);
                provideAllTransactionsSignal.dispatch(transactionsData);
            }
            else
            {
                getAllTransactionsOnlineSignal.dispatch();
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
        public function saveAllTransactions(transactionsList:Array):void
        {
            logger.debug(": saveAllTransactions");

            var stmts:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
            var params:Object;

            stmts[stmts.length] = new QueuedStatement(DELETE_TRANSACTIONS_FROM_ACCOUNT_SQL, {userAccountId: model.selectedAccount.accountId});

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

            sqlRunner.executeModify(stmts, onSaveAllTransactionsComplete, databaseErrorHandler);
        }

        private function onSaveAllTransactionsComplete(results:Vector.<SQLResult>):void
        {
            model.selectedAccount.isValid = true;
        }


        /*
         *  SYNC MODIFIED TRANSACTIONS
         */
        public function syncModifiedTransactions():void
        {

        }


        /*
         *  CREATE TRANSACTION
         */
        public function createTransaction(transaction:TransactionVO):void
        {
            throw new Error("Override this method!");
        }


        /*
         *  UPDATE TRANSACTION
         */
        public function updateTransaction(transaction:TransactionVO):void
        {
            throw new Error("Override this method!");
        }


        /*
         *  DELETE TRANSACTION
         */
        public function deleteTransaction(id:int, wallet:Boolean):void
        {
            throw new Error("Override this method!");
        }


        /*
         *  SAVE CATEGORIES
         */
       public function saveCategories(categoriesList:SectionDataProvider, direction:String):void
        {
            logger.debug(": saveCategories");

            var stmts:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
            var params:Object;

            for each (var category:CategoryVO in categoriesList.data)
            {
                params = {};
                params["categoryId"] = category.categoryId;
                params["name"] = category.name;
                params["header"] = category.header;
                params["direction"] = direction;
                params["parentId"] = 0;
                stmts[stmts.length] = new QueuedStatement(INSERT_CATEGORY_SQL, params);

                var subTempDP:IDataProvider = categoriesList.getChildrenForItem(category);
                for each (var subCategory:CategoryVO in subTempDP.data)
                {
                    params = {};
                    params["categoryId"] = subCategory.categoryId;
                    params["name"] = subCategory.name;
                    params["header"] = subCategory.header;
                    params["direction"] = direction;
                    params["parentId"] = subCategory.parentId;
                    stmts[stmts.length] = new QueuedStatement(INSERT_CATEGORY_SQL, params);
                }
            }

            sqlRunner.executeModify(stmts, null, databaseErrorHandler);
        }


        /*
         *  LOAD CATEGORIES
         */
        public function loadCategories(direction:String):void
        {
            logger.debug(": loadCategories");

            sqlRunner.execute(LOAD_CATEGORIES_SQL, {direction: direction}, function(result:SQLResult):void { loadCategoriesResult(result, direction)}, CategoryVO, databaseErrorHandler);
        }

        private function loadCategoriesResult(result:SQLResult, direction:String):void
        {
            logger.debug(": loadCategoriesResult");

            if (result.data != null && result.data.length > 0)
            {
                var tempDict:Dictionary = new Dictionary();
                var output:SectionDataProvider = new SectionDataProvider();

                for each (var category:CategoryVO in result.data)
                {
                    if (category.header)
                    {
                        output.addItem(category);

                        tempDict[category.categoryId] = category;
                    }
                    else
                    {
                        output.addChildToItem(category, tempDict[category.parentId]);
                    }
                }

                if (direction == ApplicationConstants.TRANSACTION_DIRECTION_WITHDRAWAL)
                {
                    model.withdrawalCategoriesList = output;
                    provideAllWithdrawalCategoriesSignal.dispatch(output);
                }
                else
                {
                    model.depositCategoriesList = output;
                    provideAllDepositCategoriesSignal.dispatch(output);
                }
            }
            else
            {
                getAllCategoriesOnlineSignal.dispatch(direction);
            }
        }


        /*
         *  LOAD USED CATEGORIES
         */
        public function loadUsedCategories():void
        {
            logger.debug(": loadCategories");

            sqlRunner.execute(LOAD_USED_CATEGORIES_SQL, null, loadUsedCategoriesResult, CategoryVO, databaseErrorHandler);
        }

        private function loadUsedCategoriesResult(result:SQLResult):void
        {
            logger.debug(": loadUsedCategoriesResult");

            if (result.data != null && result.data.length > 0)
            {
                var output:SectionDataProvider = new SectionDataProvider();

                var mainCategory:CategoryVO = new CategoryVO();
                mainCategory.header = true;
                mainCategory.name = "Używane kategorie";
                output.addItem(mainCategory);

                for each (var category:CategoryVO in result.data)
                {
                    output.addChildToItem(category, mainCategory);
                }

                provideAllWithdrawalCategoriesSignal.dispatch(output);
            }
            else
            {
                var error:ErrorVO = new ErrorVO("Brak danych offline. Musisz przejrzeć przynajmniej jeden ze swoich rachunków.");
                errorSignal.dispatch(error);
            }
        }


        /*
         *  DELETE CATEGORIES
         */
        public function deleteCategories():void
        {
            logger.debug(": deleteCategories");

            sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(DELETE_CATEGORIES_SQL)]), null, databaseErrorHandler);
        }


        /*
         *  SAVE CURRENCIES
         */
        public function saveCurrencies(currenciesList:Array):void
        {
            logger.debug(": saveCurrencies");

            var stmts:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();

            for each (var currency:CurrencyVO in currenciesList)
            {
                var params:Object = {};
                params["currencyId"] = currency.currencyId;
                params["name"] = currency.name;
                params["fullName"] = currency.fullName;

                stmts[stmts.length] = new QueuedStatement(INSERT_CURRENCY_SQL, params);
            }

            sqlRunner.executeModify(stmts, null, databaseErrorHandler);
        }


        /*
         *  LOAD CURRENCIES
         */
        public function loadCurrencies():void
        {
            logger.debug(": loadCurrencies");

            sqlRunner.execute(LOAD_CURRENCIES_SQL, null, loadCurrenciesResult, CurrencyVO, databaseErrorHandler);
        }

        private function loadCurrenciesResult(result:SQLResult):void
        {
            logger.debug(": loadCurrenciesResult");

            if (result.data != null && result.data.length > 0)
            {
                model.currenciesList = result.data;

                for each (var currency:CurrencyVO in model.currenciesList)
                {
                    if (currency.name == ApplicationConstants.DEFAULT_CURRENCY_NAME)
                    {
                        currency.selected = true;
                        break;
                    }
                }

                provideAllCurrenciesSignal.dispatch(model.currenciesList);
            }
            else
            {
                getAllCurrenciesOnlineSignal.dispatch();
            }
        }


        /*
         *  DELETE CURRENCIES
         */
        public function deleteCurrencies():void
        {
            logger.debug(": deleteCurrencies");

            sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(DELETE_CURRENCIES_SQL)]), null, databaseErrorHandler);
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
