/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller.bootstraps
{
    import com.pauluz.bbapps.kontomierz.signals.configure.ConfigureNetworkConnectivitySignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.view.*;
    import com.pauluz.bbapps.kontomierz.view.mediators.*;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.SignalCommand;

    public class ConfigureViewMediatorsCommand extends SignalCommand
    {
        [Inject]
        public var nextStepSignal:ConfigureNetworkConnectivitySignal;

        override public function execute():void
        {
            var logger:ILogger = LogUtil.getLogger(this);
            logger.debug(": execute");

            mediatorMap.mapView(RootView, RootViewMediator);
            mediatorMap.mapView(MainView, MainViewMediator);

            mediatorMap.mapView(LoginView, LoginViewMediator);

            mediatorMap.mapView(AccountListView, AccountListViewMediator);
            mediatorMap.mapView(AllTransactionsView, AllTransactionsViewMediator);
            mediatorMap.mapView(SingleTransactionView, SingleTransactionViewMediator);

            mediatorMap.mapView(WalletView, WalletViewMediator);
            mediatorMap.mapView(AddTransactionView, AddTransactionViewMediator);
            mediatorMap.mapView(EditTransactionView, EditTransactionViewMediator);

            mediatorMap.mapView(BudgetsView, BudgetsViewMediator);
            mediatorMap.mapView(ScheduleView, ScheduleViewMediator);

            mediatorMap.mapView(CategoriesView, CategoriesViewMediator);
            mediatorMap.mapView(CategoryAllTransactionsView, CategoryAllTransactionsMediator);

            mediatorMap.mapView(ChartsView, ChartsViewMediator);
            mediatorMap.mapView(SettingsView, SettingsViewMediator);

            nextStepSignal.dispatch();
        }
    }
}