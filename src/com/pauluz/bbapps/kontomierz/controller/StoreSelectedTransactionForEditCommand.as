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
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.TransactionForEditSuccessfulStoreSignal;

    import org.robotlegs.mvcs.SignalCommand;

    public final class StoreSelectedTransactionForEditCommand extends SignalCommand 
    {
        [Inject]
        public var transaction:TransactionVO;

        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var transactionForEditSuccessfulStoreSignal:TransactionForEditSuccessfulStoreSignal;

        /**
         * Method handle the logic for <code>StoreSelectedTransactionForEditCommand</code>
         */        
        override public function execute():void    
        {
            model.selectedTransaction = transaction;

            transactionForEditSuccessfulStoreSignal.dispatch();
        }
    }
}
