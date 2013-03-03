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
    import com.pauluz.bbapps.kontomierz.services.ISQLKontomierzService;

    import org.robotlegs.mvcs.SignalCommand;

    public final class LogoutCommand extends SignalCommand
    {
        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var sqlService:ISQLKontomierzService;

        /**
         * Method handle the logic for <code>LogoutCommand</code>
         */        
        override public function execute():void    
        {
            sqlService.deleteUserAPIKey();
            sqlService.deleteCategories();
            sqlService.deleteCurrencies();

            model.apiKey = "";

            model.selectedAccount = null;
            model.accountsList = null;
            model.selectedTransaction = null;
            model.defaultWalletId = 0;
            model.walletTransactionsList = null;

            model.withdrawalCategoriesList = null;
            model.depositCategoriesList = null;

            model.selectedCategory = null;
        }
    }
}
