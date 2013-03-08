/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.services.helpers
{
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.signals.configure.ConfigureRootViewSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import flash.events.Event;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.Actor;

    import qnx.net.NetworkManager;

    public class ConnectivityChecker extends Actor
    {
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var nextStepSignal:ConfigureRootViewSignal;

        private var logger:ILogger;

        public function ConnectivityChecker()
        {
            logger = LogUtil.getLogger(this);
            logger.debug(": execute");
        }

        public function checkConnectivity():void
        {
            NetworkManager.networkManager.addEventListener(Event.CHANGE, onNetInfoChangeHandler);

            checkNetwork();

            nextStepSignal.dispatch();
        }

        protected function onNetInfoChangeHandler(event:Event):void
        {
            checkNetwork();
        }

        private function checkNetwork():void
        {
            model.isConnected = NetworkManager.networkManager.isConnected();

            logger.debug(": network status - " + model.isConnected);
        }
    }
}
