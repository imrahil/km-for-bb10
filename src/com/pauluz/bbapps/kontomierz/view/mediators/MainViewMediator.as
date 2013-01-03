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
    import com.pauluz.bbapps.kontomierz.model.vo.UserVO;
    import com.pauluz.bbapps.kontomierz.signals.LoginSignal;
    import com.pauluz.bbapps.kontomierz.signals.RegisterSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideLoginStatusSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.view.MainView;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.SignalMediator;

    public class MainViewMediator extends SignalMediator
    {
        /**
         * VIEW
         */
        [Inject]
        public var view:MainView;

        /**
         * SIGNALTONS
         */
        [Inject]
        public var provideLoginStatusSignal:ProvideLoginStatusSignal;


        /**
         * SIGNAL -> COMMAND
         */
        [Inject]
        public var loginSignal:LoginSignal;

        [Inject]
        public var registerSignal:RegisterSignal;

        /** variables **/
        private var logger:ILogger;

        /** 
         * CONSTRUCTOR 
         */
        public function MainViewMediator()
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

            addToSignal(view.loginSignal, onViewLoginSignal);
            addToSignal(view.registerSignal, onViewRegisterSignal);
        }

        /** methods **/
        private function onLoginStatus(status:String):void
        {
            if (status == ApplicationConstants.LOGIN_STATUS_NEW)
            {
                view.addLoginDialog();
            }
            else
            {
//                view.addMainView();
            }
        }

        private function onViewLoginSignal(user:UserVO):void
        {
            logger.debug(": onViewLoginSignal");

            loginSignal.dispatch(user);
        }

        private function onViewRegisterSignal(user:UserVO):void
        {
            logger.debug(": onViewRegisterSignal");

            registerSignal.dispatch(user);
        }
    }
}
