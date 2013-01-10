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
            commandMap.mapSignalClass(RequestLoginStatusSignal, ProvideLoginStatusCommand);
            commandMap.mapSignalClass(LoginSignal, LoginCommand);
            commandMap.mapSignalClass(RegisterSignal, RegisterCommand);
            commandMap.mapSignalClass(LogoutSignal, LogoutCommand);

            commandMap.mapSignalClass(GetAllAccountsSignal, GetAllAccountsCommand);
            commandMap.mapSignalClass(SaveSelectedAccountSignal, SaveSelectedAccountCommand);
            commandMap.mapSignalClass(GetAllTransactionsSignal, GetAllTransactionsCommand);
        }
    }
}