/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller 
{
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.services.IKontomierzService;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllCurrenciesSignal;

    import org.robotlegs.mvcs.SignalCommand;

    public final class GetAllCurrenciesCommand extends SignalCommand 
    {
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var kontomierzService:IKontomierzService;

        [Inject]
        public var provideAllCurrenciesSignal:ProvideAllCurrenciesSignal;

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
                kontomierzService.getAllCurrencies();
            }
        }
    }
}
