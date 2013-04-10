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
    import com.pauluz.bbapps.kontomierz.signals.offline.GetAllCategoriesOfflineSignal;
    import com.pauluz.bbapps.kontomierz.signals.offline.GetAllCurrenciesOfflineSignal;
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

        /**
         * SIGNAL -> COMMAND
         */
        [Inject]
        public var getAllCategoriesSignal:GetAllCategoriesOfflineSignal;

        [Inject]
        public var getAllCurrenciesSignal:GetAllCurrenciesOfflineSignal;

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

            getAllCategoriesSignal.dispatch(ApplicationConstants.CATEGORIES_ALL);
            getAllCurrenciesSignal.dispatch();
        }
    }
}
