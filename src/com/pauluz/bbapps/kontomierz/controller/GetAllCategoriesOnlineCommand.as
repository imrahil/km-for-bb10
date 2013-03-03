/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller 
{
    import com.pauluz.bbapps.kontomierz.constants.ApplicationConstants;
    import com.pauluz.bbapps.kontomierz.services.IKontomierzService;

    import org.robotlegs.mvcs.SignalCommand;

    public final class GetAllCategoriesOnlineCommand extends SignalCommand 
    {
        /** PARAMETERS **/
        [Inject]
        public var direction:String;

        /** INJECTIONS **/
        [Inject]
        public var kontomierzService:IKontomierzService;

        /**
         * Method handle the logic for <code>GetAllCategoriesOnlineCommand</code>
         */        
        override public function execute():void    
        {
            if (direction == ApplicationConstants.TRANSACTION_DIRECTION_WITHDRAWAL)
            {
                kontomierzService.getAllWithdrawalCategories();
            }
            else
            {
                kontomierzService.getAllDepositCategories();
            }
        }
    }
}
