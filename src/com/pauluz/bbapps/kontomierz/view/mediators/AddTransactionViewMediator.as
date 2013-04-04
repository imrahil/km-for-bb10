/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view.mediators
{
    import com.pauluz.bbapps.kontomierz.constants.ApplicationConstants;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.signals.GetAllCategoriesSignal;
    import com.pauluz.bbapps.kontomierz.signals.GetAllCurrenciesSignal;
    import com.pauluz.bbapps.kontomierz.signals.offline.AddTransactionOfflineSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllCurrenciesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllDepositCategoriesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllWithdrawalCategoriesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.TransactionSuccessfullySavedSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.view.AddTransactionView;
    import com.useitbetter.uDash;

    import mx.logging.ILogger;

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
        public var provideAllWithdrawalCategoriesSignal:ProvideAllWithdrawalCategoriesSignal;

        [Inject]
        public var provideAllDepositCategoriesSignal:ProvideAllDepositCategoriesSignal;

        [Inject]
        public var provideAllCurrenciesSignal:ProvideAllCurrenciesSignal;

        [Inject]
        public var transactionSuccessfullySavedSignal:TransactionSuccessfullySavedSignal;

        /**
         * SIGNAL -> COMMAND
         */
        [Inject]
        public var getAllCategoriesSignal:GetAllCategoriesSignal;

        [Inject]
        public var getAllCurrenciesSignal:GetAllCurrenciesSignal;

        [Inject]
        public var addTransactionOfflineSignal:AddTransactionOfflineSignal;

        /** variables **/
        private var logger:ILogger;

        private var dataFlag:int = 0;

        private var withdrawalCategoriesDP:SectionDataProvider;
        private var depositCategoriesDP:SectionDataProvider;
        private var currenciesDP:Array = [];

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

            addOnceToSignal(provideAllWithdrawalCategoriesSignal, onWithdrawalCategoriesData);
            addOnceToSignal(provideAllDepositCategoriesSignal, onDepositCategoriesData);
            addOnceToSignal(provideAllCurrenciesSignal, onCurrenciesData);

            addToSignal(transactionSuccessfullySavedSignal, onSuccessfulSave);
        }

        private function onViewAdded():void
        {
            logger.debug(": onViewAdded");

            dataFlag = 0;

            getAllCategoriesSignal.dispatch(ApplicationConstants.CATEGORIES_ALL);
            getAllCurrenciesSignal.dispatch();
        }

        private function onAddTransaction(transaction:TransactionVO):void
        {
            logger.debug(":onAddTransactione");

            addTransactionOfflineSignal.dispatch(transaction);
        }

        private function onWithdrawalCategoriesData(data:SectionDataProvider):void
        {
            logger.debug(": onWithdrawalCategoriesData");

            if (dataFlag == 2)
            {
                view.addData(data, depositCategoriesDP, currenciesDP);
            }
            else
            {
                withdrawalCategoriesDP = data;
                dataFlag++;
            }
        }

        private function onDepositCategoriesData(data:SectionDataProvider):void
        {
            logger.debug(": onDepositCategoriesData");

            if (dataFlag == 2)
            {
                view.addData(withdrawalCategoriesDP, data, currenciesDP);
            }
            else
            {
                depositCategoriesDP = data;
                dataFlag++;
            }
        }

        private function onCurrenciesData(data:Array):void
        {
            logger.debug(": onCurrenciesData");

            if (dataFlag == 2)
            {
                view.addData(withdrawalCategoriesDP, depositCategoriesDP, data);
            }
            else
            {
                currenciesDP = data;
                dataFlag++;
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
