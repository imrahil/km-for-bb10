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
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.model.vo.CategoryVO;
    import com.pauluz.bbapps.kontomierz.model.vo.ErrorVO;
    import com.pauluz.bbapps.kontomierz.services.IKontomierzService;
    import com.pauluz.bbapps.kontomierz.services.ISQLKontomierzService;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ErrorSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllDepositCategoriesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllWithdrawalCategoriesSignal;

    import org.robotlegs.mvcs.SignalCommand;

    public final class GetAllCategoriesCommand extends SignalCommand
    {
        /** PARAMETERS **/
        [Inject]
        public var filter:String;

        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var sqlService:ISQLKontomierzService;

        [Inject]
        public var provideAllWithdrawalCategoriesSignal:ProvideAllWithdrawalCategoriesSignal;

        [Inject]
        public var provideAllDepositCategoriesSignal:ProvideAllDepositCategoriesSignal;

        [Inject]
        public var errorSignal:ErrorSignal;

        /**
         * Method handle the logic for <code>GetAllCategoriesCommand</code>
         */        
        override public function execute():void    
        {
            if (filter == ApplicationConstants.CATEGORIES_ALL)
            {
                if (model.withdrawalCategoriesList && model.withdrawalCategoriesList.length > 0)
                {
                    provideAllWithdrawalCategoriesSignal.dispatch(model.withdrawalCategoriesList);
                }
                else
                {
                    sqlService.loadCategories(ApplicationConstants.TRANSACTION_DIRECTION_WITHDRAWAL);
                }

                if (model.depositCategoriesList && model.depositCategoriesList.length > 0)
                {
                    provideAllDepositCategoriesSignal.dispatch(model.depositCategoriesList);
                }
                else
                {
                    sqlService.loadCategories(ApplicationConstants.TRANSACTION_DIRECTION_DEPOSIT);
                }
            }
            else
            {
                var error:ErrorVO;

                if (!model.isConnected)
                {
                    error = new ErrorVO("Wymagane połączenie z internetem. Proszę spróbować później.", false);
                    errorSignal.dispatch(error);
                }
                else if (model.demoMode)
                {
                    error = new ErrorVO("Opcja dostępna tylko po zalogowaniu. Proszę spróbować później.", false);
                    errorSignal.dispatch(error);
                }
                else
                {
                    sqlService.loadUsedCategories();
                }
            }
        }
    }
}
