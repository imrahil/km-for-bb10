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
    import com.pauluz.bbapps.kontomierz.model.vo.ErrorVO;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.model.vo.UserVO;
    import com.pauluz.bbapps.kontomierz.services.helpers.IResultParser;
    import com.pauluz.bbapps.kontomierz.signals.StoreDefaultWalletIdSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ErrorSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.LoginSuccessfulSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllAccountsDataSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllCategoriesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllTransactionsSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.TransactionSuccessfulySavedSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.SharedObject;
    import flash.net.URLLoader;

    import mx.collections.ArrayCollection;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.Actor;

    import qnx.ui.data.DataProvider;
    import qnx.ui.data.SectionDataProvider;

    public class KontomierzServiceBase extends Actor implements IKontomierzService
    {
        protected var _parser:IResultParser;
        protected var logger:ILogger;

        protected var rememberMe:Boolean;
        protected var responseStatus:int;

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
        public var loginSuccessfulSignal:LoginSuccessfulSignal;

        [Inject]
        public var provideAllAccountsDataSignal:ProvideAllAccountsDataSignal;

        [Inject]
        public var provideAllTransactionsSignal:ProvideAllTransactionsSignal;

        [Inject]
        public var transactionSuccessfulySavedSignal:TransactionSuccessfulySavedSignal;

        [Inject]
        public var provideAllCategoriesSignal:ProvideAllCategoriesSignal;

        [Inject]
        public var storeDefaultWalletIdSignal:StoreDefaultWalletIdSignal;

        [Inject]
        public var errorSignal:ErrorSignal;

        /** Constructor */
        public function KontomierzServiceBase()
        {
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        public function login(user:UserVO):void
        {
            throw new Error("Override this method!");
        }

        public function register(user:UserVO):void
        {
            throw new Error("Override this method!");
        }

        public function getAllAccounts(apiKey:String):void
        {
            throw new Error("Override this method!");
        }

        public function createWallet(name:String, balance:Number, currency:String, liquid:Boolean, apiKey:String):void
        {
            throw new Error("Override this method!");
        }

        public function updateWallet(id:int, name:String, balance:Number, currency:String, liquid:Boolean, apiKey:String):void
        {
            throw new Error("Override this method!");
        }

        public function deleteWallet(id:int, apiKey:String):void
        {
            throw new Error("Override this method!");
        }

        public function getAllTransactions(accountId:int, apiKey:String):void
        {
            throw new Error("Override this method!");
        }

        public function getAllCategories(apiKey:String):void
        {
            throw new Error("Override this method!");
        }

        public function getAllTransactionsForCategory(categoryId:int, apiKey:String):void
        {
            throw new Error("Override this method!");
        }

        public function createTransaction(transaction:TransactionVO, apiKey:String):void
        {
            throw new Error("Override this method!");
        }

        /********************
         *     HANDLERS
         ********************/
        protected function loginCompleteHandler(event:Event):void
        {
            logger.debug(": loginCompleteHandlere");

            var loader:URLLoader = event.currentTarget as URLLoader;

            loader.removeEventListener(Event.COMPLETE, loginCompleteHandler);
            removeLoaderListeners(loader);

            if (responseStatus == 200)
            {
                logger.debug(": handleLoginComplete - status: 200");

                var apiKey:String = _parser.parseLoginRegisterResponse(loader.data as String);

                if (apiKey != "")
                {
                    model.apiKey = apiKey;
                }

                if (rememberMe)
                {
                    var sessionSO:SharedObject = SharedObject.getLocal(ApplicationConstants.KONTOMIERZ_SO_NAME);
                    sessionSO.data.apiKey = apiKey;
                    sessionSO.flush();
                }

                loginSuccessfulSignal.dispatch();
            }
            else
            {
                logger.debug(": handleLoginComplete - status: 401");

                var error:ErrorVO = new ErrorVO("Nieprawidłowy e-mail lub hasło.", true);
                errorSignal.dispatch(error);
            }
        }

        protected function getAllAccountsCompleteHandler(event:Event):void
        {
            logger.debug(": getAllAccountsCompleteHandler");

            var loader:URLLoader = event.currentTarget as URLLoader;

            loader.removeEventListener(Event.COMPLETE, getAllAccountsCompleteHandler);
            removeLoaderListeners(loader);

            if (responseStatus == 200)
            {
                var accountsData:DataProvider = _parser.parseAllAccountsResponse(loader.data as String);
                provideAllAccountsDataSignal.dispatch(accountsData);

                var defaultWalletId:int = _parser.parseAllAccountsResponseAndFindDefaultWalletId(loader.data as String);
                storeDefaultWalletIdSignal.dispatch(defaultWalletId);
            }
            else
            {
                logger.debug(": getAllAccountsCompleteHandler - status: " + responseStatus);

                var error:ErrorVO = new ErrorVO("Wystąpił błąd: " + responseStatus);
                errorSignal.dispatch(error);
            }
        }

        protected function getAllTransactionsCompleteHandler(event:Event):void
        {
            logger.debug(": getAllTransactionsCompleteHandler");

            var loader:URLLoader = event.currentTarget as URLLoader;

            loader.removeEventListener(Event.COMPLETE, getAllTransactionsCompleteHandler);
            removeLoaderListeners(loader);

            var transactionsData:DataProvider = _parser.parseAllTransactionsResponse(loader.data as String);

            provideAllTransactionsSignal.dispatch(transactionsData);
        }

        protected function addTransactionCompleteHandler(event:Event):void
        {
            logger.debug(": addTransactionCompleteHandler");

            var loader:URLLoader = event.currentTarget as URLLoader;

            loader.removeEventListener(Event.COMPLETE, addTransactionCompleteHandler);
            removeLoaderListeners(loader);

            if (responseStatus == 201)
            {
                transactionSuccessfulySavedSignal.dispatch();
            }
            else
            {
                logger.debug(": addTransactionCompleteHandler - status: " + responseStatus);

                var error:ErrorVO = new ErrorVO("Wystąpił błąd: " + responseStatus);
                errorSignal.dispatch(error);
            }
        }

        protected function getAllCategoriesCompleteHandler(event:Event):void
        {
            logger.debug(": getAllCategoriesCompleteHandler");

            var loader:URLLoader = event.currentTarget as URLLoader;

            loader.removeEventListener(Event.COMPLETE, getAllCategoriesCompleteHandler);
            removeLoaderListeners(loader);

            var categoriesList:SectionDataProvider = _parser.parseAllCategoriesResponse(loader.data as String);

            model.categoriesList = categoriesList;
            provideAllCategoriesSignal.dispatch(categoriesList);
        }

        protected function addLoaderListeners(loader:URLLoader):void
        {
            loader.addEventListener(IOErrorEvent.IO_ERROR, handleError);
            loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onStatusEventHandler);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
        }

        protected function removeLoaderListeners(loader:URLLoader):void
        {
            loader.removeEventListener(IOErrorEvent.IO_ERROR, handleError);
            loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onStatusEventHandler);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
        }

        /**
         * Handler for errors
         * @param event
         */
        protected function handleError(event:ErrorEvent):void
        {
            logger.error(": handleError - " + event.text);

            removeLoaderListeners(event.currentTarget as URLLoader);

            var error:ErrorVO = new ErrorVO(event.text);
            errorSignal.dispatch(error);
        }

        private function onStatusEventHandler(event:HTTPStatusEvent):void
        {
            logger.debug(": onStatusEventHandler - status: " + event.status);

            responseStatus = event.status;
        }
    }
}
