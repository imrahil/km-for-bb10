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
    import com.pauluz.bbapps.kontomierz.signals.signaltons.SelectedAccountSavedSuccessfulSignal;

    import org.robotlegs.mvcs.SignalCommand;

    public final class SaveSelectedAccountCommand extends SignalCommand 
    {
        /** PARAMETERS **/
        [Inject]
        public var account:AccountVO;

        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var selectedAccountSavedSuccessfulSignal:SelectedAccountSavedSuccessfulSignal;

        /**
         * Method handle the logic for <code>SaveSelectedAccountCommand</code>
         */        
        override public function execute():void    
        {
            model.selectedAccount = account;

            selectedAccountSavedSuccessfulSignal.dispatch(account);
        }
    }
}
