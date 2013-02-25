/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller.bootstraps
{
    import com.pauluz.bbapps.kontomierz.controller.*;
    import com.pauluz.bbapps.kontomierz.signals.*;

    import org.robotlegs.core.ISignalCommandMap;

    public class BootstrapCommands
    {
        public function BootstrapCommands(commandMap:ISignalCommandMap)
        {
            // login, logout, register
            commandMap.mapSignalClass(RequestLoginStatusSignal, ProvideLoginStatusCommand);
            commandMap.mapSignalClass(LoginSignal, LoginCommand);
            commandMap.mapSignalClass(RegisterSignal, RegisterCommand);
            commandMap.mapSignalClass(LogoutSignal, LogoutCommand);

            // accounts
            commandMap.mapSignalClass(GetAllAccountsSignal, GetAllAccountsCommand);
            commandMap.mapSignalClass(StoreSelectedAccountSignal, StoreSelectedAccountCommand);

            // transactions
            commandMap.mapSignalClass(GetAllTransactionsSignal, GetAllTransactionsCommand);
            commandMap.mapSignalClass(StoreSelectedTransactionSignal, StoreSelectedTransactionCommand);
            commandMap.mapSignalClass(RequestSelectedTransactionSignal, ProvideSelectedTransactionCommand);

            commandMap.mapSignalClass(AddTransactionSignal, AddTransactionCommand);
            commandMap.mapSignalClass(DeleteTransactionSignal, DeleteTransactionCommand);

            // wallet
            commandMap.mapSignalClass(GetAllWalletTransactionsSignal, GetAllWalletTransactionsCommand);
            commandMap.mapSignalClass(StoreDefaultWalletIdSignal, StoreDefaultWalletIdCommand);

            commandMap.mapSignalClass(DeleteWalletTransactionSignal, DeleteWalletTransactionCommand);
            commandMap.mapSignalClass(RefreshWalletSignal, RefreshWalletCommand);

            // categories
            commandMap.mapSignalClass(GetAllCategoriesSignal, GetAllCategoriesCommand);
            commandMap.mapSignalClass(StoreSelectedCategorySignal, StoreSelectedCategoryCommand);
            commandMap.mapSignalClass(GetAllCategoryTransactionsSignal, GetAllCategoryTransactionsCommand);

            // currencies
            commandMap.mapSignalClass(GetAllCurrenciesSignal, GetAllCurrenciesCommand);
        }
    }
}