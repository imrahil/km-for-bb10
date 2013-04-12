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
    import com.pauluz.bbapps.kontomierz.signals.GetAllCategoriesOnlineSignal;
    import com.pauluz.bbapps.kontomierz.signals.GetAllCurrenciesOnlineSignal;
    import com.pauluz.bbapps.kontomierz.signals.LogoutSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.view.SettingsView;
    import com.useitbetter.uDash;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.SignalMediator;

    public class SettingsViewMediator extends SignalMediator
    {
        /**
         * VIEW
         */
        [Inject]
        public var view:SettingsView;

        /**
         * SIGNAL -> COMMAND
         */
        [Inject]
        public var logoutSignal:LogoutSignal;

        [Inject]
        public var getAllCategoriesOnlineSignal:GetAllCategoriesOnlineSignal;

        [Inject]
        public var getAllCurrenciesOnlineSignal:GetAllCurrenciesOnlineSignal;

        /** variables **/
        private var logger:ILogger;

        /** 
         * CONSTRUCTOR 
         */
        public function SettingsViewMediator()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");

            uDash.recorder.saveMeta(uDash.metaevents.SECTION, "SettingsView")
        }
        
        /** 
         * onRegister 
         * Override the invoked of the <code>IMediator</code> and allow you to place your own initialization. 
         */
        override public function onRegister():void
        {
            logger.debug(": onRegister");

            addToSignal(view.refreshSignal, onRefresh);
            addToSignal(view.logoutSignal, onLogout);
        }

        private function onRefresh():void
        {
            getAllCategoriesOnlineSignal.dispatch(ApplicationConstants.TRANSACTION_DIRECTION_WITHDRAWAL);
            getAllCategoriesOnlineSignal.dispatch(ApplicationConstants.TRANSACTION_DIRECTION_DEPOSIT);

            getAllCurrenciesOnlineSignal.dispatch();
        }

        private function onLogout():void
        {
            logoutSignal.dispatch();
        }
    }
}
