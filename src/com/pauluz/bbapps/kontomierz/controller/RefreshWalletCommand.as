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
    import com.pauluz.bbapps.kontomierz.signals.GetAllWalletTransactionsSignal;

    import org.robotlegs.mvcs.SignalCommand;

    public final class RefreshWalletCommand extends SignalCommand 
    {
        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var getAllWalletTransactionsSignal:GetAllWalletTransactionsSignal;

        /**
         * Method handle the logic for <code>RefreshWalletCommand</code>
         */        
        override public function execute():void    
        {
            model.isWalletListExpired = true;

            getAllWalletTransactionsSignal.dispatch();
        }
    }
}
