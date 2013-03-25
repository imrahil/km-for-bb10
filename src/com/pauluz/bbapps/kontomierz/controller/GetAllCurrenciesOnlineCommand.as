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
    import com.pauluz.bbapps.kontomierz.model.vo.CurrencyVO;
    import com.pauluz.bbapps.kontomierz.model.vo.ErrorVO;
    import com.pauluz.bbapps.kontomierz.services.IKontomierzService;
    import com.pauluz.bbapps.kontomierz.services.helpers.IResultParser;
    import com.pauluz.bbapps.kontomierz.signals.offline.SaveCurrenciesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllCurrenciesSignal;

    public final class GetAllCurrenciesOnlineCommand extends BaseOnlineCommand
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
        public var provideAllCurrenciesSignal:ProvideAllCurrenciesSignal;

        [Inject]
        public var saveCurrenciesSignal:SaveCurrenciesSignal;

        /**
         * Method handle the logic for <code>GetAllCurrenciesOnlineCommand</code>
         */        
        override public function execute():void    
        {
            var promise:IPromise = kontomierzService.getAllCurrencies();
            promise.addResultProcessor(parser.parseAllCurrenciesResponse);
            promise.completed.addOnce(onGetAllCurrencies);
            promise.failed.addOnce(onError);
        }

        /*
         *  COMPLETE HANDLER
         */
        private function onGetAllCurrencies(promise:IPromise):void
        {
            var currenciesList:Array = promise.result;

            model.currenciesList = currenciesList;
            provideAllCurrenciesSignal.dispatch(currenciesList);

            saveCurrenciesSignal.dispatch(currenciesList);
        }
    }
}
