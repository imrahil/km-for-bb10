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
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.model.vo.UserVO;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;

    public class KontomierzService extends KontomierzServiceBase
    {
        public function KontomierzService()
        {
            super();

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }


        /**
         * LOGIN
         */
        override public function login(user:UserVO):void
        {
            logger.debug(": login service call - email: " + user.email + ", password: " + user.password);

            // save value for future
            model.rememberMe = user.rememberMe;

            var loader:URLLoader = new URLLoader();
            var urlRequest:URLRequest = prepareRequest();

            urlRequest.url = ApplicationConstants.KONTOMIERZ_API_ENDPOINT + "session" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON;
            urlRequest.method = URLRequestMethod.POST;

            var variables:URLVariables = new URLVariables();
            variables.email = user.email;
            variables.password = user.password;
            urlRequest.data = variables;

            loader.addEventListener(Event.COMPLETE, loginCompleteHandler);
            addLoaderListeners(loader);

            loader.load(urlRequest);
        }

        /**
         * REGISTER
         */
        override public function register(user:UserVO):void
        {
            logger.debug(": register service call");

            var loader:URLLoader = new URLLoader();
            var urlRequest:URLRequest = prepareRequest();

            urlRequest.url = ApplicationConstants.KONTOMIERZ_API_ENDPOINT + "users" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON;
            urlRequest.method = URLRequestMethod.POST;

            var variables:URLVariables = new URLVariables();
            variables.email = user.email;
            variables.password = user.password;
            urlRequest.data = variables;

            loader.addEventListener(Event.COMPLETE, loginCompleteHandler);
            addLoaderListeners(loader);

            loader.load(urlRequest);
        }

        /**
         * DEMO
         */
        override public function demo():void
        {
            logger.debug(": demo service call");

            model.apiKey = ApplicationConstants.KONTOMIERZ_DEMO_API_KEY;

            loginSuccessfulSignal.dispatch();
        }

        /**
         * GET ALL ACCOUNTS
         */
        override public function getAllAccounts():void
        {
            logger.debug(": getAllAccounts service call");

            var loader:URLLoader = new URLLoader();
            var urlRequest:URLRequest = prepareRequest();

            urlRequest.url = ApplicationConstants.KONTOMIERZ_API_ENDPOINT + "user_accounts" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON + "?api_key=" + model.apiKey;

            loader.addEventListener(Event.COMPLETE, getAllAccountsCompleteHandler);
            addLoaderListeners(loader);

            loader.load(urlRequest);
        }

        /**
         * GET ALL TRANSACTIONS
         */
        override public function getAllTransactions(accountId:int):void
        {
            logger.debug(": getAllTransactions service call");

            var loader:URLLoader = new URLLoader();
            var urlRequest:URLRequest = prepareRequest();

            var url:String = ApplicationConstants.KONTOMIERZ_API_ENDPOINT + "money_transactions" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON;
            url += "?user_account_id=" + accountId;
            url += "&start_on=01-01-2011";
            url += "&api_key=" + model.apiKey;
            urlRequest.url = url;

            loader.addEventListener(Event.COMPLETE, getAllTransactionsCompleteHandler);
            addLoaderListeners(loader);

            loader.load(urlRequest);
        }

        /**
         * GET ALL WALLET TRANSACTIONS
         */
        override public function getAllWalletTransactions():void
        {
            logger.debug(": getAllWalletTransactions service call");

            var loader:URLLoader = new URLLoader();
            var urlRequest:URLRequest = prepareRequest();

            var url:String = ApplicationConstants.KONTOMIERZ_API_ENDPOINT + "money_transactions" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON;
            url += "?user_account_id=" + model.defaultWallet.accountId;
            url += "&start_on=01-01-2011";
            url += "&api_key=" + model.apiKey;
            urlRequest.url = url;

            loader.addEventListener(Event.COMPLETE, getAllTransactionsForWalletCompleteHandler);
            addLoaderListeners(loader);

            loader.load(urlRequest);
        }

        /**
         * GET ALL TRANSACTIONS FOR CATEGORY
         */
        override public function getAllTransactionsForCategory(categoryId:int):void
        {
            logger.debug(": getAllTransactionsForCategory service call");

            var loader:URLLoader = new URLLoader();
            var urlRequest:URLRequest = prepareRequest();

            var url:String = ApplicationConstants.KONTOMIERZ_API_ENDPOINT + "money_transactions" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON;
            url += "?category_id=" + categoryId;
            url += "&start_on=01-01-2011";
            url += "&api_key=" + model.apiKey;
            urlRequest.url = url;

            loader.addEventListener(Event.COMPLETE, getAllTransactionsForCategoryCompleteHandler);
            addLoaderListeners(loader);

            loader.load(urlRequest);
        }


        /**
         * CREATE TRANSACTION
         */
        override public function createTransaction(transaction:TransactionVO):void
        {
            logger.debug(": createTransaction service call");

            var loader:URLLoader = new URLLoader();
            var urlRequest:URLRequest = prepareRequest();

            urlRequest.url = ApplicationConstants.KONTOMIERZ_API_ENDPOINT + "money_transactions" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON;
            urlRequest.method = URLRequestMethod.POST;

            var variables:URLVariables = new URLVariables();
            variables["money_transaction[currency_amount]"] = transaction.currencyAmount;
            variables["money_transaction[currency_name]"] = transaction.currencyName;
            variables["money_transaction[transaction_on]"] = transaction.transactionOn.substr(8, 2) + "-" + transaction.transactionOn.substr(5, 2) + "-" + transaction.transactionOn.substr(0, 4);
            variables["money_transaction[name]"] = transaction.description;
            variables["money_transaction[category_id]"] = transaction.categoryId;
            variables["money_transaction[direction]"] = transaction.direction;
            variables["money_transaction[client_assigned_id]"] = new Date().getMilliseconds();
            variables["api_key"] = model.apiKey;
            urlRequest.data = variables;

            loader.addEventListener(Event.COMPLETE, addTransactionCompleteHandler);
            addLoaderListeners(loader);

            loader.load(urlRequest);
        }


        /**
         * UPDATE TRANSACTION
         */
        override public function updateTransaction(transaction:TransactionVO):void
        {
            logger.debug(": updateTransaction service call");

            temporarySelectedTransaction = transaction;

            var loader:URLLoader = new URLLoader();
            var urlRequest:URLRequest = prepareRequest();

            urlRequest.url = ApplicationConstants.KONTOMIERZ_API_ENDPOINT + "money_transactions/" + transaction.transactionId + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON;
            urlRequest.method = URLRequestMethod.PUT;

            var variables:URLVariables = new URLVariables();
            variables["money_transaction[currency_amount]"] = transaction.currencyAmount;
            variables["money_transaction[currency_name]"] = transaction.currencyName;
            variables["money_transaction[transaction_on]"] = transaction.transactionOn.substr(8, 2) + "-" + transaction.transactionOn.substr(5, 2) + "-" + transaction.transactionOn.substr(0, 4);
            variables["money_transaction[name]"] = transaction.description;
            variables["money_transaction[category_id]"] = transaction.categoryId;
            variables["money_transaction[direction]"] = transaction.direction;
            variables["api_key"] = model.apiKey;
            urlRequest.data = variables;

            loader.addEventListener(Event.COMPLETE, updateTransactionCompleteHandler);
            addLoaderListeners(loader);

            loader.load(urlRequest);
        }

        /**
         * DELETE TRANSACTION
         */
        override public function deleteTransaction(id:int, wallet:Boolean):void
        {
            logger.debug(": deleteTransaction service call");

            var loader:URLLoader = new URLLoader();
            var urlRequest:URLRequest = prepareRequest();

            urlRequest.url = ApplicationConstants.KONTOMIERZ_API_ENDPOINT + "money_transactions/" + id + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON + "?api_key=" + model.apiKey;
            urlRequest.method = URLRequestMethod.DELETE;

            if (wallet)
            {
                loader.addEventListener(Event.COMPLETE, deleteWalletTransactionCompleteHandler);
            }
            else
            {
                loader.addEventListener(Event.COMPLETE, deleteTransactionCompleteHandler);
            }

            addLoaderListeners(loader);

            loader.load(urlRequest);
        }

        /**
         * GET ALL WITHDRAWAL CATEGORIES
         */
        override public function getAllWithdrawalCategories():void
        {
            logger.debug(": getAllCategoriesWithdrawal service call");

            var loader:URLLoader = new URLLoader();
            var urlRequest:URLRequest = prepareRequest();

            var url:String = ApplicationConstants.KONTOMIERZ_API_ENDPOINT + "categories" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON;
            url += "?direction=withdrawal&in_wallet=true";
            url += "&api_key=" + model.apiKey;
            urlRequest.url = url;

            loader.addEventListener(Event.COMPLETE, getAllCategoriesWithdrawalCompleteHandler);
            addLoaderListeners(loader);

            loader.load(urlRequest);
        }

        /**
         * GET ALL DEPOSIT ATEGORIES
         */
        override public function getAllDepositCategories():void
        {
            logger.debug(": getAllCategoriesDeposit service call");

            var loader:URLLoader = new URLLoader();
            var urlRequest:URLRequest = prepareRequest();

            var url:String = ApplicationConstants.KONTOMIERZ_API_ENDPOINT + "categories" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON;
            url += "?direction=deposit&in_wallet=true";
            url += "&api_key=" + model.apiKey;
            urlRequest.url = url;

            loader.addEventListener(Event.COMPLETE, getAllCategoriesDepositCompleteHandler);
            addLoaderListeners(loader);

            loader.load(urlRequest);
        }

        /**
         * GET ALL CURRENCIES
         */
        override public function getAllCurrencies():void
        {
            logger.debug(": getAllCurrencies service call");

            var loader:URLLoader = new URLLoader();
            var urlRequest:URLRequest = prepareRequest();

            var url:String = ApplicationConstants.KONTOMIERZ_API_ENDPOINT + "currencies" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON;
            url += "?api_key=" + model.apiKey;
            urlRequest.url = url;

            loader.addEventListener(Event.COMPLETE, getAllCurrenciesCompleteHandler);
            addLoaderListeners(loader);

            loader.load(urlRequest);
        }
    }
}
