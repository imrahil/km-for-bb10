/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller.bootstraps
{
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideLoginStatusSignal;

    import org.robotlegs.core.IInjector;

    public class BootstrapSignaltons
    {
        public function BootstrapSignaltons(injector:IInjector)
        {
            injector.mapSingleton(ProvideLoginStatusSignal);
        }
    }
}