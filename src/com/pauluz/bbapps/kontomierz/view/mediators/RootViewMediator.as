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
    import com.pauluz.bbapps.kontomierz.signals.RegisterSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ErrorSignal;
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
        private var email:String;
        private var dialogType:String;

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

            addToSignal(provideLoginStatusSignal, onLoginStatus);
            addToSignal(errorSignal, onErrorSignal);
            addToSignal(loginSuccessfulSignal, onLoginSuccessfulSignal);

            addToSignal(view.loginSignal, onViewLoginSignal);
            addToSignal(view.registerSignal, onViewRegisterSignal);
            addToSignal(view.errorSignal, onViewErrorSignal);
        }

        /** methods **/
        private function onLoginStatus(status:String):void
        {
            logger.debug(": onLoginStatus");

            if (status == ApplicationConstants.LOGIN_STATUS_NEW)
            {
                view.addLoginDialog();
            }
            else
            {
                view.addMainView();
            }

//            var user:UserVO = new UserVO();
//            user.email = "kontomierz@imrahil.com";
//            user.password = "kontomierz";
//            user.rememberMe = false;
//
//            onViewLoginSignal(user);
        }

        private function onErrorSignal(error:ErrorVO):void
        {
            logger.debug(": onErrorSignal");

            email = error.email;
            dialogType = error.dialogType;
            view.showError(error.message);
        }

        private function onLoginSuccessfulSignal():void
        {
            logger.debug(": onLoginSuccessfulSignal");

            view.addMainView();
        }

        // view signals
        private function onViewLoginSignal(user:UserVO):void
        {
            logger.debug(": onViewLoginSignal");

            loginSignal.dispatch(user);

            view.addSpinner();
        }

        private function onViewRegisterSignal(user:UserVO):void
        {
            logger.debug(": onViewRegisterSignal");

            registerSignal.dispatch(user);

            view.addSpinner();
        }

        private function onViewErrorSignal():void
        {
            logger.debug(": onViewErrorSignal");

            switch (dialogType)
            {
                case ApplicationConstants.DIALOG_TYPE_LOGIN:
                    view.addLoginDialog(email)
                    break;
                case ApplicationConstants.DIALOG_TYPE_REGISTER:
                    view.addRegisterDialog(email)
                    break;
            }
        }
    }
}
