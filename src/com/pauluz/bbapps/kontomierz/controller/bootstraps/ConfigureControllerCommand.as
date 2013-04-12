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
    import com.pauluz.bbapps.kontomierz.controller.offline.*;
    import com.pauluz.bbapps.kontomierz.signals.*;
    import com.pauluz.bbapps.kontomierz.signals.configure.ConfigureSignaltonsSignal;
    import com.pauluz.bbapps.kontomierz.signals.offline.*;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.SignalCommand;

    public class ConfigureControllerCommand extends SignalCommand
    {
        [Inject]
        public var nextStepSignal:ConfigureSignaltonsSignal;

        override public function execute():void
        {
            var logger:ILogger = LogUtil.getLogger(this);
            logger.debug(": execute");

            // login, logout, register
            signalCommandMap.mapSignalClass(RequestLoginStatusSignal, ProvideLoginStatusCommand);
            signalCommandMap.mapSignalClass(LoginSignal, LoginCommand);
            signalCommandMap.mapSignalClass(RegisterSignal, RegisterCommand);
            signalCommandMap.mapSignalClass(LogoutSignal, LogoutCommand);

            // accounts
            signalCommandMap.mapSignalClass(GetAllAccountsSignal, ProvideAllAccountsCommand);
            signalCommandMap.mapSignalClass(GetAllAccountsOnlineSignal, GetAllAccountsOnlineCommand);
            signalCommandMap.mapSignalClass(GetAllAccountsOfflineSignal, GetAllAccountsOfflineCommand);

            signalCommandMap.mapSignalClass(StoreSelectedAccountSignal, StoreSelectedAccountCommand);

            // transactions
            signalCommandMap.mapSignalClass(GetAllTransactionsOfflineSignal, GetAllTransactionsOfflineCommand);
            signalCommandMap.mapSignalClass(GetAllTransactionsOnlineSignal, GetAllTransactionsOnlineCommand);
            signalCommandMap.mapSignalClass(GetAllWalletTransactionsOfflineSignal, GetAllWalletTransactionsOfflineCommand);
            signalCommandMap.mapSignalClass(GetAllWalletTransactionsOnlineSignal, GetAllWalletTransactionsOnlineCommand);

            signalCommandMap.mapSignalClass(StoreSelectedTransactionSignal, StoreSelectedTransactionCommand);
            signalCommandMap.mapSignalClass(StoreSelectedTransactionForEditSignal, StoreSelectedTransactionForEditCommand);
            signalCommandMap.mapSignalClass(RequestSelectedTransactionSignal, ProvideSelectedTransactionCommand);

            signalCommandMap.mapSignalClass(AddTransactionOfflineSignal, AddTransactionOfflineCommand);
            signalCommandMap.mapSignalClass(AddTransactionOnlineSignal, AddTransactionOnlineCommand);

            signalCommandMap.mapSignalClass(UpdateTransactionOfflineSignal, UpdateTransactionOfflineCommand);
            signalCommandMap.mapSignalClass(UpdateTransactionOnlineSignal, UpdateTransactionOnlineCommand);

            signalCommandMap.mapSignalClass(DeleteTransactionOfflineSignal, DeleteTransactionOfflineCommand);
            signalCommandMap.mapSignalClass(DeleteTransactionOnlineSignal, DeleteTransactionOnlineCommand);

            // wallet
            signalCommandMap.mapSignalClass(StoreDefaultWalletSignal, StoreDefaultWalletCommand);

            signalCommandMap.mapSignalClass(RefreshWalletSignal, RefreshWalletCommand);

            // categories
            signalCommandMap.mapSignalClass(GetAllCategoriesOfflineSignal, GetAllCategoriesOfflineCommand);
            signalCommandMap.mapSignalClass(GetAllCategoriesOnlineSignal, GetAllCategoriesOnlineCommand);
            signalCommandMap.mapSignalClass(StoreSelectedCategorySignal, StoreSelectedCategoryCommand);
            signalCommandMap.mapSignalClass(GetAllCategoryTransactionsSignal, GetAllCategoryTransactionsCommand);

            // currencies
            signalCommandMap.mapSignalClass(GetAllCurrenciesOfflineSignal, GetAllCurrenciesOfflineCommand);
            signalCommandMap.mapSignalClass(GetAllCurrenciesOnlineSignal, GetAllCurrenciesOnlineCommand);


            // OFFLINE
            signalCommandMap.mapSignalClass(SaveAPIKeySignal, SaveAPIKeyCommand);
            signalCommandMap.mapSignalClass(SaveAccountsSignal, SaveAccountsCommand);
            signalCommandMap.mapSignalClass(SaveTransactionsSignal, SaveTransactionsCommand);
            signalCommandMap.mapSignalClass(SaveCategoriesSignal, SaveCategoriesOfflineCommand);
            signalCommandMap.mapSignalClass(SaveCurrenciesSignal, SaveCurrenciesOfflineCommand);

            signalCommandMap.mapSignalClass(CheckSyncStatusSignal, CheckSyncStatusCommand);
            signalCommandMap.mapSignalClass(SyncOfflineChangesSignal, SyncOfflineChangesCommand);

            signalCommandMap.mapSignalClass(SyncAddTransactionSignal, SyncAddTransactionCommand);
            signalCommandMap.mapSignalClass(SyncUpdateTransactionSignal, SyncUpdateTransactionCommand);
            signalCommandMap.mapSignalClass(SyncDeleteTransactionSignal, SyncDeleteTransactionCommand);

            nextStepSignal.dispatch();
        }
    }
}