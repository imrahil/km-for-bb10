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
    import com.pauluz.bbapps.kontomierz.signals.GetAllTransactionsSignal;
    import com.pauluz.bbapps.kontomierz.signals.StoreSelectedTransactionSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllTransactionsSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.SelectedTransactionSuccessfulStoreSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.view.AllTransactionsView;

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

        /**
         * SIGNAL -> COMMAND
         */
        [Inject]
        public var getAllTransactionsSignal:GetAllTransactionsSignal;

        [Inject]
        public var storeSelectedTransactionSignal:StoreSelectedTransactionSignal;

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

            addOnceToSignal(provideAllTransactionsSignal, onTransactionsData);
            addToSignal(selectedTransactionSuccessfulStoreSignal, onTransactionSuccessfulStore);
        }

        private function onViewAdded():void
        {
            logger.debug(": onViewAdded");

            getAllTransactionsSignal.dispatch();
        }

        private function onStoreSelectedTransaction(transaction:TransactionVO):void
        {
            logger.debug(": onStoreSelectedTransaction");

            storeSelectedTransactionSignal.dispatch(transaction);
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
    }
}
