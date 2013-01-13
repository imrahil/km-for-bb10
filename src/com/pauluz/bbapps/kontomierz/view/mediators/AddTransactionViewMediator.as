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
    import com.pauluz.bbapps.kontomierz.signals.AddTransactionSignal;
    import com.pauluz.bbapps.kontomierz.signals.GetAllCategoriesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllCategoriesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.TransactionSuccessfulySavedSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import mx.logging.ILogger;
    
    import com.pauluz.bbapps.kontomierz.view.AddTransactionView;
    import org.robotlegs.mvcs.SignalMediator;

    import qnx.ui.data.SectionDataProvider;

    public class AddTransactionViewMediator extends SignalMediator
    {
        /**
         * VIEW
         */
        [Inject]
        public var view:AddTransactionView;

        /**
         * SIGNALTONS
         */
        [Inject]
        public var provideAllCategoriesSignal:ProvideAllCategoriesSignal;

        [Inject]
        public var transactionSuccessfulySavedSignal:TransactionSuccessfulySavedSignal;

        /**
         * SIGNAL -> COMMAND
         */
        [Inject]
        public var getAllCategoriesSignal:GetAllCategoriesSignal;

        [Inject]
        public var addTransactionSignal:AddTransactionSignal;

        /** variables **/
        private var logger:ILogger;

        /** 
         * CONSTRUCTOR 
         */
        public function AddTransactionViewMediator()
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
            addToSignal(view.addTransactionSignal, onAddTransaction);

            addOnceToSignal(provideAllCategoriesSignal, onCategoriesData);
            addToSignal(transactionSuccessfulySavedSignal, onSuccessfulSave);
        }

        private function onViewAdded():void
        {
            logger.debug(": onViewAdded");

            getAllCategoriesSignal.dispatch();
        }

        private function onAddTransaction(transaction:TransactionVO):void
        {
            logger.debug(":onAddTransactione");

            addTransactionSignal.dispatch(transaction);
        }

        private function onCategoriesData(data:SectionDataProvider):void
        {
            logger.debug(": onCategoriesData");

            if (view)
            {
                view.addData(data);
            }
        }

        private function onSuccessfulSave():void
        {
            logger.debug(": onSuccessfulSave");

            if (view)
            {
                view.showAlertAndCleanUp();
            }
        }
    }
}
