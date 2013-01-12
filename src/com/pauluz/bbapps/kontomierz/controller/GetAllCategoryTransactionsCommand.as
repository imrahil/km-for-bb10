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

    public final class GetAllCategoryTransactionsCommand extends SignalCommand 
    {
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var kontomierzService:IKontomierzService;

        /**
         * Method handle the logic for <code>GetAllCategoryTransactionsCommand</code>
         */        
        override public function execute():void    
        {
            kontomierzService.getAllTransactionsForCategory(model.selectedCategory.id, model.apiKey);
        }
    }
}
