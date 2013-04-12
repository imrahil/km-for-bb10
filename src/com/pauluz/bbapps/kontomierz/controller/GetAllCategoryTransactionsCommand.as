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
    import com.pauluz.bbapps.kontomierz.model.vo.ErrorVO;
    import com.pauluz.bbapps.kontomierz.services.IKontomierzService;
    import com.pauluz.bbapps.kontomierz.services.helpers.IResultParser;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllTransactionsSignal;

    import qnx.ui.data.DataProvider;

    public final class GetAllCategoryTransactionsCommand extends BaseOnlineCommand
    {
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var kontomierzService:IKontomierzService;

        [Inject]
        public var parser:IResultParser;


        /** NOTIFICATION SIGNALS */
        [Inject]
        public var provideAllTransactionsSignal:ProvideAllTransactionsSignal;

        /**
         * Method handle the logic for <code>GetAllCategoryTransactionsCommand</code>
         */        
        override public function execute():void    
        {
            if (model.isConnected)
            {
                var promise:IPromise = kontomierzService.getAllTransactionsForCategory(model.selectedCategory.categoryId);
                promise.addResultProcessor(parser.parseAllTransactionsResponse);
                promise.completed.addOnce(onGetAllTransactionsForCategory);
                promise.failed.addOnce(onError);
            }
            else
            {
                var error:ErrorVO = new ErrorVO("Wymagane połączenie z internetem. Proszę spróbować później.", true);
                errorSignal.dispatch(error);
            }
        }

        /*
         *  COMPLETE HANDLER
         */
        private function onGetAllTransactionsForCategory(promise:IPromise):void
        {
            var transactionsData:DataProvider = promise.result;

            provideAllTransactionsSignal.dispatch(transactionsData);
        }
    }
}
