/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller.bootstraps
{
    import com.pauluz.bbapps.kontomierz.services.helpers.DatabaseCreator;

    import org.robotlegs.mvcs.SignalCommand;

    public class ConfigureDatabaseCommand extends SignalCommand
    {
        override public function execute():void
        {
            var creator:DatabaseCreator = injector.instantiate(DatabaseCreator);
            creator.createDatabaseStructure();
        }
    }
}
