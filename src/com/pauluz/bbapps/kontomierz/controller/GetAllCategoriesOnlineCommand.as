/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller 
{
    import com.destroytoday.core.IPromise;
    import com.pauluz.bbapps.kontomierz.constants.ApplicationConstants;
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.model.vo.CategoryVO;
    import com.pauluz.bbapps.kontomierz.model.vo.ErrorVO;
    import com.pauluz.bbapps.kontomierz.services.IKontomierzService;
    import com.pauluz.bbapps.kontomierz.services.helpers.IResultParser;
    import com.pauluz.bbapps.kontomierz.signals.offline.SaveCategoriesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllDepositCategoriesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllWithdrawalCategoriesSignal;

    import qnx.ui.data.ISectionDataProvider;

    import qnx.ui.data.SectionDataProvider;

    public final class GetAllCategoriesOnlineCommand extends BaseOnlineCommand
    {
        /** PARAMETERS **/
        [Inject]
        public var direction:String;

        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var kontomierzService:IKontomierzService;

        [Inject]
        public var parser:IResultParser;


        /** NOTIFICATION SIGNALS */
        [Inject]
        public var provideAllWithdrawalCategoriesSignal:ProvideAllWithdrawalCategoriesSignal;

        [Inject]
        public var provideAllDepositCategoriesSignal:ProvideAllDepositCategoriesSignal;

        [Inject]
        public var saveCategoriesSignal:SaveCategoriesSignal;

        /**
         * Method handle the logic for <code>GetAllCategoriesOnlineCommand</code>
         */        
        override public function execute():void    
        {
            var promise:IPromise;

            if (direction == ApplicationConstants.TRANSACTION_DIRECTION_WITHDRAWAL)
            {
                promise = kontomierzService.getAllWithdrawalCategories();
            }
            else
            {
                promise = kontomierzService.getAllDepositCategories();
            }

            promise.addResultProcessor(parser.parseAllCategoriesResponse);
            promise.completed.addOnce(onGetAllCategories);
            promise.failed.addOnce(onError);
        }

        /*
         *  COMPLETE HANDLER
         */
        private function onGetAllCategories(promise:IPromise):void
        {
            var categoriesList:SectionDataProvider = promise.result as SectionDataProvider;

            if (direction == ApplicationConstants.TRANSACTION_DIRECTION_WITHDRAWAL)
            {
                model.withdrawalCategoriesList = categoriesList;
                provideAllWithdrawalCategoriesSignal.dispatch(categoriesList);

                saveCategoriesSignal.dispatch(categoriesList, ApplicationConstants.TRANSACTION_DIRECTION_WITHDRAWAL);
            }
            else
            {
                model.depositCategoriesList = categoriesList;
                provideAllDepositCategoriesSignal.dispatch(categoriesList);

                saveCategoriesSignal.dispatch(categoriesList, ApplicationConstants.TRANSACTION_DIRECTION_DEPOSIT);
            }
        }
    }
}
