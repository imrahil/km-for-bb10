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
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.services.IKontomierzService;
    import com.pauluz.bbapps.kontomierz.services.helpers.IResultParser;
    import com.pauluz.bbapps.kontomierz.signals.offline.SaveTransactionsSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllTransactionsSignal;

    import qnx.ui.data.DataProvider;

    public final class GetAllTransactionsOnlineCommand extends BaseOnlineCommand
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
        public var provideAllTransactionsSignal:ProvideAllTransactionsSignal;

        [Inject]
        public var saveTransactionsSignal:SaveTransactionsSignal;

        /**
         * Method handle the logic for <code>GetAllTransactionsCommand</code>
         */        
        override public function execute():void    
        {
            var promise:IPromise = kontomierzService.getAllTransactions(model.selectedAccount.accountId);
            promise.addResultProcessor(parser.parseAllTransactionsResponse);
            promise.completed.addOnce(onGetAllTransactions);
            promise.failed.addOnce(onError);
        }

        /*
         *  COMPLETE HANDLER
         */
        private function onGetAllTransactions(promise:IPromise):void
        {
            var transactionsData:DataProvider = promise.result;

            if (model.rememberMe && !model.demoMode)
            {
                saveTransactionsSignal.dispatch(model.selectedAccount.accountId, false, transactionsData.data);
            }
            else
            {
                model.selectedAccount.isValid = true;
                provideAllTransactionsSignal.dispatch(transactionsData);
            }
        }
    }
}
