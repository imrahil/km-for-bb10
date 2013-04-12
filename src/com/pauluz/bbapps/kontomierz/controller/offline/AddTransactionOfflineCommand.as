/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller.offline
{
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.services.ISQLKontomierzService;

    import org.robotlegs.mvcs.SignalCommand;

    public final class AddTransactionOfflineCommand extends SignalCommand
    {
        /** PARAMETERS **/
        [Inject]
        public var transaction:TransactionVO;

        /** INJECTIONS **/
        [Inject]
        public var sqlService:ISQLKontomierzService;

        /**
         * Method handle the logic for <code>AddTransactionOfflineCommand</code>
         */        
        override public function execute():void    
        {
            sqlService.createTransaction(transaction);
        }
    }
}
