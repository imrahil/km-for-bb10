/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view
{
    import com.pauluz.bbapps.kontomierz.constants.ApplicationConstants;
    import com.pauluz.bbapps.kontomierz.model.vo.CategoryVO;
    import com.pauluz.bbapps.kontomierz.model.vo.CurrencyVO;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.view.components.AddEditTransactionForm;

    import mx.logging.ILogger;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.core.Action;
    import qnx.fuse.ui.dialog.ToastBase;
    import qnx.fuse.ui.events.ActionEvent;
    import qnx.fuse.ui.navigation.TitlePage;
    import qnx.fuse.ui.progress.ActivityIndicator;
    import qnx.fuse.ui.skins.progress.ActivityIndicatorSkinMedium;
    import qnx.ui.data.IDataProvider;
    import qnx.ui.data.SectionDataProvider;

    public class EditTransactionView extends TitlePage
    {
        private var logger:ILogger;

        public var form:AddEditTransactionForm;
        public var progressActivity:ActivityIndicator;

        private var saveAction:Action;

        public var viewAddedSignal:Signal = new Signal();
        public var editTransactionSignal:Signal = new Signal(TransactionVO);

        public function EditTransactionView()
        {
            super();

            title = "Edytuj wydatek";

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override protected function onAdded():void
        {
            super.onAdded();

            logger.debug(": onAdded");

            saveAction = new Action("Zapisz");

            titleBar.acceptAction = saveAction;
            titleBar.dismissAction = new Action("Anuluj");
            titleBar.addEventListener(ActionEvent.ACTION_SELECTED, onSaveAction);

            form = new AddEditTransactionForm();
            form.createDirection = false;

            content = form.createForm();

            viewAddedSignal.dispatch();
        }

        public function addData(transaction:TransactionVO, _withdrawalCategoriesData:SectionDataProvider, _depositCategoriesData:SectionDataProvider, _currenciesData:Array):void
        {
            titleBar.acceptAction.enabled = true;
            form.categoryBtn.enabled = true;
            form.currencyBtn.enabled = true;

            form.withdrawalCategoriesDP = _withdrawalCategoriesData;
            form.depositCategoriesDP = _depositCategoriesData;
            form.currenciesDP = _currenciesData;

            var tempDP:SectionDataProvider;
            if (transaction.currencyAmount > 0)
            {
                form.direction = ApplicationConstants.TRANSACTION_DIRECTION_DEPOSIT;
                form.directionLbl.text = "Przychód";

                tempDP = _depositCategoriesData;
            }
            else
            {
                form.direction = ApplicationConstants.TRANSACTION_DIRECTION_WITHDRAWAL;
                form.directionLbl.text = "Wydatek";

                tempDP = _withdrawalCategoriesData;
            }

            form.amountTextInput.text = transaction.currencyAmount.toString().replace("-", "");
            form.datePicker.setDateFromString(transaction.transactionOn);
            form.descriptionTextInput.text = transaction.description;
            form.categoryBtn.label = transaction.categoryName;
            form.currencyBtn.label = transaction.currencyName;

            // przeszukujemy liste kategorii po categoryId i zaznaczamy wybrana dla transakcji
            for each (var category:CategoryVO in tempDP.data)
            {
                var subTempDP:IDataProvider = tempDP.getChildrenForItem(category);
                for each (var subCategory:CategoryVO in subTempDP.data)
                {
                    if (subCategory.id == transaction.categoryId)
                    {
                        form.selectedCategory = subCategory;
                        break;
                    }
                }
            }

            form.selectedCurrency = new CurrencyVO();
            form.selectedCurrency.name = transaction.currencyName;
        }

        private function onSaveAction(event:ActionEvent):void
        {
            if (event.action == saveAction)
            {
                var errorDialog:ToastBase = new ToastBase();

                if (form.amountTextInput.text == "")
                {
                    errorDialog.message = "Proszę podać kwotę transakcji!";
                    errorDialog.show();

                    return;
                }

                if (form.descriptionTextInput.text == "")
                {
                    errorDialog.message = "Proszę podać opis transakcji!";
                    errorDialog.show();

                    return;
                }

                if (form.categoryBtn.label == ApplicationConstants.NO_CATEGORY_LABEL)
                {
                    errorDialog.message = "Proszę wybrać kategorię!";
                    errorDialog.show();

                    return;
                }

                progressActivity = new ActivityIndicator();
                progressActivity.animate(true);
                progressActivity.setPosition(this.stage.stageWidth - 150, 130);
                progressActivity.setSkin(ActivityIndicatorSkinMedium);
                this.addChild(progressActivity);

                var newTransaction:TransactionVO = form.provideTransactionData();
                editTransactionSignal.dispatch(newTransaction);
            }
            else
            {
                form.removeListeners();
                popAndDeletePage();
            }
        }

        public function showAlertAndCleanUp():void
        {
            if (progressActivity && this.contains(progressActivity))
            {
                this.removeChild(progressActivity);
            }

            var successDialog:ToastBase = new ToastBase();
            successDialog.title = "Sukces";
            successDialog.message = "Pomyślnie zaktualizowano transakcję!";
            successDialog.show();

            popAndDeletePage();
        }
    }
}
