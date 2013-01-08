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
    import com.pauluz.bbapps.kontomierz.services.IKontomierzService;

    import org.robotlegs.mvcs.SignalCommand;

    public final class GetAllAccountsCommand extends SignalCommand 
    {
        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var kontomierzService:IKontomierzService;

        /**
         * Method handle the logic for <code>GetAllAccountsCommand</code>
         */        
        override public function execute():void    
        {
            kontomierzService.getAllAccounts(model.apiKey);

            // DEMO USER API KEY
//            kontomierzService.getAllAccounts("e7cOI9zZTbprBddSHHnlniLsAvzBpfhqTIjeUid2be0fjb2REaWnudZqGSgxz1Lz");
        }
    }
}
