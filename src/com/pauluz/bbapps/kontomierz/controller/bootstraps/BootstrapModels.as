/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller.bootstraps
{
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.model.KontomierzModel;

    import org.robotlegs.core.IInjector;

    public class BootstrapModels
    {
        public function BootstrapModels(injector:IInjector)
        {
            injector.mapSingletonOf(IKontomierzModel, KontomierzModel);
        }
    }
}