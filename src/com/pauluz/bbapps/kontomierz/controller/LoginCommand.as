/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller 
{
    import com.destroytoday.core.IPromise;
    import com.pauluz.bbapps.kontomierz.constants.ApplicationConstants;
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.model.vo.ErrorVO;
    import com.pauluz.bbapps.kontomierz.model.vo.UserVO;
    import com.pauluz.bbapps.kontomierz.services.IKontomierzService;
    import com.pauluz.bbapps.kontomierz.services.helpers.IResultParser;
    import com.pauluz.bbapps.kontomierz.signals.offline.SaveAPIKeySignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.LoginSuccessfulSignal;

    public final class LoginCommand extends BaseOnlineCommand
    {
        /** PARAMETERS **/
        [Inject]
        public var user:UserVO;

        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var kontomierzService:IKontomierzService;

        [Inject]
        public var parser:IResultParser;


        /** NOTIFICATION SIGNALS */
        [Inject]
        public var loginSuccessfulSignal:LoginSuccessfulSignal;

        [Inject]
        public var saveAPIKeySignal:SaveAPIKeySignal;

        /**
         * Method handle the logic for <code>LoginCommand</code>
         */        
        override public function execute():void    
        {
            if (model.isConnected)
            {
                if (user.email == ApplicationConstants.KONTOMIERZ_DEMO_EMAIL)
                {
                    model.demoMode = true;
                    model.apiKey = ApplicationConstants.KONTOMIERZ_DEMO_API_KEY;

                    loginSuccessfulSignal.dispatch();
                }
                else
                {
                    // save value for future
                    model.rememberMe = user.rememberMe;

                    var promise:IPromise = kontomierzService.login(user);
                    promise.addResultProcessor(parser.parseLoginRegisterResponse);
                    promise.completed.addOnce(onLoginComplete);
                    promise.failed.addOnce(onError);
                }
            }
            else
            {
                var error:ErrorVO = new ErrorVO("Wymagane połączenie z internetem. Proszę spróbować później.", true);
                errorSignal.dispatch(error);
            }
        }

        /*
         *  COMPLETE HANDLER
         */
        private function onLoginComplete(promise:IPromise):void
        {
            if (promise.result != "")
            {
                model.apiKey = promise.result;
            }

            if (model.rememberMe && !model.demoMode)
            {
                saveAPIKeySignal.dispatch(promise.result);
            }

            loginSuccessfulSignal.dispatch();
        }

        /*
         *  ERROR HANDLER
         */
        override protected function onError(promise:IPromise):void
        {
            var error:ErrorVO = new ErrorVO("Nieprawidłowy e-mail lub hasło.");
            errorSignal.dispatch(error)
        }
    }
}
