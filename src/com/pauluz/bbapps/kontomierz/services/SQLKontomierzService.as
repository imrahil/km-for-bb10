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
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.model.vo.AccountVO;
    import com.pauluz.bbapps.kontomierz.model.vo.CategoryVO;
    import com.pauluz.bbapps.kontomierz.model.vo.CurrencyVO;
    import com.pauluz.bbapps.kontomierz.model.vo.ErrorVO;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.signals.GetAllAccountsOnlineSignal;
    import com.pauluz.bbapps.kontomierz.signals.GetAllCategoriesOnlineSignal;
    import com.pauluz.bbapps.kontomierz.signals.GetAllCurrenciesOnlineSignal;
    import com.pauluz.bbapps.kontomierz.signals.StoreDefaultWalletIdSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ErrorSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllAccountsDataSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllCurrenciesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllDepositCategoriesSignal;
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
        public var provideAllWithdrawalCategoriesSignal:ProvideAllWithdrawalCategoriesSignal;

        [Inject]
        public var provideAllDepositCategoriesSignal:ProvideAllDepositCategoriesSignal;


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

                provideLoginStatusSignal.dispatch(ApplicationConstants.LOGIN_STATUS_REMEMBERED);
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
                accountsList.addItem(account);

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
                params["is_default_wallet"] = 0;

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
        public function getAllTransactions(accountId:int, wallet:Boolean):void
        {
            throw new Error("Override this method!");
        }


        /*
         *  GET ALL TRANSACTIONS FOR CATEGORY
         */
        public function getAllTransactionsForCategory(categoryId:int):void
        {
            throw new Error("Override this method!");
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
         *  CHECK OFFLINE CATEGORIES
         */
        public function checkOfflineCategories(direction:String):void
        {
            logger.debug(": checkOfflineCategories");

            sqlRunner.execute(CHECK_OFFLINE_CATEGORIES_SQL, {direction: direction}, function(result:SQLResult):void { checkOfflineCategoriesResult(result, direction)}, null, databaseErrorHandler);
        }

        private function checkOfflineCategoriesResult(result:SQLResult, direction:String):void
        {
            logger.debug(": checkOfflineCategoriesResult");

            if (result.data != null && result.data[0].counter > 0)
            {
                logger.debug("Categories exist offline - count: " + result.data[0].counter);
                this.loadCategories(direction);
            }
            else
            {
                logger.debug("No " + direction + " categories offline!");
                getAllCategoriesOnlineSignal.dispatch(direction);
            }
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
         *  CHECK OFFLINE CURRENCIES
         */
        public function checkOfflineCurrencies():void
        {
            logger.debug(": checkOfflineCurrencies");

            sqlRunner.execute(CHECK_OFFLINE_CURRENCIES_SQL, null, checkOfflineCurrenciesResult, null, databaseErrorHandler);
        }

        private function checkOfflineCurrenciesResult(result:SQLResult):void
        {
            logger.debug(": checkOfflineCurrenciesResult");

            if (result.data != null && result.data[0].counter > 0)
            {
                logger.debug("Currencies exist offline - count: " + result.data[0].counter);
                this.loadCurrencies();
            }
            else
            {
                getAllCurrenciesOnlineSignal.dispatch();
            }
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

          // ------- SQL statements -------
        [Embed(source="/assets/sql/InsertAPIKey.sql", mimeType="application/octet-stream")]
        private static const InsertAPIKeyStatementText:Class;
        private static const INSERT_API_KEY_SQL:String = new InsertAPIKeyStatementText();

        [Embed(source="/assets/sql/LoadAPIKey.sql", mimeType="application/octet-stream")]
        private static const LoadAPIKeyStatementText:Class;
        private static const LOAD_API_KEY_SQL:String = new LoadAPIKeyStatementText();

        [Embed(source="/assets/sql/DeleteAPIKey.sql", mimeType="application/octet-stream")]
        private static const DeleteAPIKeyStatementText:Class;
        private static const DELETE_API_KEY_SQL:String = new DeleteAPIKeyStatementText();


        [Embed(source="/assets/sql/InsertAccount.sql", mimeType="application/octet-stream")]
        private static const InsertAccountStatementText:Class;
        private static const INSERT_ACCOUNT_SQL:String = new InsertAccountStatementText();

        [Embed(source="/assets/sql/LoadAccounts.sql", mimeType="application/octet-stream")]
        private static const LoadAccountsStatementText:Class;
        private static const LOAD_ACCOUNTS_SQL:String = new LoadAccountsStatementText();

        [Embed(source="/assets/sql/DeleteAccounts.sql", mimeType="application/octet-stream")]
        private static const DeleteAccountsStatementText:Class;
        private static const DELETE_ACCOUNTS_SQL:String = new DeleteAccountsStatementText();


        [Embed(source="/assets/sql/InsertCategory.sql", mimeType="application/octet-stream")]
        private static const InsertCategoryStatementText:Class;
        private static const INSERT_CATEGORY_SQL:String = new InsertCategoryStatementText();

        [Embed(source="/assets/sql/DeleteCategories.sql", mimeType="application/octet-stream")]
        private static const DeleteCategoriesStatementText:Class;
        private static const DELETE_CATEGORIES_SQL:String = new DeleteCategoriesStatementText();

        [Embed(source="/assets/sql/LoadCategories.sql", mimeType="application/octet-stream")]
        private static const LoadCategoriesStatementText:Class;
        private static const LOAD_CATEGORIES_SQL:String = new LoadCategoriesStatementText();

        [Embed(source="/assets/sql/CheckOfflineCategories.sql", mimeType="application/octet-stream")]
        private static const CheckOfflineCategoriesStatementText:Class;
        private static const CHECK_OFFLINE_CATEGORIES_SQL:String = new CheckOfflineCategoriesStatementText();


        [Embed(source="/assets/sql/InsertCurrency.sql", mimeType="application/octet-stream")]
        private static const InsertCurrencyStatementText:Class;
        private static const INSERT_CURRENCY_SQL:String = new InsertCurrencyStatementText();

        [Embed(source="/assets/sql/DeleteCurrencies.sql", mimeType="application/octet-stream")]
        private static const DeleteCurrenciesStatementText:Class;
        private static const DELETE_CURRENCIES_SQL:String = new DeleteCurrenciesStatementText();

        [Embed(source="/assets/sql/LoadCurrencies.sql", mimeType="application/octet-stream")]
        private static const LoadCurrenciesStatementText:Class;
        private static const LOAD_CURRENCIES_SQL:String = new LoadCurrenciesStatementText();

        [Embed(source="/assets/sql/CheckOfflineCurrencies.sql", mimeType="application/octet-stream")]
        private static const CheckOfflineCurrenciesStatementText:Class;
        private static const CHECK_OFFLINE_CURRENCIES_SQL:String = new CheckOfflineCurrenciesStatementText();

    }
}
