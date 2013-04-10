/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view.mediators
{
    import com.pauluz.bbapps.kontomierz.constants.ApplicationConstants;
    import com.pauluz.bbapps.kontomierz.model.vo.CategoryVO;
    import com.pauluz.bbapps.kontomierz.signals.StoreSelectedCategorySignal;
    import com.pauluz.bbapps.kontomierz.signals.offline.GetAllCategoriesOfflineSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllWithdrawalCategoriesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.SelectedCategorySuccessfulStoreSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.view.CategoriesView;
    import com.useitbetter.uDash;

    import mx.logging.ILogger;

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
        public var provideAllWithdrawalCategoriesSignal:ProvideAllWithdrawalCategoriesSignal;

        [Inject]
        public var selectedCategorySuccessfulStoreSignal:SelectedCategorySuccessfulStoreSignal;

        /**
         * SIGNAL -> COMMAND
         */
        [Inject]
        public var getAllCategoriesSignal:GetAllCategoriesOfflineSignal;

        [Inject]
        public var storeSelectedCategorySignal:StoreSelectedCategorySignal;

        /** variables **/
        private var logger:ILogger;
        private var filterFlag:String = ApplicationConstants.CATEGORIES_ALL;

        /** 
         * CONSTRUCTOR 
         */
        public function CategoriesViewMediator()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");

            uDash.recorder.saveMeta(uDash.metaevents.SECTION, "CategoriesView")
        }
        
        /** 
         * onRegister 
         * Override the invoked of the <code>IMediator</code> and allow you to place your own initialization. 
         */
        override public function onRegister():void
        {
            logger.debug(": onRegister");

            addToSignal(view.viewAddedSignal, onViewAdded);
            addToSignal(view.filterSignal, onFilter);
            addToSignal(view.storeSelectedCategory, onStoreSelectedCategory);

            addToSignal(provideAllWithdrawalCategoriesSignal, onCategoriesData);
            addToSignal(selectedCategorySuccessfulStoreSignal, onCategorySuccessfulStore);
        }

        private function onViewAdded():void
        {
            logger.debug(": onViewAdded");

            getAllCategoriesSignal.dispatch(filterFlag);
        }

        private function onFilter():void
        {
            filterFlag = (filterFlag == ApplicationConstants.CATEGORIES_ALL) ? ApplicationConstants.CATEGORIES_USED : ApplicationConstants.CATEGORIES_ALL;
            getAllCategoriesSignal.dispatch(filterFlag);
        }

        private function onStoreSelectedCategory(category:CategoryVO):void
        {
            logger.debug(": onStoreSelectedCategory");

            storeSelectedCategorySignal.dispatch(category);
        }

        private function onCategoriesData(data:SectionDataProvider):void
        {
            logger.debug(": onCategoriesData");

            if (view)
            {
                view.addData(data);
            }
        }

        private function onCategorySuccessfulStore(category:CategoryVO):void
        {
            logger.debug(": onCategorySuccessfulStore");

            if (view)
            {
                view.addCategoryTransactionsView(category.name);
            }
        }
    }
}
