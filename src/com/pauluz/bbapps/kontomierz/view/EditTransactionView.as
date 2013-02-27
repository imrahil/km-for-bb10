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

    public class EditTransactionView extends TitlePage
    {
        private var logger:ILogger;

        public var form:AddEditTransactionForm;

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

            content = form.createForm();

            viewAddedSignal.dispatch();
        }

        public function addData(transaction:TransactionVO, _withdrawalCategoriesData:Array, _depositCategoriesData:Array, _currenciesData:Array):void
        {
            titleBar.acceptAction.enabled = true;
            form.categoryBtn.enabled = true;
            form.currencyBtn.enabled = true;

            form.withdrawalCategoriesDP = _withdrawalCategoriesData;
            form.depositCategoriesDP = _depositCategoriesData;
            form.currenciesDP = _currenciesData;

            if (transaction.currencyAmount > 0)
            {
                form.depositRadio.selected = true;
            }
            else
            {
                form.withdrawalRadio.selected = true;
            }

            form.amountTextInput.text = transaction.currencyAmount.toString().replace("-", "");
            form.datePicker.setDateFromString(transaction.transactionOn);
            form.descriptionTextInput.text = transaction.description;
            form.categoryBtn.label = transaction.categoryName;
            form.currencyBtn.label = transaction.currencyName;

            form.selectedCategory = new CategoryVO();
            form.selectedCategory.id = transaction.categoryId;

            form.selectedCurrency = new CurrencyVO();
            form.selectedCurrency.name = transaction.currencyName;
        }

        private function onSaveAction(event:ActionEvent):void
        {
            if (event.action == saveAction)
            {
                if (form.amountTextInput.text == "")
                {
                    form.expenseErrorLabel.text = "Proszę podać kwotę!";
                    return;
                }
                else
                {
                    form.expenseErrorLabel.text = "";
                }

                if (form.descriptionTextInput.text == "")
                {
                    form.descriptionErrorLabel.text = "Proszę podać opis!";
                    return;
                }
                else
                {
                    form.descriptionErrorLabel.text = "";
                }

                if (form.categoryBtn.label == ApplicationConstants.NO_CATEGORY_LABEL)
                {
                    form.categoryErrorLabel.text = "Proszę wybrać kategorię!";
                    return;
                }
                else
                {
                    form.categoryErrorLabel.text = "";
                }

                form.expenseErrorLabel.text = "";
                form.descriptionErrorLabel.text = "";

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
            var successDialog:ToastBase = new ToastBase();
            successDialog.title = "Sukces";
            successDialog.message = "Pomyślnie zaktualizowano transakcję!";
            successDialog.show();

            popAndDeletePage();
        }
    }
}
