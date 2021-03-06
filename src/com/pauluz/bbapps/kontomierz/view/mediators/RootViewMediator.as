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
    import com.pauluz.bbapps.kontomierz.model.vo.ErrorVO;
    import com.pauluz.bbapps.kontomierz.model.vo.UserVO;
    import com.pauluz.bbapps.kontomierz.signals.LoginSignal;
    import com.pauluz.bbapps.kontomierz.signals.LogoutSignal;
    import com.pauluz.bbapps.kontomierz.signals.RegisterSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ErrorSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.InfoSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.LoginSuccessfulSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideLoginStatusSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.view.RootView;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.SignalMediator;

    public class RootViewMediator extends SignalMediator
    {
        /**
         * VIEW
         */
        [Inject]
        public var view:RootView;

        /**
         * SIGNALTONS
         */
        [Inject]
        public var provideLoginStatusSignal:ProvideLoginStatusSignal;

        [Inject]
        public var errorSignal:ErrorSignal;

        [Inject]
        public var infoSignal:InfoSignal;

        [Inject]
        public var logoutSignal:LogoutSignal;

        /**
         * SIGNAL -> COMMAND
         */
        [Inject]
        public var loginSignal:LoginSignal;

        [Inject]
        public var registerSignal:RegisterSignal;

        [Inject]
        public var loginSuccessfulSignal:LoginSuccessfulSignal;

        /** variables **/
        private var logger:ILogger;

        /** 
         * CONSTRUCTOR 
         */
        public function RootViewMediator()
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

            addToSignal(provideLoginStatusSignal, startupLoginStatus);
            addToSignal(loginSignal, onLoginSignal);
            addToSignal(errorSignal, onErrorSignal);
            addToSignal(infoSignal, onInfoSignal);
            addToSignal(loginSuccessfulSignal, onLoginSuccessfulSignal);
            addToSignal(logoutSignal, onLogout);
        }

        /** methods **/
        private function startupLoginStatus(status:String):void
        {
            logger.debug(": startupLoginStatus - " + status);

            if (status == ApplicationConstants.LOGIN_STATUS_NEW)
            {
                view.addLoginView();
            }
            else
            {
                view.addMainView();
            }
        }

        private function onLoginSignal(user:UserVO):void
        {
            logger.debug(": onLoginSignal");

             view.addSpinnerView();
        }

        private function onErrorSignal(error:ErrorVO):void
        {
            logger.debug(": onErrorSignal");

            view.showError(error.message, error.popScreen);
        }

        private function onInfoSignal(info:ErrorVO):void
        {
            logger.debug(": onInfoSignal");

            view.showInfo(info.message);
        }

        private function onLoginSuccessfulSignal():void
        {
            logger.debug(": onLoginSuccessfulSignal");

            view.addMainView();
        }

        private function onLogout():void
        {
            logger.debug(": onLogout");

            view.removeAllPages();
        }

        // view signals

//        private function onViewRegisterSignal(user:UserVO):void
//        {
//            logger.debug(": onViewRegisterSignal");
//
//            registerSignal.dispatch(user);
//
//            view.addSpinnerView();
//        }
    }
}
