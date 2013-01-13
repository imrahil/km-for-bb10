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
            rememberMe = user.rememberMe;

            var loader:URLLoader = new URLLoader();
            var urlRequest:URLRequest = new URLRequest();

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
            var urlRequest:URLRequest = new URLRequest();

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


        override public function getAllAccounts(apiKey:String):void
        {
            logger.debug(": getAllAccounts service call");

            var loader:URLLoader = new URLLoader();
            var urlRequest:URLRequest = new URLRequest();

            urlRequest.url = ApplicationConstants.KONTOMIERZ_API_ENDPOINT + "user_accounts" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON + "?api_key=" + apiKey;

            loader.addEventListener(Event.COMPLETE, getAllAccountsCompleteHandler);
            addLoaderListeners(loader);

            loader.load(urlRequest);
        }

        override public function createWallet(name:String, balance:Number, currency:String, liquid:Boolean, apiKey:String):void
        {
            logger.debug(": createWallet service call");

        }

        override public function updateWallet(id:int, name:String, balance:Number, currency:String, liquid:Boolean, apiKey:String):void
        {
            logger.debug(": updateWallet service call");

        }

        override public function deleteWallet(id:int, apiKey:String):void
        {
            logger.debug(": deleteWallet service call");

        }

        override public function getAllTransactions(accountId:int, apiKey:String):void
        {
            logger.debug(": getAllTransactions service call");

            var loader:URLLoader = new URLLoader();
            var urlRequest:URLRequest = new URLRequest();

            var url:String = ApplicationConstants.KONTOMIERZ_API_ENDPOINT + "money_transactions" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON;
            url += "?user_account_id=" + accountId;
            url += "&start_on=01-01-2011";
            url += "&api_key=" + apiKey;
            urlRequest.url = url;

            loader.addEventListener(Event.COMPLETE, getAllTransactionsCompleteHandler);
            addLoaderListeners(loader);

            loader.load(urlRequest);
        }

        override public function getAllTransactionsForCategory(categoryId:int, apiKey:String):void
        {
            logger.debug(": getAllTransactionsForCategory service call");

            var loader:URLLoader = new URLLoader();
            var urlRequest:URLRequest = new URLRequest();

            var url:String = ApplicationConstants.KONTOMIERZ_API_ENDPOINT + "money_transactions" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON;
            url += "?category_id=" + categoryId;
            url += "&start_on=01-01-2011";
            url += "&api_key=" + apiKey;
            urlRequest.url = url;

            loader.addEventListener(Event.COMPLETE, getAllTransactionsCompleteHandler);
            addLoaderListeners(loader);

            loader.load(urlRequest);
        }


        override public function createTransaction(transaction:TransactionVO, apiKey:String):void
        {
            logger.debug(": createTransaction service call");

            var loader:URLLoader = new URLLoader();
            var urlRequest:URLRequest = new URLRequest();

            urlRequest.url = ApplicationConstants.KONTOMIERZ_API_ENDPOINT + "money_transactions" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON;
            urlRequest.method = URLRequestMethod.POST;

            var variables:URLVariables = new URLVariables();
            variables["money_transaction[category_id]"] = 101;
            variables["money_transaction[currency_amount]"] = transaction.amount;
            variables["money_transaction[name]"] = transaction.description;
            var apiDate:String = transaction.transactionOn.substr(8, 2) + "-" + transaction.transactionOn.substr(5, 2) + "-" + transaction.transactionOn.substr(0, 4);
            variables["money_transaction[transaction_on]"] = apiDate;
            variables["money_transaction[client_assigned_id]"] = new Date().getMilliseconds();
            variables["api_key"] = apiKey;
            urlRequest.data = variables;

            loader.addEventListener(Event.COMPLETE, addTransactionCompleteHandler);
            addLoaderListeners(loader);

            loader.load(urlRequest);
        }

        override public function getAllCategories(apiKey:String):void
        {
            logger.debug(": getAllTransactions service call");

            var loader:URLLoader = new URLLoader();
            var urlRequest:URLRequest = new URLRequest();

            var url:String = ApplicationConstants.KONTOMIERZ_API_ENDPOINT + "categories" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON;
            url += "?direction=withdrawal&in_wallet=true";
            url += "&api_key=" + apiKey;
            urlRequest.url = url;

            loader.addEventListener(Event.COMPLETE, getAllCategoriesCompleteHandler);
            addLoaderListeners(loader);

            loader.load(urlRequest);
        }
    }
}
