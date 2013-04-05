/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.services
{
    import com.destroytoday.core.IPromise;
    import com.pauluz.bbapps.kontomierz.constants.ApplicationConstants;
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.model.vo.UserVO;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import flash.desktop.NativeApplication;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;

    import mx.logging.ILogger;

    import org.robotlegs.oil.rest.IRestClient;
    import org.robotlegs.oil.rest.RestClientBase;

    public class KontomierzService implements IKontomierzService
    {
        /** MODEL **/
        [Inject]
        public var model:IKontomierzModel;

        protected var service:IRestClient;

        protected var userAgent:String;
        protected var logger:ILogger;

        public function KontomierzService()
        {
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");

            var app_xml:XML = NativeApplication.nativeApplication.applicationDescriptor;
            var ns:Namespace = app_xml.namespace();
            var versionNumber:String = app_xml.ns::versionNumber;
            var userAgent:String = ApplicationConstants.WYDATKI_USER_AGENT + versionNumber;

            service = new RestClientBase(ApplicationConstants.KONTOMIERZ_API_ENDPOINT, userAgent);
        }


        /**
         * LOGIN
         */
        public function login(user:UserVO):IPromise
        {
            logger.debug(": login service call - email: " + user.email + ", password: " + user.password);

            var params:Object = {};
            params.email = user.email;
            params.password = user.password;

            return service.post("session" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON, params);
        }

        /**
         * REGISTER
         */
        public function register(user:UserVO):IPromise
        {
//            logger.debug(": register service call");
//
//            var loader:URLLoader = new URLLoader();
//            var urlRequest:URLRequest = prepareRequest();
//
//            urlRequest.url = ApplicationConstants.KONTOMIERZ_API_ENDPOINT + "users" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON;
//            urlRequest.method = URLRequestMethod.POST;
//
//            var variables:URLVariables = new URLVariables();
//            variables.email = user.email;
//            variables.password = user.password;
//            urlRequest.data = variables;
//
//            loader.addEventListener(Event.COMPLETE, loginCompleteHandler);
//            addLoaderListeners(loader);
//
//            loader.load(urlRequest);
            return null;
        }

        /**
         * GET ALL ACCOUNTS
         */
        public function getAllAccounts():IPromise
        {
            logger.debug(": getAllAccounts service call");

            var params:Object = {};
            params.api_key = model.apiKey;

            return service.get("user_accounts" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON, params);
        }


        /**
         * GET ALL TRANSACTIONS
         */
        public function getAllTransactions(accountId:int):IPromise
        {
            logger.debug(": getAllTransactions service call");

            var params:Object = {};
            params.user_account_id = accountId;
            params.start_on = "01-01-2011";
            params.api_key = model.apiKey;

            return service.get("money_transactions" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON, params);
        }


        /**
         * GET ALL WALLET TRANSACTIONS
         */
        public function getAllWalletTransactions():IPromise
        {
            logger.debug(": getAllWalletTransactions service call");

            var params:Object = {};
            params.user_account_id = model.defaultWallet.accountId;
            params.start_on = "01-01-2011";
            params.api_key = model.apiKey;

            return service.get("money_transactions" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON, params);
        }

        /**
         * GET ALL TRANSACTIONS FOR CATEGORY
         */
        public function getAllTransactionsForCategory(categoryId:int):IPromise
        {
            logger.debug(": getAllTransactionsForCategory service call");

            var params:Object = {};
            params.category_id = categoryId;
            params.start_on = "01-01-2011";
            params.api_key = model.apiKey;

            return service.get("money_transactions" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON, params);
        }


        /**
         * CREATE TRANSACTION
         */
        public function createTransaction(transaction:TransactionVO):IPromise
        {
            logger.debug(": createTransaction service call");

            var params:Object = {};
            params["money_transaction[currency_amount]"] = transaction.currencyAmount;
            params["money_transaction[currency_name]"] = transaction.currencyName;
            params["money_transaction[transaction_on]"] = transaction.transactionOn.substr(8, 2) + "-" + transaction.transactionOn.substr(5, 2) + "-" + transaction.transactionOn.substr(0, 4);
            params["money_transaction[name]"] = transaction.description;
            params["money_transaction[category_id]"] = transaction.categoryId;
            params["money_transaction[direction]"] = transaction.direction;
            params["money_transaction[client_assigned_id]"] = new Date().getMilliseconds();
            params.api_key = model.apiKey;

            return service.post("money_transactions" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON, params);
        }


        /**
         * UPDATE TRANSACTION
         */
        public function updateTransaction(transaction:TransactionVO):IPromise
        {
            logger.debug(": updateTransaction service call");

            var params:Object = {};
            params["money_transaction[currency_amount]"] = transaction.currencyAmount;
            params["money_transaction[currency_name]"] = transaction.currencyName;
            params["money_transaction[transaction_on]"] = transaction.transactionOn.substr(8, 2) + "-" + transaction.transactionOn.substr(5, 2) + "-" + transaction.transactionOn.substr(0, 4);
            params["money_transaction[name]"] = transaction.description;
            params["money_transaction[category_id]"] = transaction.categoryId;
            params["money_transaction[direction]"] = transaction.direction;
            params.api_key = model.apiKey;

            return service.put("money_transactions/" + transaction.transactionId + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON, params);
        }

        /**
         * DELETE TRANSACTION
         */
        public function deleteTransaction(id:int):IPromise
        {
            logger.debug(": deleteTransaction service call");

            var params:Object = {};
            params.api_key = model.apiKey;

            return service.del("money_transactions/" + id + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON, params);
        }

        /**
         * GET ALL WITHDRAWAL CATEGORIES
         */
        public function getAllWithdrawalCategories():IPromise
        {
            logger.debug(": getAllCategoriesWithdrawal service call");

            var params:Object = {};
            params.direction = "withdrawal";
            params.in_wallet = true;
            params.api_key = model.apiKey;

            return service.get("categories" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON, params);
        }

        /**
         * GET ALL DEPOSIT ATEGORIES
         */
        public function getAllDepositCategories():IPromise
        {
            logger.debug(": getAllCategoriesDeposit service call");

            var params:Object = {};
            params.direction = "deposit";
            params.in_wallet = true;
            params.api_key = model.apiKey;

            return service.get("categories" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON, params);
        }

        /**
         * GET ALL CURRENCIES
         */
        public function getAllCurrencies():IPromise
        {
            logger.debug(": getAllCurrencies service call");

            var params:Object = {};
            params.api_key = model.apiKey;

            return service.get("currencies" + ApplicationConstants.KONTOMIERZ_API_FORMAT_JSON, params);
        }
    }
}
