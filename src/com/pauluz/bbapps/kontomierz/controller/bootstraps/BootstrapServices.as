/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller.bootstraps
{
    import com.pauluz.bbapps.kontomierz.services.IKontomierzService;
    import com.pauluz.bbapps.kontomierz.services.KontomierzService;

    import org.robotlegs.core.IInjector;

    public class BootstrapServices extends Object
    {
        public function BootstrapServices(injector:IInjector)
        {
            injector.mapSingletonOf(IKontomierzService, KontomierzService);
        }
    }
}
