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

    public final class SaveTransactionsCommand extends SignalCommand 
    {
        /** PARAMETERS **/
        [Inject]
        public var accountId:int;

        [Inject]
        public var isWallet:Boolean;

        [Inject]
        public var transactionsList:Array;

        /** INJECTIONS **/
        [Inject]
        public var sqlService:ISQLKontomierzService;

        /**
         * Method handle the logic for <code>SaveTransactionsCommand</code>
         */        
        override public function execute():void    
        {
            sqlService.saveAllTransactions(accountId, transactionsList, isWallet);
        }
    }
}
