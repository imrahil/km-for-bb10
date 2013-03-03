/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view.components
{
    import com.pauluz.bbapps.kontomierz.constants.ApplicationConstants;
    import com.pauluz.bbapps.kontomierz.model.vo.CategoryVO;
    import com.pauluz.bbapps.kontomierz.model.vo.CurrencyVO;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.utils.ContainerHelper;
    import com.pauluz.bbapps.kontomierz.utils.TextFormatUtil;

    import flash.events.Event;
    import flash.events.MouseEvent;

    import qnx.fuse.ui.buttons.LabelButton;
    import qnx.fuse.ui.buttons.RadioButton;
    import qnx.fuse.ui.buttons.RadioButtonGroup;
    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.dialog.ListDialog;
    import qnx.fuse.ui.events.ExpandableEvent;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.listClasses.ScrollDirection;
    import qnx.fuse.ui.skins.SkinStates;
    import qnx.fuse.ui.text.KeyboardType;
    import qnx.fuse.ui.text.Label;
    import qnx.fuse.ui.text.TextInput;
    import qnx.ui.data.SectionDataProvider;

    public class AddEditTransactionForm
    {
        public var createDirection:Boolean = true;

        public var directionLbl:Label;
        public var directionRadioGroup:RadioButtonGroup;
        public var withdrawalRadio:RadioButton;
        public var depositRadio:RadioButton;
        public var amountTextInput:TextInput;
        public var datePicker:DatePicker;
        public var descriptionTextInput:TextInput;
        public var categoryBtn:LabelButton;
        public var currencyBtn:LabelButton;

        public var withdrawalCategoriesDP:SectionDataProvider;
        public var withdrawalCategoriesLength:int;
        public var depositCategoriesDP:SectionDataProvider;
        public var depositCategoriesLength:int;
        public var currenciesDP:Array = [];

        public var direction:String = ApplicationConstants.TRANSACTION_DIRECTION_WITHDRAWAL;
        public var selectedCategory:CategoryVO;
        public var selectedCurrency:CurrencyVO;

        public function createForm():Container
        {
            var textLabel:Label;

            var container:Container = ContainerHelper.createContainer();
            container.scrollDirection = ScrollDirection.VERTICAL;

            var gridData:GridData = new GridData();
            gridData.setOptions(SizeOptions.RESIZE_BOTH);
            container.layoutData = gridData;

            // TRANSACTION DIRECTION
            var multiColumnContainer:Container = ContainerHelper.createMultiColumnContainer(3);

            textLabel = new Label();
            textLabel.text = "Kierunek:";
            textLabel.format = TextFormatUtil.setFormat(textLabel.format, 45);
            multiColumnContainer.addChild(textLabel);

            if (createDirection)
            {
                withdrawalRadio = new RadioButton();
                withdrawalRadio.label = "Wydatek";
                withdrawalRadio.selected = true;
                withdrawalRadio.groupname = "direction";
                withdrawalRadio.paddingLeft = 10;
                withdrawalRadio.setTextFormatForState(TextFormatUtil.setFormat(withdrawalRadio.getTextFormatForState(SkinStates.UP), 45), SkinStates.UP);
                withdrawalRadio.setTextFormatForState(TextFormatUtil.setFormat(withdrawalRadio.getTextFormatForState(SkinStates.DOWN), 45), SkinStates.DOWN);
                withdrawalRadio.setTextFormatForState(TextFormatUtil.setFormat(withdrawalRadio.getTextFormatForState(SkinStates.SELECTED), 45), SkinStates.SELECTED);
                withdrawalRadio.setTextFormatForState(TextFormatUtil.setFormat(withdrawalRadio.getTextFormatForState(SkinStates.DISABLED), 45), SkinStates.DISABLED);

                depositRadio = new RadioButton();
                depositRadio.label = "Przychód";
                depositRadio.groupname = "direction";
                depositRadio.paddingLeft = 10;
                depositRadio.setTextFormatForState(TextFormatUtil.setFormat(depositRadio.getTextFormatForState(SkinStates.UP), 45), SkinStates.UP);
                depositRadio.setTextFormatForState(TextFormatUtil.setFormat(depositRadio.getTextFormatForState(SkinStates.DOWN), 45), SkinStates.DOWN);
                depositRadio.setTextFormatForState(TextFormatUtil.setFormat(depositRadio.getTextFormatForState(SkinStates.SELECTED), 45), SkinStates.SELECTED);
                depositRadio.setTextFormatForState(TextFormatUtil.setFormat(depositRadio.getTextFormatForState(SkinStates.DISABLED), 45), SkinStates.DISABLED);

                multiColumnContainer.addChild(withdrawalRadio);
                multiColumnContainer.addChild(depositRadio);

                directionRadioGroup = RadioButtonGroup.getGroup("direction");
                directionRadioGroup.addEventListener(Event.CHANGE, onDirectionChange);
            }
            else
            {
                directionLbl = new Label();
                directionLbl.format = TextFormatUtil.setFormat(textLabel.format, 45);
                multiColumnContainer.addChild(directionLbl);
            }

            container.addChild(multiColumnContainer);

            // AMOUNT LABEL
            textLabel = new Label();
            textLabel.text = "Kwota:";
            textLabel.format = TextFormatUtil.setFormat(textLabel.format, 45);
            container.addChild(textLabel);

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
            datePicker.addEventListener(ExpandableEvent.OPENING, onDatePickerOpening);
            datePicker.addEventListener(ExpandableEvent.CLOSING, onDatePickerClosing);
            container.addChild(datePicker);


            // DESCRIPTION LABEL
            textLabel = new Label();
            textLabel.text = "Opis:";
            textLabel.format = TextFormatUtil.setFormat(textLabel.format, 45);
            container.addChild(textLabel);

            // DESCRIPTION INPUT
            descriptionTextInput = new TextInput();
            descriptionTextInput.prompt = "Opis wydatku";
            container.addChild(descriptionTextInput);


            // CATEGORY LABEL
            textLabel = new Label();
            textLabel.text = "Kategoria:";
            textLabel.format = TextFormatUtil.setFormat(textLabel.format, 45);
            container.addChild(textLabel);

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

            // CURRENCY BTN
            currencyBtn = new LabelButton();
            currencyBtn.label = ApplicationConstants.DEFAULT_CURRENCY_NAME + " (" + ApplicationConstants.DEFAULT_CURRENCY_FULL_NAME + ")";
            currencyBtn.enabled = false;
            currencyBtn.addEventListener(MouseEvent.CLICK, onCurrencyBtnClick);
            container.addChild(currencyBtn);

            return container;
        }

        private function onDatePickerOpening(event:ExpandableEvent):void
        {
            datePicker.prompt = "Wybierz datę";
        }

        private function onDatePickerClosing(event:ExpandableEvent):void
        {
            datePicker.prompt = "";
        }

        private function onDirectionChange(event:Event):void
        {
            selectedCategory = null;

            if (directionRadioGroup.selection == withdrawalRadio)
            {
                amountTextInput.prompt = "Wysokość wydatku";
                descriptionTextInput.prompt = "Opis wydatku";

                direction = ApplicationConstants.TRANSACTION_DIRECTION_WITHDRAWAL;
                categoryBtn.label = ApplicationConstants.NO_CATEGORY_LABEL;
            }
            else
            {
                amountTextInput.prompt = "Wysokość przychodu";
                descriptionTextInput.prompt = "Opis przychodu";

                direction = ApplicationConstants.TRANSACTION_DIRECTION_DEPOSIT;
                categoryBtn.label = ApplicationConstants.NO_CATEGORY_LABEL;
            }
        }

        private function onCategoryBtnClick(event:MouseEvent):void
        {
            var listDialog:CategoryListDialog = new CategoryListDialog();
            listDialog.title = "Kategoria";
            listDialog.addButton("OK");
            listDialog.addButton("Anuluj");

            if (direction == ApplicationConstants.TRANSACTION_DIRECTION_WITHDRAWAL)
            {
                listDialog.items(withdrawalCategoriesDP, withdrawalCategoriesLength);
            }
            else
            {
                listDialog.items(depositCategoriesDP, depositCategoriesLength);
            }

            if (selectedCategory)
            {
                listDialog.list.selectedItem = selectedCategory;
            }

            listDialog.addEventListener(Event.SELECT, onCategorySelect);
            listDialog.show();
        }

        private function onCategorySelect(event:Event):void
        {
            var listDialog:CategoryListDialog = event.currentTarget as CategoryListDialog;
            listDialog.removeEventListener(Event.SELECT, onCategorySelect);

            if (listDialog.selectedIndex == 0)
            {
                // jesli wybrano OK
                if (listDialog && listDialog.list && listDialog.list.selectedItem)
                {
                    selectedCategory = listDialog.selectedItem as CategoryVO;
                    selectedCategory.selected = true;

                    categoryBtn.label = selectedCategory.name;
                }
            }
        }

        private function onCurrencyBtnClick(event:MouseEvent):void
        {
            if (selectedCurrency)
            {
                for each (var currency:CurrencyVO in currenciesDP)
                {
                    currency.selected = (currency.name == selectedCurrency.name);
                }
            }

            var listDialog:CustomListDialog = new CustomListDialog();
            listDialog.title = "Waluta";
            listDialog.addButton("OK");
            listDialog.addButton("Anuluj");
            listDialog.list = currenciesDP;
            listDialog.allowDeselect = false;
            listDialog.addEventListener(Event.SELECT, onCurrencySelect);
            listDialog.show();
        }

        private function onCurrencySelect(event:Event):void
        {
            var listDialog:ListDialog = event.currentTarget as ListDialog;
            listDialog.removeEventListener(Event.SELECT, onCurrencySelect);

            if (listDialog.selectedIndex == 0)
            {
                selectedCurrency = currenciesDP[listDialog.listSelectedIndex] as CurrencyVO;

                if (selectedCurrency)
                {
                    currencyBtn.label = selectedCurrency.label;
                }
            }
        }

        public function provideTransactionData():TransactionVO
        {
            var newTransaction:TransactionVO = new TransactionVO();
            newTransaction.currencyAmount = parseFloat(amountTextInput.text);
            newTransaction.transactionOn = datePicker.value;
            newTransaction.description = descriptionTextInput.text;

            newTransaction.direction = direction;

            newTransaction.currencyName = (selectedCurrency) ? selectedCurrency.name : ApplicationConstants.DEFAULT_CURRENCY_NAME;
            newTransaction.categoryId = selectedCategory.categoryId;
            newTransaction.categoryName = (selectedCategory) ? categoryBtn.label : "";

            return newTransaction;
        }

        public function removeListeners():void
        {
            if (directionRadioGroup)
            {
                directionRadioGroup.removeEventListener(Event.CHANGE, onDirectionChange);
            }

            categoryBtn.removeEventListener(MouseEvent.CLICK, onCategoryBtnClick);
            currencyBtn.removeEventListener(MouseEvent.CLICK, onCurrencyBtnClick);
        }
    }
}
