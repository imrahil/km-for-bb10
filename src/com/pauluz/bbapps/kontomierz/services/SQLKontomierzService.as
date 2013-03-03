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
    import com.pauluz.bbapps.kontomierz.model.vo.CategoryVO;
    import com.pauluz.bbapps.kontomierz.model.vo.CurrencyVO;
    import com.pauluz.bbapps.kontomierz.model.vo.ErrorVO;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.signals.GetAllCategoriesOnlineSignal;
    import com.pauluz.bbapps.kontomierz.signals.GetAllCurrenciesOnlineSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ErrorSignal;
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
        public var errorSignal:ErrorSignal;

        /** Constructor */
        public function SQLKontomierzService()
        {
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        public function saveUserAPIKey(apiKey:String):void
        {
            sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(INSERT_API_KEY_SQL, {apiKey:apiKey})]), null, databaseErrorHandler);
        }

        public function loadUserAPIKey():void
        {
            sqlRunner.execute(LOAD_API_KEY_SQL, null, loadUserAPIKeyResult, null, databaseErrorHandler);
        }

        private function loadUserAPIKeyResult(result:SQLResult):void
        {
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

        public function deleteUserAPIKey():void
        {
            sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(DELETE_API_KEY_SQL)]), null, databaseErrorHandler);
        }

        public function getAllAccounts():void
        {
            throw new Error("Override this method!");
        }

        public function getAllTransactions(accountId:int, wallet:Boolean):void
        {
            throw new Error("Override this method!");
        }

        public function getAllTransactionsForCategory(categoryId:int):void
        {
            throw new Error("Override this method!");
        }

        public function createTransaction(transaction:TransactionVO):void
        {
            throw new Error("Override this method!");
        }

        public function updateTransaction(transaction:TransactionVO):void
        {
            throw new Error("Override this method!");
        }

        public function deleteTransaction(id:int, wallet:Boolean):void
        {
            throw new Error("Override this method!");
        }

        public function getAllWithdrawalCategories():void
        {
            throw new Error("Override this method!");
        }

        public function getAllDepositCategories():void
        {
            throw new Error("Override this method!");
        }

        public function saveCategories(categoriesList:SectionDataProvider, direction:String):void
        {
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

        public function checkOfflineCategories(direction:String):void
        {
            sqlRunner.execute(CHECK_OFFLINE_CATEGORIES_SQL, {direction: direction}, function(result:SQLResult):void { checkOfflineCategoriesResult(result, direction)}, null, databaseErrorHandler);
        }

        private function checkOfflineCategoriesResult(result:SQLResult, direction:String):void
        {
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

        public function loadCategories(direction:String):void
        {
            sqlRunner.execute(LOAD_CATEGORIES_SQL, {direction: direction}, function(result:SQLResult):void { loadCategoriesResult(result, direction)}, CategoryVO, databaseErrorHandler);
        }

        private function loadCategoriesResult(result:SQLResult, direction:String):void
        {
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

        public function deleteCategories():void
        {
            sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(DELETE_CATEGORIES_SQL)]), null, databaseErrorHandler);
        }

        public function saveCurrencies(currenciesList:Array):void
        {
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

        public function checkOfflinCurrencies():void
        {
            sqlRunner.execute(CHECK_OFFLINE_CURRENCIES_SQL, null, checkOfflineCurrenciesResult, null, databaseErrorHandler);
        }

        private function checkOfflineCurrenciesResult(result:SQLResult):void
        {
            if (result.data != null && result.data[0].counter > 0)
            {
                this.loadCurrencies();
            }
            else
            {
                getAllCurrenciesOnlineSignal.dispatch();
            }
        }

        public function loadCurrencies():void
        {
            sqlRunner.execute(LOAD_CURRENCIES_SQL, null, loadCurrenciesResult, CurrencyVO, databaseErrorHandler);
        }

        private function loadCurrenciesResult(result:SQLResult):void
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

        public function deleteCurrencies():void
        {
            sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(DELETE_CURRENCIES_SQL)]), null, databaseErrorHandler);
        }

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
