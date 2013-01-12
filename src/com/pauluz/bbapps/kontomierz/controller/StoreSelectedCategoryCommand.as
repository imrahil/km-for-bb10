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
    import com.pauluz.bbapps.kontomierz.model.vo.CategoryVO;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.SelectedCategorySuccessfulStoreSignal;

    import org.robotlegs.mvcs.SignalCommand;

    public final class StoreSelectedCategoryCommand extends SignalCommand 
    {
        /** PARAMETERS **/
        [Inject]
        public var category:CategoryVO;

        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var selectedCategorySuccessfulStoreSignal:SelectedCategorySuccessfulStoreSignal;

        /**
         * Method handle the logic for <code>StoreSelectedCategoryCommand</code>
         */        
        override public function execute():void    
        {
            model.selectedCategory = category;

            selectedCategorySuccessfulStoreSignal.dispatch(category);
        }
    }
}
