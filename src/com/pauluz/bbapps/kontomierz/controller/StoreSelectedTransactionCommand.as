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
    import com.pauluz.bbapps.kontomierz.signals.signaltons.SelectedTransactionSuccessfulStoreSignal;

    import org.robotlegs.mvcs.SignalCommand;

    public final class StoreSelectedTransactionCommand extends SignalCommand
    {
        /** PARAMETERS **/
        [Inject]
        public var transaction:TransactionVO;

        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var selectedTransactionSuccessfulStoreSignal:SelectedTransactionSuccessfulStoreSignal;

        /**
         * Method handle the logic for <code>StoreSelectedTransactionCommand</code>
         */
        override public function execute():void
        {
            model.selectedTransaction = transaction;

            selectedTransactionSuccessfulStoreSignal.dispatch();
        }
    }
}
