/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view.mediators
{
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.signals.RequestSelectedTransactionSignal;
    import com.pauluz.bbapps.kontomierz.signals.StoreSelectedTransactionForEditSignal;
    import com.pauluz.bbapps.kontomierz.signals.offline.DeleteTransactionOfflineSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideSelectedTransactionSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.TransactionForEditSuccessfulStoreSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.view.SingleTransactionView;
    import com.useitbetter.uDash;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.SignalMediator;

    public class SingleTransactionViewMediator extends SignalMediator
    {
        /**
         * VIEW
         */
        [Inject]
        public var view:SingleTransactionView;

        /**
         * SIGNALTONS
         */
        [Inject]
        public var provideSelectedTransactionSignal:ProvideSelectedTransactionSignal;

        [Inject]
        public var transactionForEditSuccessfulStoreSignal:TransactionForEditSuccessfulStoreSignal;

        /**
         * SIGNAL -> COMMAND
         */
        [Inject]
        public var requestSelectedTransactionSignal:RequestSelectedTransactionSignal;

        [Inject]
        public var storeSelectedTransactionForEditSignal:StoreSelectedTransactionForEditSignal;

        [Inject]
        public var deleteTransactionOfflineSignal:DeleteTransactionOfflineSignal;

        /** variables **/
        private var logger:ILogger;
        private var selectedTransaction:TransactionVO;

        /** 
         * CONSTRUCTOR 
         */
        public function SingleTransactionViewMediator()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");

            uDash.recorder.saveMeta(uDash.metaevents.SECTION, "SingleTransactionView")
        }
        
        /** 
         * onRegister 
         * Override the invoked of the <code>IMediator</code> and allow you to place your own initialization. 
         */
        override public function onRegister():void
        {
            logger.debug(": onRegister");
            
            addToSignal(view.viewAddedSignal, onViewAdded);

            addToSignal(view.editTransaction, onEditTransaction);
            addToSignal(view.deleteTransaction, onDeleteTransaction);

            addToSignal(provideSelectedTransactionSignal, onDetailsData);
        }

        private function onViewAdded():void
        {
            logger.debug(": onViewAdded");

            requestSelectedTransactionSignal.dispatch();
        }

        private function onEditTransaction():void
        {
            logger.debug(": onEditTransaction");

            addOnceToSignal(transactionForEditSuccessfulStoreSignal, onTransactionForEditSuccessfulStore);

            storeSelectedTransactionForEditSignal.dispatch(selectedTransaction);
        }

        private function onDeleteTransaction(isWallet:Boolean):void
        {
            logger.debug(": onDeleteTransaction");

            deleteTransactionOfflineSignal.dispatch(selectedTransaction);
        }

        private function onDetailsData(transaction:TransactionVO):void
        {
            logger.debug(": onDetailsData");

            selectedTransaction = transaction;

            if (view)
            {
                view.showDetails(transaction);
            }
        }

        private function onTransactionForEditSuccessfulStore():void
        {
            logger.debug(": onTransactionForEditSuccessfulStore");

            if (view)
            {
                view.addEditView();
            }
        }
    }
}
