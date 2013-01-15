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
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllCategoriesSignal;

    import org.robotlegs.mvcs.SignalCommand;

    public final class GetAllCategoriesCommand extends SignalCommand
    {
        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var kontomierzService:IKontomierzService;

        [Inject]
        public var provideAllCategoriesSignal:ProvideAllCategoriesSignal;

        /**
         * Method handle the logic for <code>GetAllCategoriesCommand</code>
         */        
        override public function execute():void    
        {
            if (model.categoriesList && model.categoriesList.length > 0)
            {
                provideAllCategoriesSignal.dispatch(model.categoriesList);
            }
            else
            {
                kontomierzService.getAllCategories();
            }
        }
    }
}
