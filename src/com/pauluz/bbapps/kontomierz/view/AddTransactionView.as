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
    import qnx.fuse.ui.dialog.AlertDialog;
    import qnx.fuse.ui.dialog.ToastBase;
    import qnx.fuse.ui.events.ActionEvent;
    import qnx.fuse.ui.navigation.TitlePage;

    public class AddTransactionView extends TitlePage
    {
        private var logger:ILogger;

        public var form:AddEditTransactionForm;

        public var viewAddedSignal:Signal = new Signal();
        public var addTransactionSignal:Signal = new Signal(TransactionVO);

        public function AddTransactionView()
        {
            super();

            title = "Dodaj wydatek";

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override protected function onAdded():void
        {
            super.onAdded();

            logger.debug(": onAdded");

            titleBar.acceptAction = new Action("Dodaj");
            titleBar.acceptAction.enabled = false;
            titleBar.addEventListener(ActionEvent.ACTION_SELECTED, onAddExpenseAction);

            form = new AddEditTransactionForm();

            content = form.createForm();

            viewAddedSignal.dispatch();
        }

        public function addData(_withdrawalCategoriesData:Array, _depositCategoriesData:Array, _currenciesData:Array):void
        {
            titleBar.acceptAction.enabled = true;

            form.categoryBtn.enabled = true;
            form.currencyBtn.enabled = true;

            form.withdrawalCategoriesDP = _withdrawalCategoriesData;
            form.depositCategoriesDP = _depositCategoriesData;
            form.currenciesDP = _currenciesData;
        }

        private function onAddExpenseAction(event:ActionEvent):void
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

            addTransactionSignal.dispatch(newTransaction);
        }

        public function showAlertAndCleanUp():void
        {
            form.directionRadioGroup.setSelectedRadioButton(form.withdrawalRadio);
            form.amountTextInput.text = "";
            form.datePicker.setDate(new Date());
            form.descriptionTextInput.text = "";

            form.selectedCategory = null;
            form.selectedCurrency = null;

            var category:CategoryVO;
            for each (category in form.withdrawalCategoriesDP)
            {
                category.selected = false;
            }

            for each (category in form.depositCategoriesDP)
            {
                category.selected = false;
            }

            form.currencyBtn.label = ApplicationConstants.DEFAULT_CURRENCY_NAME + " (" + ApplicationConstants.DEFAULT_CURRENCY_FULL_NAME + ")";

            for each (var currency:CurrencyVO in form.currenciesDP)
            {
                currency.selected = (currency.name == ApplicationConstants.DEFAULT_CURRENCY_NAME);
            }

            var successDialog:ToastBase = new ToastBase();
            successDialog.message = "Pomyślnie dodano transakcję!";
            successDialog.show();
        }
    }
}
