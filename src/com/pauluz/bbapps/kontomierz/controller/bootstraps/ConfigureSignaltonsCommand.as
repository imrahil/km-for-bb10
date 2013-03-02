/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller.bootstraps
{
    import com.pauluz.bbapps.kontomierz.signals.configure.ConfigureServiceSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.*;

    import org.robotlegs.mvcs.SignalCommand;

    public class ConfigureSignaltonsCommand extends SignalCommand
    {
        [Inject]
        public var nextStepSignal:ConfigureServiceSignal;

        override public function execute():void
        {
            injector.mapSingleton(ProvideLoginStatusSignal);
            injector.mapSingleton(LoginSuccessfulSignal);
            injector.mapSingleton(ErrorSignal);

            injector.mapSingleton(ProvideAllAccountsDataSignal);
            injector.mapSingleton(ProvideAllTransactionsSignal);

            injector.mapSingleton(TransactionSuccessfullySavedSignal);

            injector.mapSingleton(SelectedAccountSuccessfulStoreSignal);
            injector.mapSingleton(SelectedTransactionSuccessfulStoreSignal);
            injector.mapSingleton(TransactionForEditSuccessfulStoreSignal);

            injector.mapSingleton(ProvideSelectedTransactionSignal);

            injector.mapSingleton(ProvideAllWithdrawalCategoriesSignal);
            injector.mapSingleton(ProvideAllDepositCategoriesSignal);
            injector.mapSingleton(SelectedCategorySuccessfulStoreSignal);

            injector.mapSingleton(ProvideAllCurrenciesSignal);

            nextStepSignal.dispatch();
        }
    }
}
