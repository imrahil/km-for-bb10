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
    import com.pauluz.bbapps.kontomierz.signals.GetAllCurrenciesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllCategoriesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllCurrenciesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.TransactionSuccessfulySavedSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.useitbetter.uDash;

    import mx.logging.ILogger;
    
    import com.pauluz.bbapps.kontomierz.view.AddTransactionView;
    import org.robotlegs.mvcs.SignalMediator;

    import qnx.ui.data.DataProvider;

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
        public var provideAllCurrenciesSignal:ProvideAllCurrenciesSignal;

        [Inject]
        public var transactionSuccessfulySavedSignal:TransactionSuccessfulySavedSignal;

        /**
         * SIGNAL -> COMMAND
         */
        [Inject]
        public var getAllCategoriesSignal:GetAllCategoriesSignal;

        [Inject]
        public var getAllCurrenciesSignal:GetAllCurrenciesSignal;

        [Inject]
        public var addTransactionSignal:AddTransactionSignal;

        /** variables **/
        private var logger:ILogger;

        private var dataFlag:Boolean = false;

        private var categoriesDP:Array;
        private var currenciesDP:DataProvider;

        /**
         * CONSTRUCTOR 
         */
        public function AddTransactionViewMediator()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");

            uDash.recorder.saveMeta(uDash.metaevents.SECTION, "AddTransactionView")
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
            addOnceToSignal(provideAllCurrenciesSignal, onCurrenciesData);
            addToSignal(transactionSuccessfulySavedSignal, onSuccessfulSave);
        }

        private function onViewAdded():void
        {
            logger.debug(": onViewAdded");

            dataFlag = false;

            // TODO - wysylac sygnaly tylko jak brak danych?
            getAllCategoriesSignal.dispatch();
            getAllCurrenciesSignal.dispatch();
        }

        private function onAddTransaction(transaction:TransactionVO):void
        {
            logger.debug(":onAddTransactione");

            addTransactionSignal.dispatch(transaction);
        }

        private function onCategoriesData(data:Array):void
        {
            logger.debug(": onCategoriesData");

            if (dataFlag)
            {
                view.addData(data, currenciesDP);
            }
            else
            {
                categoriesDP = data;
                dataFlag = true;
            }
        }

        private function onCurrenciesData(data:DataProvider):void
        {
            logger.debug(": onCurrenciesData");

            if (dataFlag)
            {
                view.addData(categoriesDP, data);
            }
            else
            {
                currenciesDP = data;
                dataFlag = true;
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
