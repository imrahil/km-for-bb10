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
    import com.pauluz.bbapps.kontomierz.signals.RequestSelectedTransactionSignal;
    import com.pauluz.bbapps.kontomierz.signals.offline.GetAllCategoriesOfflineSignal;
    import com.pauluz.bbapps.kontomierz.signals.offline.GetAllCurrenciesOfflineSignal;
    import com.pauluz.bbapps.kontomierz.signals.offline.UpdateTransactionOfflineSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllCurrenciesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllDepositCategoriesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllWithdrawalCategoriesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideSelectedTransactionSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.TransactionSuccessfullySavedSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.view.EditTransactionView;
    import com.useitbetter.uDash;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.SignalMediator;

    import qnx.ui.data.SectionDataProvider;

    public class EditTransactionViewMediator extends SignalMediator
    {
        /**
         * VIEW
         */
        [Inject]
        public var view:EditTransactionView;

        /**
         * SIGNALTONS
         */
        [Inject]
        public var provideSelectedTransactionSignal:ProvideSelectedTransactionSignal;

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
        public var requestSelectedTransactionSignal:RequestSelectedTransactionSignal;

        [Inject]
        public var getAllCategoriesSignal:GetAllCategoriesOfflineSignal;

        [Inject]
        public var getAllCurrenciesSignal:GetAllCurrenciesOfflineSignal;

        [Inject]
        public var updateTransactionOfflineSignal:UpdateTransactionOfflineSignal;

        /** variables **/
        private var logger:ILogger;

        private var selectedTransaction:TransactionVO;

        private var dataFlag:int = 0;

        private var withdrawalCategoriesDP:SectionDataProvider;
        private var depositCategoriesDP:SectionDataProvider;
        private var currenciesDP:Array = [];

        private static const DATA_FLAG_COUNT:int = 3;
        /** 
         * CONSTRUCTOR 
         */
        public function EditTransactionViewMediator()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");

            uDash.recorder.saveMeta(uDash.metaevents.SECTION, "EditTransactionView")
        }
        
        /** 
         * onRegister 
         * Override the invoked of the <code>IMediator</code> and allow you to place your own initialization. 
         */
        override public function onRegister():void
        {
            logger.debug(": onRegister");

            addToSignal(view.viewAddedSignal, onViewAdded);
            addToSignal(view.editTransactionSignal, onEditTransaction);

            addOnceToSignal(provideSelectedTransactionSignal, onTransactionDetailsData);

            addOnceToSignal(provideAllWithdrawalCategoriesSignal, onWithdrawalCategoriesData);
            addOnceToSignal(provideAllDepositCategoriesSignal, onDepositCategoriesData);
            addOnceToSignal(provideAllCurrenciesSignal, onCurrenciesData);

            addOnceToSignal(transactionSuccessfullySavedSignal, onSuccessfulSave);
        }

        private function onViewAdded():void
        {
            logger.debug(": onViewAdded");

            dataFlag = 0;

            requestSelectedTransactionSignal.dispatch();

            getAllCategoriesSignal.dispatch(ApplicationConstants.CATEGORIES_ALL);
            getAllCurrenciesSignal.dispatch();
        }

        private function onEditTransaction(transaction:TransactionVO):void
        {
            updateTransactionOfflineSignal.dispatch(transaction);
        }

        private function onTransactionDetailsData(transaction:TransactionVO):void
        {
            logger.debug(": onTransactionDetailsData");

            if (dataFlag == DATA_FLAG_COUNT)
            {
                view.addData(transaction, withdrawalCategoriesDP, depositCategoriesDP, currenciesDP);
            }
            else
            {
                selectedTransaction = transaction;
                dataFlag++;
            }
        }

        private function onWithdrawalCategoriesData(data:SectionDataProvider):void
        {
            logger.debug(": onWithdrawalCategoriesData");

            if (dataFlag == DATA_FLAG_COUNT)
            {
                view.addData(selectedTransaction, data, depositCategoriesDP, currenciesDP);
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

            if (dataFlag == DATA_FLAG_COUNT)
            {
                view.addData(selectedTransaction, withdrawalCategoriesDP, data, currenciesDP);
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

            if (dataFlag == DATA_FLAG_COUNT)
            {
                view.addData(selectedTransaction, withdrawalCategoriesDP, depositCategoriesDP, data);
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
