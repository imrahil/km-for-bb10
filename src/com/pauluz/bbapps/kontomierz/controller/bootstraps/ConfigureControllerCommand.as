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
    import com.pauluz.bbapps.kontomierz.signals.configure.ConfigureSignaltonsSignal;
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

            signalCommandMap.mapSignalClass(SaveAPIKeySignal, SaveAPIKeyCommand);

            // accounts
            signalCommandMap.mapSignalClass(GetAllAccountsSignal, GetAllAccountsCommand);
            signalCommandMap.mapSignalClass(StoreSelectedAccountSignal, StoreSelectedAccountCommand);

            // transactions
            signalCommandMap.mapSignalClass(GetAllTransactionsSignal, GetAllTransactionsCommand);
            signalCommandMap.mapSignalClass(StoreSelectedTransactionSignal, StoreSelectedTransactionCommand);
            signalCommandMap.mapSignalClass(StoreSelectedTransactionForEditSignal, StoreSelectedTransactionForEditCommand);
            signalCommandMap.mapSignalClass(RequestSelectedTransactionSignal, ProvideSelectedTransactionCommand);

            signalCommandMap.mapSignalClass(AddTransactionSignal, AddTransactionCommand);
            signalCommandMap.mapSignalClass(UpdateTransactionSignal, UpdateTransactionCommand);
            signalCommandMap.mapSignalClass(DeleteTransactionSignal, DeleteTransactionCommand);

            // wallet
            signalCommandMap.mapSignalClass(GetAllWalletTransactionsSignal, GetAllWalletTransactionsCommand);
            signalCommandMap.mapSignalClass(StoreDefaultWalletIdSignal, StoreDefaultWalletIdCommand);

            signalCommandMap.mapSignalClass(DeleteWalletTransactionSignal, DeleteWalletTransactionCommand);
            signalCommandMap.mapSignalClass(RefreshWalletSignal, RefreshWalletCommand);

            // categories
            signalCommandMap.mapSignalClass(GetAllCategoriesSignal, GetAllCategoriesCommand);
            signalCommandMap.mapSignalClass(StoreSelectedCategorySignal, StoreSelectedCategoryCommand);
            signalCommandMap.mapSignalClass(GetAllCategoryTransactionsSignal, GetAllCategoryTransactionsCommand);

            // currencies
            signalCommandMap.mapSignalClass(GetAllCurrenciesSignal, GetAllCurrenciesCommand);

            nextStepSignal.dispatch();
        }
    }
}