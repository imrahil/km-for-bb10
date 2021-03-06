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

    import org.robotlegs.mvcs.SignalCommand;

    public final class StoreDefaultWalletCommand extends SignalCommand
    {
        /** PARAMETERS **/
        [Inject]
        public var wallet:AccountVO;

        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        /**
         * Method handle the logic for <code>StoreDefaultWalletCommand</code>
         */        
        override public function execute():void    
        {
            model.defaultWallet = wallet;
        }
    }
}
