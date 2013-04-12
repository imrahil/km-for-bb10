/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.services
{
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.services.helpers.IResultParser;
    import com.pauluz.bbapps.kontomierz.signals.GetAllTransactionsOnlineSignal;
    import com.pauluz.bbapps.kontomierz.signals.offline.*;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.*;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import mx.logging.ILogger;

    public class KontomierzServiceBase
    {
        protected var userAgent:String;

        protected var _parser:IResultParser;
        protected var logger:ILogger;

        protected var responseStatus:int;

        protected var temporarySelectedTransaction:TransactionVO;

        /** MODEL **/
        [Inject]
        public var model:IKontomierzModel;

        /** INJECTS */
        [Inject]
        public function set parser(value:IResultParser):void
        {
            _parser = value;
        }

        /** NOTIFICATION SIGNALS */

        [Inject]
        public var transactionSuccessfullySavedSignal:TransactionSuccessfullySavedSignal;


        [Inject]
        public var errorSignal:ErrorSignal;

        [Inject]
        public var getAllTransactionsSignal:GetAllTransactionsOnlineSignal;

        [Inject]
        public var getAllWalletTransactionsSignal:GetAllWalletTransactionsOfflineSignal;

        [Inject]
        public var provideSelectedTransactionSignal:ProvideSelectedTransactionSignal;



        /** Constructor */
        public function KontomierzServiceBase()
        {
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }


        /********************
         *     HANDLERS
         ********************/
//        protected function loginCompleteHandler(event:Event):void
//        {
//            logger.debug(": loginCompleteHandler");
//
//            var loader:URLLoader = event.currentTarget as URLLoader;
//
//            loader.removeEventListener(Event.COMPLETE, loginCompleteHandler);
//            removeLoaderListeners(loader);
//
//            if (responseStatus == 200)
//            {
//                logger.debug(": handleLoginComplete - status: 200");
//
//                var apiKey:String = _parser.parseLoginRegisterResponse(loader.data as String);
//
//                if (apiKey != "")
//                {
//                    model.apiKey = apiKey;
//                }
//
//                if (model.rememberMe && !model.demoMode)
//                {
//                    saveAPIKeySignal.dispatch(apiKey);
//                }
//
//                loginSuccessfulSignal.dispatch();
//            }
//            else
//            {
//                logger.debug(": handleLoginComplete - status: 401");
//
//                var error:ErrorVO = new ErrorVO("Nieprawidłowy e-mail lub hasło.", true);
//                errorSignal.dispatch(error);
//            }
//        }

//        protected function getAllAccountsCompleteHandler(event:Event):void
//        {
//            logger.debug(": getAllAccountsCompleteHandler");
//
//            var loader:URLLoader = event.currentTarget as URLLoader;
//
//            loader.removeEventListener(Event.COMPLETE, getAllAccountsCompleteHandler);
//            removeLoaderListeners(loader);
//
//            if (responseStatus == 200)
//            {
//                var allAccountsData:Array = _parser.parseAllAccountsResponse(loader.data as String);
//                var accountsList:DataProvider = new DataProvider();
//                var defaultWallet:AccountVO;
//
//                for each (var account:AccountVO in allAccountsData)
//                {
//                    if (account.bankPluginName != ApplicationConstants.WALLET_ACCOUNT_NAME)
//                    {
//                        accountsList.addItem(account);
//                    }
//
//                    if (account.is_default_wallet)
//                    {
//                        defaultWallet = account;
//                    }
//                }
//
//                model.accountsList = accountsList;
//                provideAllAccountsDataSignal.dispatch(accountsList);
//
//                storeDefaultWalletSignal.dispatch(defaultWallet);
//
//                if (model.rememberMe && !model.demoMode)
//                {
//                    saveAccountsSignal.dispatch(allAccountsData);
//                }
//            }
//            else
//            {
//                logger.debug(": getAllAccountsCompleteHandler - status: " + responseStatus);
//
//                var error:ErrorVO = new ErrorVO("Wystąpił błąd: " + responseStatus);
//                errorSignal.dispatch(error);
//            }
//        }

//        protected function getAllTransactionsCompleteHandler(event:Event):void
//        {
//            logger.debug(": getAllTransactionsCompleteHandler");
//
//            var loader:URLLoader = event.currentTarget as URLLoader;
//
//            loader.removeEventListener(Event.COMPLETE, getAllTransactionsCompleteHandler);
//            removeLoaderListeners(loader);
//
//            var transactionsData:DataProvider = _parser.parseAllTransactionsResponse(loader.data as String, false);
//
//            if (model.rememberMe && !model.demoMode)
//            {
//                saveTransactionsSignal.dispatch(model.selectedAccount.accountId, false, transactionsData.data);
//            }
//            else
//            {
//                model.selectedAccount.isValid = true;
//                provideAllTransactionsSignal.dispatch(transactionsData);
//            }
//        }

//        protected function getAllTransactionsForWalletCompleteHandler(event:Event):void
//        {
//            logger.debug(": getAllTransactionsForWalletCompleteHandler");
//
//            var loader:URLLoader = event.currentTarget as URLLoader;
//
//            loader.removeEventListener(Event.COMPLETE, getAllTransactionsForWalletCompleteHandler);
//            removeLoaderListeners(loader);
//
//            var transactionsData:DataProvider = _parser.parseAllTransactionsResponse(loader.data as String, true);
//
//            model.walletTransactionsList = transactionsData;
//
//            if (model.rememberMe && !model.demoMode)
//            {
//                saveTransactionsSignal.dispatch(model.defaultWallet.accountId, true, transactionsData.data);
//            }
//            else
//            {
//                model.defaultWallet.isValid = true;
//                provideAllTransactionsSignal.dispatch(transactionsData);
//            }
//        }

//        protected function getAllTransactionsForCategoryCompleteHandler(event:Event):void
//        {
//            logger.debug(": getAllTransactionsForCategoryCompleteHandler");
//
//            var loader:URLLoader = event.currentTarget as URLLoader;
//
//            loader.removeEventListener(Event.COMPLETE, getAllTransactionsForCategoryCompleteHandler);
//            removeLoaderListeners(loader);
//
//            var transactionsData:DataProvider = _parser.parseAllTransactionsResponse(loader.data as String, false);
//
//            provideAllTransactionsSignal.dispatch(transactionsData);
//        }

//        protected function addTransactionCompleteHandler(event:Event):void
//        {
//            logger.debug(": addTransactionCompleteHandler");
//
//            var loader:URLLoader = event.currentTarget as URLLoader;
//
//            loader.removeEventListener(Event.COMPLETE, addTransactionCompleteHandler);
//            removeLoaderListeners(loader);
//
//            if (responseStatus == 201)
//            {
////                model.isWalletListExpired = true;
//                transactionSuccessfullySavedSignal.dispatch();
//            }
//            else
//            {
//                logger.debug(": addTransactionCompleteHandler - status: " + responseStatus);
//
//                var error:ErrorVO = new ErrorVO("Wystąpił błąd: " + responseStatus);
//                errorSignal.dispatch(error);
//            }
//        }

//        protected function updateTransactionCompleteHandler(event:Event):void
//        {
//            logger.debug(": updateTransactionCompleteHandler");
//
//            var loader:URLLoader = event.currentTarget as URLLoader;
//
//            loader.removeEventListener(Event.COMPLETE, updateTransactionCompleteHandler);
//            removeLoaderListeners(loader);
//
//            if (responseStatus == 200)
//            {
////                model.isWalletListExpired = true;
//                transactionSuccessfullySavedSignal.dispatch();
//
//                provideSelectedTransactionSignal.dispatch(temporarySelectedTransaction);
//            }
//            else
//            {
//                logger.debug(": updateTransactionCompleteHandler - status: " + responseStatus);
//
//                var error:ErrorVO = new ErrorVO("Wystąpił błąd: " + responseStatus);
//                errorSignal.dispatch(error);
//            }
//        }
//
//        protected function deleteTransactionCompleteHandler(event:Event):void
//        {
//            logger.debug(": deleteTransactionCompleteHandler");
//
//            var loader:URLLoader = event.currentTarget as URLLoader;
//
//            loader.removeEventListener(Event.COMPLETE, deleteTransactionCompleteHandler);
//            removeLoaderListeners(loader);
//
//            if (responseStatus == 200)
//            {
//                getAllTransactionsSignal.dispatch();
//            }
//            else
//            {
//                logger.debug(": deleteTransactionCompleteHandler - status: " + responseStatus);
//
//                var error:ErrorVO = new ErrorVO("Wystąpił błąd: " + responseStatus);
//                errorSignal.dispatch(error);
//            }
//        }
//
//        protected function deleteWalletTransactionCompleteHandler(event:Event):void
//        {
//            logger.debug(": deleteWalletTransactionCompleteHandler");
//
//            var loader:URLLoader = event.currentTarget as URLLoader;
//
//            loader.removeEventListener(Event.COMPLETE, deleteWalletTransactionCompleteHandler);
//            removeLoaderListeners(loader);
//
//            if (responseStatus == 200)
//            {
////                model.isWalletListExpired = true;
//                getAllWalletTransactionsSignal.dispatch();
//            }
//            else
//            {
//                logger.debug(": deleteWalletTransactionCompleteHandler - status: " + responseStatus);
//
//                var error:ErrorVO = new ErrorVO("Wystąpił błąd: " + responseStatus);
//                errorSignal.dispatch(error);
//            }
//        }

//        protected function getAllCategoriesWithdrawalCompleteHandler(event:Event):void
//        {
//            logger.debug(": getAllCategoriesWithdrawalCompleteHandler");
//
//            var loader:URLLoader = event.currentTarget as URLLoader;
//
//            loader.removeEventListener(Event.COMPLETE, getAllCategoriesWithdrawalCompleteHandler);
//            removeLoaderListeners(loader);
//
//            var categoriesList:SectionDataProvider = _parser.parseAllCategoriesResponse(loader.data as String);
//
//            model.withdrawalCategoriesList = categoriesList;
//            provideAllWithdrawalCategoriesSignal.dispatch(categoriesList);
//
//            saveCategoriesSignal.dispatch(categoriesList, ApplicationConstants.TRANSACTION_DIRECTION_WITHDRAWAL);
//        }

//        protected function getAllCategoriesDepositCompleteHandler(event:Event):void
//        {
//            logger.debug(": getAllCategoriesDepositCompleteHandler");
//
//            var loader:URLLoader = event.currentTarget as URLLoader;
//
//            loader.removeEventListener(Event.COMPLETE, getAllCategoriesDepositCompleteHandler);
//            removeLoaderListeners(loader);
//
//            var categoriesList:SectionDataProvider = _parser.parseAllCategoriesResponse(loader.data as String);
//
//            model.depositCategoriesList = categoriesList;
//            provideAllDepositCategoriesSignal.dispatch(categoriesList);
//
//            saveCategoriesSignal.dispatch(categoriesList, ApplicationConstants.TRANSACTION_DIRECTION_DEPOSIT);
//        }

//        protected function getAllCurrenciesCompleteHandler(event:Event):void
//        {
//            logger.debug(": getAllCurrenciesCompleteHandler");
//
//            var loader:URLLoader = event.currentTarget as URLLoader;
//
//            loader.removeEventListener(Event.COMPLETE, getAllCurrenciesCompleteHandler);
//            removeLoaderListeners(loader);
//
//            var currenciesList:Array = _parser.parseAllCurrenciesResponse(loader.data as String);
//
//            model.currenciesList = currenciesList;
//            provideAllCurrenciesSignal.dispatch(currenciesList);
//
//            saveCurrenciesSignal.dispatch(currenciesList);
//        }

//        protected function addLoaderListeners(loader:URLLoader):void
//        {
//            loader.addEventListener(IOErrorEvent.IO_ERROR, handleError);
//            loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onStatusEventHandler);
//            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
//        }
//
//        protected function removeLoaderListeners(loader:URLLoader):void
//        {
//            loader.removeEventListener(IOErrorEvent.IO_ERROR, handleError);
//            loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onStatusEventHandler);
//            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
//        }

        /**
         * Handler for errors
         * @param event
         */
//        protected function handleError(event:ErrorEvent):void
//        {
//            logger.error(": handleError - " + event.text);
//
//            removeLoaderListeners(event.currentTarget as URLLoader);
//
//            var error:ErrorVO = new ErrorVO(event.text);
//            errorSignal.dispatch(error);
//        }
//
//        protected function onStatusEventHandler(event:HTTPStatusEvent):void
//        {
//            logger.debug(": onStatusEventHandler - status: " + event.status);
//
//            responseStatus = event.status;
//        }

//        protected function prepareRequest():URLRequest
//        {
//            var urlRequest:URLRequest = new URLRequest();
//            urlRequest.userAgent = userAgent;
//            urlRequest.manageCookies = false;
//
//            return urlRequest;
//        }
    }
}
