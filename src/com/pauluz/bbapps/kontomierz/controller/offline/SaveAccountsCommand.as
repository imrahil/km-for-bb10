/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller.offline
{
    import com.pauluz.bbapps.kontomierz.services.ISQLKontomierzService;

    import org.robotlegs.mvcs.SignalCommand;

    public final class SaveAccountsCommand extends SignalCommand 
    {
        /** PARAMETERS **/
        [Inject]
        public var accountsList:Array;

        /** INJECTIONS **/
        [Inject]
        public var sqlService:ISQLKontomierzService;

        /**
         * Method handle the logic for <code>SaveAccountsCommand</code>
         */        
        override public function execute():void    
        {
            sqlService.saveAllAccounts(accountsList);
        }
    }
}
