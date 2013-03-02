/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller.bootstraps
{
    import com.pauluz.bbapps.kontomierz.signals.RequestLoginStatusSignal;
    import com.pauluz.bbapps.kontomierz.view.RootView;

    import org.robotlegs.mvcs.SignalCommand;

    public class ConfigureMainViewCommand extends SignalCommand
    {
        [Inject]
        public var nextStepSignal:RequestLoginStatusSignal;

        override public function execute():void
        {
            var rootView:RootView = new RootView();
            contextView.addChild(rootView);

            nextStepSignal.dispatch();
        }
    }
}
