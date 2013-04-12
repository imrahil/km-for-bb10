/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller.offline
{
    import com.pauluz.bbapps.kontomierz.constants.ApplicationConstants;
    import com.pauluz.bbapps.kontomierz.constants.SQLStatements;
    import com.pauluz.bbapps.kontomierz.controller.offline.BaseOfflineCommand;
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.model.vo.CategoryVO;
    import com.pauluz.bbapps.kontomierz.model.vo.ErrorVO;
    import com.pauluz.bbapps.kontomierz.signals.GetAllCategoriesOnlineSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllDepositCategoriesSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideAllWithdrawalCategoriesSignal;
    import com.probertson.data.SQLRunner;

    import flash.data.SQLResult;
    import flash.utils.Dictionary;

    import qnx.ui.data.SectionDataProvider;

    public final class GetAllCategoriesOfflineCommand extends BaseOfflineCommand
    {
        /** PARAMETERS **/
        [Inject]
        public var filter:String;

        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var sqlRunner:SQLRunner;

        [Inject]
        public var provideAllWithdrawalCategoriesSignal:ProvideAllWithdrawalCategoriesSignal;

        [Inject]
        public var provideAllDepositCategoriesSignal:ProvideAllDepositCategoriesSignal;

        [Inject]
        public var getAllCategoriesOnlineSignal:GetAllCategoriesOnlineSignal;

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
                    sqlRunner.execute(SQLStatements.LOAD_CATEGORIES_SQL, {direction: ApplicationConstants.TRANSACTION_DIRECTION_WITHDRAWAL}, function(result:SQLResult):void { loadCategoriesResult(result, ApplicationConstants.TRANSACTION_DIRECTION_WITHDRAWAL)}, CategoryVO, databaseErrorHandler);
                }

                if (model.depositCategoriesList && model.depositCategoriesList.length > 0)
                {
                    provideAllDepositCategoriesSignal.dispatch(model.depositCategoriesList);
                }
                else
                {
                    sqlRunner.execute(SQLStatements.LOAD_CATEGORIES_SQL, {direction: ApplicationConstants.TRANSACTION_DIRECTION_DEPOSIT}, function(result:SQLResult):void { loadCategoriesResult(result, ApplicationConstants.TRANSACTION_DIRECTION_DEPOSIT)}, CategoryVO, databaseErrorHandler);
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
                    loadUsedCategories();
                }
            }
        }

        private function loadCategoriesResult(result:SQLResult, direction:String):void
        {
            logger.debug(": loadCategoriesResult");

            if (result.data != null && result.data.length > 0)
            {
                var tempDict:Dictionary = new Dictionary();
                var output:SectionDataProvider = new SectionDataProvider();

                for each (var category:CategoryVO in result.data)
                {
                    if (category.header)
                    {
                        output.addItem(category);

                        tempDict[category.categoryId] = category;
                    }
                    else
                    {
                        output.addChildToItem(category, tempDict[category.parentId]);
                    }
                }

                if (direction == ApplicationConstants.TRANSACTION_DIRECTION_WITHDRAWAL)
                {
                    model.withdrawalCategoriesList = output;
                    provideAllWithdrawalCategoriesSignal.dispatch(output);
                }
                else
                {
                    model.depositCategoriesList = output;
                    provideAllDepositCategoriesSignal.dispatch(output);
                }
            }
            else
            {
                getAllCategoriesOnlineSignal.dispatch(direction);
            }
        }

        private function loadUsedCategories():void
        {
            logger.debug(": loadCategories");

            sqlRunner.execute(SQLStatements.LOAD_USED_CATEGORIES_SQL, null, loadUsedCategoriesResult, CategoryVO, databaseErrorHandler);
        }

        private function loadUsedCategoriesResult(result:SQLResult):void
        {
            logger.debug(": loadUsedCategoriesResult");

            if (result.data != null && result.data.length > 0)
            {
                var output:SectionDataProvider = new SectionDataProvider();

                var mainCategory:CategoryVO = new CategoryVO();
                mainCategory.header = true;
                mainCategory.name = "Używane kategorie";
                output.addItem(mainCategory);

                for each (var category:CategoryVO in result.data)
                {
                    output.addChildToItem(category, mainCategory);
                }

                provideAllWithdrawalCategoriesSignal.dispatch(output);
            }
            else
            {
                var error:ErrorVO = new ErrorVO("Brak danych offline. Musisz przejrzeć przynajmniej jeden ze swoich rachunków.");
                errorSignal.dispatch(error);
            }
        }
    }
}
