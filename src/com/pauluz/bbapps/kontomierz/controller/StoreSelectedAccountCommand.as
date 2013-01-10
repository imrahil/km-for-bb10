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
    import com.pauluz.bbapps.kontomierz.model.vo.AccountVO;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.SelectedAccountSuccessfulStoreSignal;

    import org.robotlegs.mvcs.SignalCommand;

    public final class StoreSelectedAccountCommand extends SignalCommand
    {
        /** PARAMETERS **/
        [Inject]
        public var account:AccountVO;

        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var selectedAccountSuccessfulStoreSignal:SelectedAccountSuccessfulStoreSignal;

        /**
         * Method handle the logic for <code>StoreSelectedAccountCommand</code>
         */        
        override public function execute():void    
        {
            model.selectedAccount = account;

            selectedAccountSuccessfulStoreSignal.dispatch(account);
        }
    }
}
