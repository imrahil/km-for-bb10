/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller.bootstraps
{
    import com.pauluz.bbapps.kontomierz.view.*;
    import com.pauluz.bbapps.kontomierz.view.mediators.*;

    import org.robotlegs.core.IMediatorMap;

    public class BootstrapViewMediators extends Object
    {
        public function BootstrapViewMediators(mediatorMap:IMediatorMap)
        {
            mediatorMap.mapView(RootView, RootViewMediator);
            mediatorMap.mapView(MainView, MainViewMediator);

            mediatorMap.mapView(LoginView, LoginViewMediator);

            mediatorMap.mapView(AccountListView, AccountListViewMediator);
            mediatorMap.mapView(AllTransactionsView, AllTransactionsViewMediator);
            mediatorMap.mapView(SingleTransactionView, SingleTransactionViewMediator);

            mediatorMap.mapView(WalletView, WalletViewMediator);
            mediatorMap.mapView(AddTransactionView, AddTransactionViewMediator);

            mediatorMap.mapView(BudgetsView, BudgetsViewMediator);
            mediatorMap.mapView(ScheduleView, ScheduleViewMediator);

            mediatorMap.mapView(CategoriesView, CategoriesViewMediator);
            mediatorMap.mapView(CategoryAllTransactionsView, CategoryAllTransactionsMediator);

            mediatorMap.mapView(TagsView, TagsViewMediator);
            mediatorMap.mapView(ChartsView, ChartsViewMediator);
            mediatorMap.mapView(SettingsView, SettingsViewMediator);
        }
    }
}