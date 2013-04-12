/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller 
{
    import com.destroytoday.core.IPromise;
    import com.pauluz.bbapps.kontomierz.constants.ApplicationConstants;
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.model.vo.AccountVO;
    import com.pauluz.bbapps.kontomierz.model.vo.ErrorVO;
    import com.pauluz.bbapps.kontomierz.services.IKontomierzService;
    import com.pauluz.bbapps.kontomierz.services.helpers.IResultParser;
    import com.pauluz.bbapps.kontomierz.signals.StoreDefaultWalletSignal;
    import com.pauluz.bbapps.kontomierz.signals.offline.SaveAccountsSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllAccountsDataSignal;

    import qnx.ui.data.DataProvider;

    public final class GetAllAccountsOnlineCommand extends BaseOnlineCommand
    {
        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var kontomierzService:IKontomierzService;

        [Inject]
        public var parser:IResultParser;


        /** NOTIFICATION SIGNALS */
        [Inject]
        public var provideAllAccountsDataSignal:ProvideAllAccountsDataSignal;

        [Inject]
        public var storeDefaultWalletSignal:StoreDefaultWalletSignal;

        [Inject]
        public var saveAccountsSignal:SaveAccountsSignal;


        /**
         * Method handle the logic for <code>GetAllAccountsCommand</code>
         */        
        override public function execute():void    
        {
            var promise:IPromise = kontomierzService.getAllAccounts();
            promise.addResultProcessor(parser.parseAllAccountsResponse);
            promise.completed.addOnce(onGetAllAccounts);
            promise.failed.addOnce(onError);
        }

        /*
         *  COMPLETE HANDLER
         */
        private function onGetAllAccounts(promise:IPromise):void
        {
            var allAccountsData:Array = promise.result;

            var accountsList:DataProvider = new DataProvider();
            var defaultWallet:AccountVO;

            for each (var account:AccountVO in allAccountsData)
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

            storeDefaultWalletSignal.dispatch(defaultWallet);

            if (model.rememberMe && !model.demoMode)
            {
                saveAccountsSignal.dispatch(allAccountsData);
            }
        }
    }
}
