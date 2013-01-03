/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.services
{
    import com.pauluz.bbapps.kontomierz.constants.ApplicationConstants;
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.model.vo.ErrorVO;
    import com.pauluz.bbapps.kontomierz.model.vo.UserVO;
    import com.pauluz.bbapps.kontomierz.services.helpers.IResultParser;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ErrorSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.LoginSuccessfulSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.SharedObject;
    import flash.net.URLLoader;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.Actor;

    public class KontomierzServiceBase extends Actor implements IKontomierzService
    {
        protected var _parser:IResultParser;
        protected var logger:ILogger;

        protected var rememberMe:Boolean;
        protected var responseStatus:int;
        protected var email:String;
        protected var dialogType:String;

        /** MODEL **/
        [Inject]
        public var model:IKontomierzModel;

        /** INJECTS */
        [Inject]
        public function set parser(value:IResultParser):void
        {
            _parser = value;
        }

        /** NOTIFICATION SIGNALS */
        [Inject]
        public var loginSuccessfulSignal:LoginSuccessfulSignal;

        [Inject]
        public var errorSignal:ErrorSignal;

        /** Constructor */
        public function KontomierzServiceBase()
        {
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        public function login(user:UserVO):void
        {
            throw new Error("Override this method!");
        }

        public function register(user:UserVO):void
        {
            throw new Error("Override this method!");
        }

        protected function handleLoginComplete(event:Event):void
        {
            logger.debug(": handleLoginComplete");

            var loader:URLLoader = event.currentTarget as URLLoader;

            loader.removeEventListener(Event.COMPLETE, handleLoginComplete);
            removeLoaderListeners(loader);

            if (responseStatus == 200)
            {
                logger.debug(": handleLoginComplete - status: 200");

                var apiKey:String = _parser.parseLoginRegisterResponse(loader.data as String);

                if (apiKey != "")
                {
                    model.apiKey = apiKey;
                }

                if (rememberMe)
                {
                    var sessionSO:SharedObject = SharedObject.getLocal(ApplicationConstants.KONTOMIERZ_SO_NAME);
                    sessionSO.data.apiKey = apiKey;
                    sessionSO.flush();
                }

                loginSuccessfulSignal.dispatch();
            }
            else
            {
                logger.debug(": handleLoginComplete - status: 401");

                var error:ErrorVO = new ErrorVO("Nieprawidłowy e-mail lub hasło.", email, dialogType);
                errorSignal.dispatch(error);
            }
        }

        protected function addLoaderListeners(loader:URLLoader):void
        {
            loader.addEventListener(IOErrorEvent.IO_ERROR, handleError);
            loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onStatusEventHandler);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
        }

        protected function removeLoaderListeners(loader:URLLoader):void
        {
            loader.removeEventListener(IOErrorEvent.IO_ERROR, handleError);
            loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onStatusEventHandler);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
        }

        /**
         * Handler for errors
         * @param event
         */
        protected function handleError(event:ErrorEvent):void
        {
            logger.error(": handleError - " + event.text);

            removeLoaderListeners(event.currentTarget as URLLoader);

            var error:ErrorVO = new ErrorVO(event.text, email, dialogType);
            errorSignal.dispatch(error);
        }

        private function onStatusEventHandler(event:HTTPStatusEvent):void
        {
            logger.debug(": onStatusEventHandler - status: " + event.status);

            responseStatus = event.status;
        }
    }
}
