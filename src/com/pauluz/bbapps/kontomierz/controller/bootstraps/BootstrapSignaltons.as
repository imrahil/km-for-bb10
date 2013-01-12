/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller.bootstraps
{
    import com.pauluz.bbapps.kontomierz.signals.signaltons.*;

    import org.robotlegs.core.IInjector;

    public class BootstrapSignaltons
    {
        public function BootstrapSignaltons(injector:IInjector)
        {
            injector.mapSingleton(ProvideLoginStatusSignal);
            injector.mapSingleton(LoginSuccessfulSignal);
            injector.mapSingleton(ErrorSignal);

            injector.mapSingleton(ProvideAllAccountsDataSignal);
            injector.mapSingleton(ProvideAllTransactionsSignal);

            injector.mapSingleton(SelectedAccountSuccessfulStoreSignal);
            injector.mapSingleton(SelectedTransactionSuccessfulStoreSignal);

            injector.mapSingleton(ProvideSelectedTransactionSignal);

            injector.mapSingleton(ProvideAllCategoriesSignal);
            injector.mapSingleton(SelectedCategorySuccessfulStoreSignal);
        }
    }
}
