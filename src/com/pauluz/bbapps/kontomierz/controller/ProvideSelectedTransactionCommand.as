/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller 
{
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideSelectedTransactionSignal;

    import org.robotlegs.mvcs.SignalCommand;

    public final class ProvideSelectedTransactionCommand extends SignalCommand
    {
        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var provideSelectedTransactionSignal:ProvideSelectedTransactionSignal;

        /**
         * Method handle the logic for <code>ProvideSelectedTransactionCommand</code>
         */        
        override public function execute():void    
        {
            provideSelectedTransactionSignal.dispatch(model.selectedTransaction);
        }
    }
}
