/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view
{
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.utils.ContainerHelper;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.utils.TextFormatUtil;
    import com.pauluz.bbapps.kontomierz.view.components.DatePicker;

    import flash.events.MouseEvent;

    import mx.logging.ILogger;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.buttons.LabelButton;
    import qnx.fuse.ui.core.Action;
    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.dialog.AlertDialog;
    import qnx.fuse.ui.dialog.ListDialog;
    import qnx.fuse.ui.events.ActionEvent;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.listClasses.ScrollDirection;
    import qnx.fuse.ui.navigation.TitlePage;
    import qnx.fuse.ui.text.KeyboardType;
    import qnx.fuse.ui.text.Label;
    import qnx.fuse.ui.text.TextInput;
    import qnx.ui.data.SectionDataProvider;

    public class AddTransactionView extends TitlePage
    {
        private var logger:ILogger;

        private var amountTextInput:TextInput;
        private var expenseErrorLabel:Label;
        private var datePicker:DatePicker;
        private var descriptionTextInput:TextInput;
        private var descriptionErrorLabel:Label;
        private var categoryBtn:LabelButton;

        private var categoryDP:SectionDataProvider;

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


            // DESCRIPTIONLABEL
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
            textLabel = new Label();
            textLabel.text = "Kategoria:";
            textLabel.format = TextFormatUtil.setFormat(textLabel.format, 45);
            container.addChild(textLabel);

            // CATEGORY BTN
            categoryBtn = new LabelButton();
            categoryBtn.label = "-- brak kategorii --";
            categoryBtn.enabled = false;
            categoryBtn.addEventListener(MouseEvent.CLICK, onCategoryBtnClick);
            container.addChild(categoryBtn);

            content = container;

            viewAddedSignal.dispatch();
        }

        private function onCategoryBtnClick(event:MouseEvent):void
        {
            var myList:ListDialog = new ListDialog();
            myList.title = "Kategorie";
            myList.addButton("OK");
            myList.addButton("Anuluj");
//            myList.items = categoryDP.
            myList.show();
        }

        public function addData(data:SectionDataProvider):void
        {
//            categoryBtn.enabled = true;
            categoryDP = data;
        }

        private function onAddExpenseAction(event:ActionEvent):void
        {
            if (amountTextInput.text == "")
            {
                expenseErrorLabel.text = "Proszę podać kwotę!";
            }
            else if (descriptionTextInput.text == "")
            {
                descriptionErrorLabel.text = "Proszę podać opis!";
            }
            else
            {
                expenseErrorLabel.text = "";
                descriptionErrorLabel.text = "";

                var newTransaction:TransactionVO = new TransactionVO();
                newTransaction.amount = parseFloat(amountTextInput.text);
                newTransaction.transactionOn = datePicker.value;
                newTransaction.description = descriptionTextInput.text;

                addTransactionSignal.dispatch(newTransaction);
            }
        }

        public function showAlertAndCleanUp():void
        {
            amountTextInput.text = "";
            datePicker.setDate(new Date());
            descriptionTextInput.text = "";

            var successDialog:AlertDialog = new AlertDialog();
            successDialog.title = "Sukces";
            successDialog.message = "Dodano transakcję!";
            successDialog.addButton("OK");
            successDialog.show();
        }
    }
}
