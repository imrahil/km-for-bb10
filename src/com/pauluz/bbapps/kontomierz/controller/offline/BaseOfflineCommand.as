/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller.offline
{
    import com.pauluz.bbapps.kontomierz.model.vo.ErrorVO;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ErrorSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import flash.errors.SQLError;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.SignalCommand;

    public class BaseOfflineCommand extends SignalCommand
    {
        [Inject]
        public var errorSignal:ErrorSignal;

        protected var logger:ILogger;

        public function BaseOfflineCommand()
        {
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        /**
         *  DATABASE ERROR HANDLER
         */
        protected function databaseErrorHandler(sqlError:SQLError):void
        {
            logger.debug("databaseError: " + sqlError.details);

            var error:ErrorVO = new ErrorVO(sqlError.details);
            errorSignal.dispatch(error);
        }
    }
}
