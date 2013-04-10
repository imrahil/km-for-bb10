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
    import com.pauluz.bbapps.kontomierz.signals.DeleteTransactionOnlineSignal;
    import com.pauluz.bbapps.kontomierz.signals.StoreSelectedTransactionForEditSignal;
    import com.pauluz.bbapps.kontomierz.signals.StoreSelectedTransactionSignal;
    import com.pauluz.bbapps.kontomierz.signals.offline.DeleteTransactionOfflineSignal;
    import com.pauluz.bbapps.kontomierz.signals.offline.GetAllTransactionsOfflineSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllTransactionsSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.SelectedTransactionSuccessfulStoreSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.TransactionForEditSuccessfulStoreSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.view.AllTransactionsView;
    import com.useitbetter.uDash;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.SignalMediator;

    import qnx.ui.data.DataProvider;

    public class AllTransactionsViewMediator extends SignalMediator
    {
        /**
         * VIEW
         */
        [Inject]
        public var view:AllTransactionsView;

        /**
         * SIGNALTONS
         */
        [Inject]
        public var provideAllTransactionsSignal:ProvideAllTransactionsSignal;

        [Inject]
        public var selectedTransactionSuccessfulStoreSignal:SelectedTransactionSuccessfulStoreSignal;

        [Inject]
        public var transactionForEditSuccessfulStoreSignal:TransactionForEditSuccessfulStoreSignal;

        /**
         * SIGNAL -> COMMAND
         */
        [Inject]
        public var getAllTransactionsOfflineSignal:GetAllTransactionsOfflineSignal;

        [Inject]
        public var storeSelectedTransactionSignal:StoreSelectedTransactionSignal;

        [Inject]
        public var storeSelectedTransactionForEditSignal:StoreSelectedTransactionForEditSignal;

        [Inject]
        public var deleteTransactionOfflineSignal:DeleteTransactionOfflineSignal;

        /** variables **/
        private var logger:ILogger;

        /** 
         * CONSTRUCTOR 
         */
        public function AllTransactionsViewMediator()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");

            uDash.recorder.saveMeta(uDash.metaevents.SECTION, "AllTransactionsView")
        }
        
        /** 
         * onRegister 
         * Override the invoked of the <code>IMediator</code> and allow you to place your own initialization. 
         */
        override public function onRegister():void
        {
            logger.debug(": onRegister");
            
            addToSignal(view.viewAddedSignal, onViewAdded);
            addToSignal(view.storeSelectedTransaction, onStoreSelectedTransaction);
            addToSignal(view.storeSelectedTransactionForEdit, onStoreSelectedTransactionForEdit);

            addToSignal(view.deleteTransaction, onDeleteTransaction);

            addToSignal(provideAllTransactionsSignal, onTransactionsData);
            addToSignal(selectedTransactionSuccessfulStoreSignal, onTransactionSuccessfulStore);
        }

        private function onViewAdded():void
        {
            logger.debug(": onViewAdded");

            getAllTransactionsOfflineSignal.dispatch();
        }

        private function onStoreSelectedTransaction(transaction:TransactionVO):void
        {
            logger.debug(": onStoreSelectedTransaction");

            storeSelectedTransactionSignal.dispatch(transaction);
        }

        private function onStoreSelectedTransactionForEdit(transaction:TransactionVO):void
        {
            logger.debug(": onStoreSelectedTransactionForEdit");

            addOnceToSignal(transactionForEditSuccessfulStoreSignal, onTransactionForEditSuccessfulStore);

            storeSelectedTransactionForEditSignal.dispatch(transaction);
        }

        private function onDeleteTransaction(transaction:TransactionVO):void
        {
            logger.debug(": onDeleteTransaction");

            deleteTransactionOfflineSignal.dispatch(transaction);
        }

        private function onTransactionsData(data:DataProvider):void
        {
            logger.debug(": onTransactionsData");

            if (view)
            {
                view.addData(data);
            }
        }

        private function onTransactionSuccessfulStore():void
        {
            logger.debug(": onTransactionSuccessfulStore");

            if (view)
            {
                view.addDetailView();
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
