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
    import com.pauluz.bbapps.kontomierz.utils.ContainerHelper;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.utils.TextFormatUtil;
    import com.pauluz.bbapps.kontomierz.view.components.CustomListDialog;
    import com.pauluz.bbapps.kontomierz.view.components.DatePicker;

    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.logging.ILogger;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.buttons.LabelButton;
    import qnx.fuse.ui.buttons.RadioButton;
    import qnx.fuse.ui.buttons.RadioButtonGroup;
    import qnx.fuse.ui.core.Action;
    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.dialog.AlertDialog;
    import qnx.fuse.ui.dialog.ListDialog;
    import qnx.fuse.ui.events.ActionEvent;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.layouts.gridLayout.GridLayout;
    import qnx.fuse.ui.listClasses.ScrollDirection;
    import qnx.fuse.ui.navigation.TitlePage;
    import qnx.fuse.ui.skins.SkinStates;
    import qnx.fuse.ui.text.KeyboardType;
    import qnx.fuse.ui.text.Label;
    import qnx.fuse.ui.text.TextInput;
    import qnx.ui.data.DataProvider;

    public class AddTransactionView extends TitlePage
    {
        private var logger:ILogger;

        private var directionRadioGroup:RadioButtonGroup;
        private var withdrawalRadio:RadioButton;
        private var depositRadio:RadioButton;
        private var amountTextInput:TextInput;
        private var expenseErrorLabel:Label;
        private var datePicker:DatePicker;
        private var descriptionTextInput:TextInput;
        private var descriptionErrorLabel:Label;
        private var categoryBtn:LabelButton;
        private var categoryErrorLabel:Label;
        private var currencyBtn:LabelButton;

        private var withdrawalCategoriesDP:Array = [];
        private var depositCategoriesDP:Array = [];
        private var currenciesDP:Array = [];

        private var selectedCategory:CategoryVO;
        private var selectedCurrency:CurrencyVO;

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
            titleBar.addEventListener(ActionEvent.ACTION_SELECTED, onAddExpenseAction);

            var textLabel:Label;
            var labelContainer:Container;

            var container:Container = ContainerHelper.createContainer();
            container.scrollDirection = ScrollDirection.VERTICAL;

            var gridData:GridData = new GridData();
            gridData.setOptions(SizeOptions.RESIZE_BOTH);
            container.layoutData = gridData;

            // TRANSACTION DIRECTION
            textLabel = new Label();
            textLabel.text = "Kierunek:";
            textLabel.format = TextFormatUtil.setFormat(textLabel.format, 45);
            container.addChild(textLabel);

            var directionsGrid:GridLayout = new GridLayout();
            directionsGrid.numColumns = 2;
            directionsGrid.hSpacing = 40;
            var directionsContainer:Container = new Container();
            directionsContainer.layout = directionsGrid;

            withdrawalRadio = new RadioButton();
            withdrawalRadio.label = "Wydatek";
            withdrawalRadio.selected = true;
            withdrawalRadio.groupname = "direction";
            withdrawalRadio.paddingLeft = 10;
            withdrawalRadio.setTextFormatForState(TextFormatUtil.setFormat(withdrawalRadio.getTextFormatForState(SkinStates.UP), 45), SkinStates.UP);
            withdrawalRadio.setTextFormatForState(TextFormatUtil.setFormat(withdrawalRadio.getTextFormatForState(SkinStates.DOWN), 45), SkinStates.DOWN);
            withdrawalRadio.setTextFormatForState(TextFormatUtil.setFormat(withdrawalRadio.getTextFormatForState(SkinStates.SELECTED), 45), SkinStates.SELECTED);

            depositRadio = new RadioButton();
            depositRadio.label = "Przychód";
            depositRadio.groupname = "direction";
            depositRadio.paddingLeft = 10;
            depositRadio.setTextFormatForState(TextFormatUtil.setFormat(depositRadio.getTextFormatForState(SkinStates.UP), 45), SkinStates.UP);
            depositRadio.setTextFormatForState(TextFormatUtil.setFormat(depositRadio.getTextFormatForState(SkinStates.DOWN), 45), SkinStates.DOWN);
            depositRadio.setTextFormatForState(TextFormatUtil.setFormat(depositRadio.getTextFormatForState(SkinStates.SELECTED), 45), SkinStates.SELECTED);

            directionsContainer.addChild(withdrawalRadio);
            directionsContainer.addChild(depositRadio);

            container.addChild(directionsContainer);

            directionRadioGroup = RadioButtonGroup.getGroup("direction");
            directionRadioGroup.addEventListener(Event.CHANGE, onDirectionChange);

            // AMOUNT LABEL
            labelContainer = new Container();
            labelContainer.layout = ContainerHelper.createTwoColumnGridData();

            textLabel = new Label();
            textLabel.text = "Kwota:";
            textLabel.format = TextFormatUtil.setFormat(textLabel.format, 45);
            labelContainer.addChild(textLabel);

            expenseErrorLabel = new Label();
            expenseErrorLabel.format = TextFormatUtil.setFormat(textLabel.format, 45, 0xFF0000);
            labelContainer.addChild(expenseErrorLabel);
            container.addChild(labelContainer)

            // AMOUNT INPUT
            amountTextInput = new TextInput();
            amountTextInput.restrict = "0-9.";
            amountTextInput.prompt = "Wysokość wydatku";
            amountTextInput.softKeyboardType = KeyboardType.NUMBERS_PUNCTUATION;
            container.addChild(amountTextInput);


            // DATE LABEL
            textLabel = new Label();
            textLabel.text = "Data:";
            textLabel.format = TextFormatUtil.setFormat(textLabel.format, 45);
            container.addChild(textLabel);

            // DATE PICKER
            datePicker = new DatePicker();
            datePicker.setDate(new Date());
            container.addChild(datePicker);


            // DESCRIPTION LABEL
            labelContainer = new Container();
            labelContainer.layout = ContainerHelper.createTwoColumnGridData();

            textLabel = new Label();
            textLabel.text = "Opis:";
            textLabel.format = TextFormatUtil.setFormat(textLabel.format, 45);
            labelContainer.addChild(textLabel);

            descriptionErrorLabel = new Label();
            descriptionErrorLabel.format = TextFormatUtil.setFormat(textLabel.format, 45, 0xFF0000);
            labelContainer.addChild(descriptionErrorLabel);
            container.addChild(labelContainer)

            // DESCRIPTION INPUT
            descriptionTextInput = new TextInput();
            descriptionTextInput.prompt = "Opis wydatku";
            container.addChild(descriptionTextInput);


            // CATEGORY LABEL
            labelContainer = new Container();
            labelContainer.layout = ContainerHelper.createTwoColumnGridData();

            textLabel = new Label();
            textLabel.text = "Kategoria:";
            textLabel.format = TextFormatUtil.setFormat(textLabel.format, 45);
            labelContainer.addChild(textLabel);

            categoryErrorLabel = new Label();
            categoryErrorLabel.format = TextFormatUtil.setFormat(textLabel.format, 45, 0xFF0000);
            labelContainer.addChild(categoryErrorLabel);
            container.addChild(labelContainer)

            // CATEGORY BTN
            categoryBtn = new LabelButton();
            categoryBtn.label = ApplicationConstants.NO_CATEGORY_LABEL;
            categoryBtn.enabled = false;
            categoryBtn.addEventListener(MouseEvent.CLICK, onCategoryBtnClick);
            container.addChild(categoryBtn);


            // CURRENCY LABEL
            textLabel = new Label();
            textLabel.text = "Waluta:";
            textLabel.format = TextFormatUtil.setFormat(textLabel.format, 45);
            container.addChild(textLabel);

            // CATEGORY BTN
            currencyBtn = new LabelButton();
            currencyBtn.label = ApplicationConstants.DEFAULT_CURRENCY_NAME + " (" + ApplicationConstants.DEFAULT_CURRENCY_FULL_NAME + ")";
            currencyBtn.addEventListener(MouseEvent.CLICK, onCurrencyBtnClick);
            container.addChild(currencyBtn);

            content = container;

            viewAddedSignal.dispatch();
        }

        private function onDirectionChange(event:Event):void
        {
            if (directionRadioGroup.selection == withdrawalRadio)
            {
                amountTextInput.prompt = "Wysokość wydatku";
                descriptionTextInput.prompt = "Opis wydatku";

                categoryBtn.label = ApplicationConstants.NO_CATEGORY_LABEL;
            }
            else
            {
                amountTextInput.prompt = "Wysokość przychodu";
                descriptionTextInput.prompt = "Opis przychodu";

                categoryBtn.label = ApplicationConstants.NO_CATEGORY_LABEL;
            }
        }

        private function onCategoryBtnClick(event:MouseEvent):void
        {
            var myList:CustomListDialog = new CustomListDialog();
            myList.title = "Kategoria";
            myList.addButton("OK");
            myList.addButton("Anuluj");

            if (directionRadioGroup.selection == withdrawalRadio)
            {
                myList.list = withdrawalCategoriesDP;
            }
            else
            {
                myList.list = depositCategoriesDP;
            }

            myList.addEventListener(Event.SELECT, onCategorySelect);
            myList.show();
        }

        private function onCategorySelect(event:Event):void
        {
            var listDialog:ListDialog = event.currentTarget as ListDialog;

            if (listDialog.selectedIndex == 0)
            {
                categoryErrorLabel.text = "";

                if (directionRadioGroup.selection == withdrawalRadio)
                {
                    selectedCategory = withdrawalCategoriesDP[listDialog.listSelectedIndex] as CategoryVO;
                }
                else
                {
                    selectedCategory = depositCategoriesDP[listDialog.listSelectedIndex] as CategoryVO;
                }

                categoryBtn.label = selectedCategory.name;
            }
//            else
//            {
//                var category:CategoryVO;
//                for each (category in withdrawalCategoriesDP)
//                {
//                    category.selected = (category.id == selectedCategory.id);
//                }
//
//                for each (category in depositCategoriesDP)
//                {
//                    category.selected = (category.id == selectedCategory.id);
//                }
//            }
        }

        private function onCurrencyBtnClick(event:MouseEvent):void
        {
            var myList:CustomListDialog = new CustomListDialog();
            myList.title = "Waluta";
            myList.addButton("OK");
            myList.addButton("Anuluj");
            myList.list = currenciesDP;
            myList.allowDeselect = false;
            myList.addEventListener(Event.SELECT, onCurrencySelect);
            myList.show();
        }

        private function onCurrencySelect(event:Event):void
        {
            var listDialog:ListDialog = event.currentTarget as ListDialog;

            if (listDialog.selectedIndex == 0)
            {
                selectedCurrency = currenciesDP[listDialog.listSelectedIndex] as CurrencyVO;

                currencyBtn.label = selectedCurrency.label;
            }
//            else
//            {
//                for each (var currency:CurrencyVO in currenciesDP)
//                {
//                    if (selectedCurrency)
//                    {
//                        currency.selected = (currency.id == selectedCurrency.id);
//                    }
//                    else
//                    {
//                        currency.selected = (currency.name == ApplicationConstants.DEFAULT_CURRENCY_NAME);
//                    }
//                }
//            }
        }

        public function addData(_withdrawalCategoriesData:Array, _depositCategoriesData:Array, _currenciesData:Array):void
        {
            categoryBtn.enabled = true;

            withdrawalCategoriesDP = _withdrawalCategoriesData;
            depositCategoriesDP = _depositCategoriesData;
            currenciesDP = _currenciesData;
        }

        private function onAddExpenseAction(event:ActionEvent):void
        {
            if (amountTextInput.text == "")
            {
                expenseErrorLabel.text = "Proszę podać kwotę!";
                return;
            }

            if (descriptionTextInput.text == "")
            {
                descriptionErrorLabel.text = "Proszę podać opis!";
                return;
            }

            if (categoryBtn.label == ApplicationConstants.NO_CATEGORY_LABEL)
            {
                categoryErrorLabel.text = "Proszę wybrać kategorię!";
                return;
            }

            expenseErrorLabel.text = "";
            descriptionErrorLabel.text = "";

            var newTransaction:TransactionVO = new TransactionVO();
            newTransaction.amount = parseFloat(amountTextInput.text);
            newTransaction.transactionOn = datePicker.value;
            newTransaction.description = descriptionTextInput.text;

            newTransaction.direction = (directionRadioGroup.selection == withdrawalRadio) ? ApplicationConstants.TRANSACTION_DIRECTION_WITHDRAWAL : ApplicationConstants.TRANSACTION_DIRECTION_DEPOSIT;

            newTransaction.currencyName = (selectedCurrency) ? selectedCurrency.name : ApplicationConstants.DEFAULT_CURRENCY_NAME;
            newTransaction.categoryId = selectedCategory.id;

            addTransactionSignal.dispatch(newTransaction);
        }

        public function showAlertAndCleanUp():void
        {
            directionRadioGroup.setSelectedRadioButton(withdrawalRadio);
            amountTextInput.text = "";
            datePicker.setDate(new Date());
            descriptionTextInput.text = "";

            selectedCategory = null;
            selectedCurrency = null;

            var category:CategoryVO;
            for each (category in withdrawalCategoriesDP)
            {
                category.selected = false;
            }

            for each (category in depositCategoriesDP)
            {
                category.selected = false;
            }

            currencyBtn.label = ApplicationConstants.DEFAULT_CURRENCY_NAME + " (" + ApplicationConstants.DEFAULT_CURRENCY_FULL_NAME + ")";

            for each (var currency:CurrencyVO in currenciesDP)
            {
                currency.selected = (currency.name == ApplicationConstants.DEFAULT_CURRENCY_NAME);
            }

            var successDialog:AlertDialog = new AlertDialog();
            successDialog.title = "Sukces";
            successDialog.message = "Dodano transakcję!";
            successDialog.addButton("OK");
            successDialog.show();
        }
    }
}
