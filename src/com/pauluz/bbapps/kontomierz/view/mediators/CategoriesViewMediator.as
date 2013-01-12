/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view.mediators
{
    import com.pauluz.bbapps.kontomierz.model.vo.CategoryVO;
    import com.pauluz.bbapps.kontomierz.signals.GetAllCategoriesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllCategoriesSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import mx.logging.ILogger;
    
    import com.pauluz.bbapps.kontomierz.view.CategoriesView;
    import org.robotlegs.mvcs.SignalMediator;

    import qnx.ui.data.SectionDataProvider;

    public class CategoriesViewMediator extends SignalMediator
    {
        /**
         * VIEW
         */
        [Inject]
        public var view:CategoriesView;

        /**
         * SIGNALTONS
         */
        [Inject]
        public var provideAllCategoriesSignal:ProvideAllCategoriesSignal;

        [Inject]
//        public var selectedCategorySuccessfulStoreSignal:SelectedCategorySuccessfulStoreSignal;

        /**
         * SIGNAL -> COMMAND
         */
        [Inject]
        public var getAllCategoriesSignal:GetAllCategoriesSignal;

        /** variables **/
        private var logger:ILogger;

        /** 
         * CONSTRUCTOR 
         */
        public function CategoriesViewMediator()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }
        
        /** 
         * onRegister 
         * Override the invoked of the <code>IMediator</code> and allow you to place your own initialization. 
         */
        override public function onRegister():void
        {
            logger.debug(": onRegister");

            addToSignal(view.viewAddedSignal, onViewAdded);
            addToSignal(view.storeSelectedCategory, onStoreSelectedCategory);

            addOnceToSignal(provideAllCategoriesSignal, onCategoriesData);
//            addToSignal(selectedCategorySuccessfulStoreSignal, onCategorySuccessfulStore);
        }

        private function onViewAdded():void
        {
            logger.debug(": onViewAdded");

            getAllCategoriesSignal.dispatch();
        }

        private function onStoreSelectedCategory(category:CategoryVO):void
        {
            logger.debug(": onStoreSelectedTransaction");

//            storeSelectedCategorySignal.dispatch(category);
        }

        private function onCategoriesData(data:SectionDataProvider):void
        {
            logger.debug(": onTransactionsData");

            if (view && view.categoriesList)
            {
                view.categoriesList.dataProvider = data;
            }
        }
    }
}
