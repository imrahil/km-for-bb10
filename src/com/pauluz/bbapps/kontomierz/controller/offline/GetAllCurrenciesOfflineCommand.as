/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller.offline
{
    import com.pauluz.bbapps.kontomierz.constants.ApplicationConstants;
    import com.pauluz.bbapps.kontomierz.constants.SQLStatements;
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.model.vo.CurrencyVO;
    import com.pauluz.bbapps.kontomierz.signals.GetAllCurrenciesOnlineSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllCurrenciesSignal;
    import com.probertson.data.SQLRunner;

    import flash.data.SQLResult;

    public final class GetAllCurrenciesOfflineCommand extends BaseOfflineCommand
    {
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var sqlRunner:SQLRunner;

        [Inject]
        public var provideAllCurrenciesSignal:ProvideAllCurrenciesSignal;

        [Inject]
        public var getAllCurrenciesOnlineSignal:GetAllCurrenciesOnlineSignal;

        /**
         * Method handle the logic for <code>GetAllCurrenciesCommand</code>
         */        
        override public function execute():void    
        {
            if (model.currenciesList && model.currenciesList.length > 0)
            {
                provideAllCurrenciesSignal.dispatch(model.currenciesList);
            }
            else
            {
                sqlRunner.execute(SQLStatements.LOAD_CURRENCIES_SQL, null, loadCurrenciesResult, CurrencyVO, databaseErrorHandler);
            }
        }

        private function loadCurrenciesResult(result:SQLResult):void
        {
            logger.debug(": loadCurrenciesResult");

            if (result.data != null && result.data.length > 0)
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
            else
            {
                getAllCurrenciesOnlineSignal.dispatch();
            }
        }
    }
}
