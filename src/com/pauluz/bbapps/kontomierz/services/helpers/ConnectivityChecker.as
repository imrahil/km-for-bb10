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
    import com.pauluz.bbapps.kontomierz.signals.offline.SyncOfflineChangesSignal;
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

        [Inject]
        public var syncOfflineChangesSignal:SyncOfflineChangesSignal;

        private var logger:ILogger;

        public function ConnectivityChecker()
        {
            logger = LogUtil.getLogger(this);
            logger.debug(": execute");
        }

        public function checkConnectivity():void
        {
            NetworkManager.networkManager.addEventListener(Event.CHANGE, onNetInfoChangeHandler);

            checkNetwork(false);

            nextStepSignal.dispatch();
        }

        protected function onNetInfoChangeHandler(event:Event):void
        {
            checkNetwork();
        }

        private function checkNetwork(sync:Boolean = true):void
        {
            model.isConnected = NetworkManager.networkManager.isConnected();

            if (model.isConnected && sync)
            {
                syncOfflineChangesSignal.dispatch();
            }

            logger.debug(": network status - " + model.isConnected);
        }
    }
}
