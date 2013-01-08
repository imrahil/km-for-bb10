/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view.mediators
{
    import com.pauluz.bbapps.kontomierz.signals.GetAllAccountsSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllAccountsDataSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import mx.logging.ILogger;
    
    import com.pauluz.bbapps.kontomierz.view.AccountListView;
    import org.robotlegs.mvcs.Mediator;

    import qnx.ui.data.DataProvider;

    public class AccountListViewMediator extends Mediator
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

        /**
         * SIGNAL -> COMMAND
         */
        [Inject]
        public var getAllAccountSignal:GetAllAccountsSignal;

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

            getAllAccountSignal.dispatch();
            provideAllAccountsDataSignal.add(onAccountsData);
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
    }
}
