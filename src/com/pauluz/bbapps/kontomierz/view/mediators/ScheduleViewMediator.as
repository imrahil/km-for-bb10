/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view.mediators
{
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.view.ScheduleView;
    import com.useitbetter.uDash;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.SignalMediator;

    public class ScheduleViewMediator extends SignalMediator
    {
        /**
         * VIEW
         */
        [Inject]
        public var view:ScheduleView;

        /**
         * SIGNALTONS
         */


        /**
         * SIGNAL -> COMMAND
         */

        /** variables **/
        private var logger:ILogger;

        /**
         * CONSTRUCTOR
         */
        public function ScheduleViewMediator()
        {
            super();

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");

            uDash.recorder.saveMeta(uDash.metaevents.SECTION, "ScheduleView")
        }

        /**
         * onRegister
         * Override the invoked of the <code>IMediator</code> and allow you to place your own initialization.
         */
        override public function onRegister():void
        {
            logger.debug(": onRegister");

        }

        /** methods **/

        /** eventHandlers **/

    }
}
