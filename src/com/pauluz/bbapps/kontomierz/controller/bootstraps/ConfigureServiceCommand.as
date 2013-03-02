/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller.bootstraps
{
    import com.pauluz.bbapps.kontomierz.constants.ApplicationConstants;
    import com.pauluz.bbapps.kontomierz.services.*;
    import com.pauluz.bbapps.kontomierz.services.helpers.*;
    import com.pauluz.bbapps.kontomierz.signals.configure.ConfigureDatabaseSignal;
    import com.pauluz.bbapps.kontomierz.signals.configure.ConfigureModelSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.probertson.data.SQLRunner;

    import flash.filesystem.File;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.SignalCommand;

    public class ConfigureServiceCommand extends SignalCommand
    {
        [Inject]
        public var nextStepModelSignal:ConfigureModelSignal;

        [Inject]
        public var nextStepDatabaseSignal:ConfigureDatabaseSignal;

        override public function execute():void
        {
            var logger:ILogger = LogUtil.getLogger(this);
            logger.debug(": execute");

            injector.mapSingletonOf(IKontomierzService, KontomierzService);
            injector.mapSingletonOf(ISQLKontomierzService, SQLKontomierzService);

            injector.mapSingletonOf(IResultParser, KontomierzJSONResultParser);

            var dbFile:File = File.applicationStorageDirectory.resolvePath(ApplicationConstants.KONTOMIERZ_DB_FILE_NAME);
            var sqlRunner:SQLRunner = new SQLRunner(dbFile);

            injector.mapValue(SQLRunner, sqlRunner);

            if (dbFile.exists)
            {
                nextStepModelSignal.dispatch();
            }
            else
            {
                nextStepDatabaseSignal.dispatch();
            }
        }
    }
}
