/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view.mediators
{
    import com.pauluz.bbapps.kontomierz.model.vo.AccountVO;
    import com.pauluz.bbapps.kontomierz.signals.GetAllAccountsSignal;
    import com.pauluz.bbapps.kontomierz.signals.SaveSelectedAccountSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllAccountsDataSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.SelectedAccountSavedSuccessfulSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.view.AccountListView;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.SignalMediator;

    import qnx.ui.data.DataProvider;

    public class AccountListViewMediator extends SignalMediator
    {
        /**
         * VIEW
         */
        [Inject]
        public var view:AccountListView;

        /**
         * SIGNALTONS
         */
         [Inject]
         public var provideAllAccountsDataSignal:ProvideAllAccountsDataSignal;

         [Inject]
         public var selectedAccountSavedSuccessfulSignal:SelectedAccountSavedSuccessfulSignal;

        /**
         * SIGNAL -> COMMAND
         */
        [Inject]
        public var getAllAccountSignal:GetAllAccountsSignal;

        [Inject]
        public var saveSelectedAccountSignal:SaveSelectedAccountSignal;

        /** variables **/
        private var logger:ILogger;

        /** 
         * CONSTRUCTOR 
         */
        public function AccountListViewMediator()
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
            addToSignal(view.saveSelectedAccount, onSaveSelectedAccount);

            provideAllAccountsDataSignal.add(onAccountsData);
            selectedAccountSavedSuccessfulSignal.add(onSuccessfulAccountSave);
        }

        private function onViewAdded():void
        {
            logger.debug(": onViewAdded");

            getAllAccountSignal.dispatch();
        }

        private function onSaveSelectedAccount(account:AccountVO):void
        {
            logger.debug(": onSaveSelectedAccount");

            saveSelectedAccountSignal.dispatch(account);
        }

        /** methods **/
        private function onAccountsData(data:DataProvider):void
        {
            logger.debug(": onAccountsData");

            if (view && view.accountList)
            {
                view.accountList.dataProvider = data;
            }
        }

        private function onSuccessfulAccountSave(account:AccountVO):void
        {
            logger.debug(": onSuccessfulAccountSave");

            if (view)
            {
                view.addTransactionView(account.displayName);
            }
        }
    }
}
