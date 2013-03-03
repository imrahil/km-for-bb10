/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller.offline
{
    import com.pauluz.bbapps.kontomierz.services.ISQLKontomierzService;

    import org.robotlegs.mvcs.SignalCommand;

    import qnx.ui.data.SectionDataProvider;

    public final class SaveCategoriesCommand extends SignalCommand 
    {
        /** PARAMETERS **/
        [Inject]
        public var categoriesList:SectionDataProvider;

        [Inject]
        public var direction:String;

        /** INJECTIONS **/
        [Inject]
        public var sqlService:ISQLKontomierzService;

        /**
         * Method handle the logic for <code>SaveCategoriesCommand</code>
         */        
        override public function execute():void    
        {
            sqlService.saveCategories(categoriesList, direction);
        }
    }
}
