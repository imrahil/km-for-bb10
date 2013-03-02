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
    import com.pauluz.bbapps.kontomierz.constants.Resources;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.utils.ContainerHelper;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.utils.TextFormatUtil;

    import flash.events.Event;

    import mx.logging.ILogger;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.core.Action;
    import qnx.fuse.ui.core.ActionBase;
    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.dialog.AlertDialog;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.layouts.gridLayout.GridLayout;
    import qnx.fuse.ui.listClasses.ScrollDirection;
    import qnx.fuse.ui.navigation.NavigationPaneProperties;
    import qnx.fuse.ui.navigation.TitlePage;
    import qnx.fuse.ui.text.Label;

    public class SingleTransactionView extends TitlePage
    {
        private var logger:ILogger;

        private var editAction:Action;
        private var deleteAction:Action;

        public var isWallet:Boolean;

        public var viewAddedSignal:Signal = new Signal();

        private var amountLbl:Label;
        private var dateLbl:Label;
        private var descriptionLbl:Label;
        private var categoryLbl:Label;

        public var editTransaction:Signal = new Signal();
        public var deleteTransaction:Signal = new Signal(Boolean);

        public function SingleTransactionView()
        {
            super();

            title = "Szczegóły transakcji";

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override protected function init():void
        {
            super.init();

            var prop:NavigationPaneProperties = new NavigationPaneProperties();
            prop.backButton = new Action("Transakcje");

            actions = new Vector.<ActionBase>();

            editAction = new Action("Edytuj", new Resources.ICON_EDIT());
            actions.push(editAction);

            deleteAction = new Action("Usuń", new Resources.ICON_DELETE());
            actions.push(deleteAction);

            paneProperties = prop;
        }

        override protected function onAdded():void
        {
            super.onAdded();

            logger.debug(": onAdded");

            var container:Container = ContainerHelper.createContainer();
            container.scrollDirection = ScrollDirection.VERTICAL;

            var layout:GridLayout = container.layout as GridLayout;
            layout.vSpacing = 20;
            container.layout = layout;

            var textLabel:Label;

            var gridData:GridData = new GridData();
            gridData.setOptions(SizeOptions.RESIZE_HORIZONTAL);
            container.layoutData = gridData;

            textLabel = new Label();
            textLabel.text = "Kwota";
            textLabel.format = TextFormatUtil.setFormat(textLabel.format, 45);
            textLabel.layoutData = gridData;
            container.addChild(textLabel);

            amountLbl = new Label();
            amountLbl.format = TextFormatUtil.setFormatAlignRight(textLabel.format);
            container.addChild(amountLbl);

            textLabel = new Label();
            textLabel.text = "Data";
            textLabel.format = TextFormatUtil.setFormat(textLabel.format, 45);
            container.addChild(textLabel);

            dateLbl = new Label();
            dateLbl.format = TextFormatUtil.setFormatAlignRight(textLabel.format);
            container.addChild(dateLbl);

            textLabel = new Label();
            textLabel.text = "Opis";
            textLabel.format = TextFormatUtil.setFormat(textLabel.format, 45);
            container.addChild(textLabel);

            descriptionLbl = new Label();
            descriptionLbl.maxLines = 0;
            descriptionLbl.format = TextFormatUtil.setFormatAlignRight(textLabel.format);
            gridData = new GridData();
            gridData.setOptions(SizeOptions.SHRINK_HORIZONTAL);
            descriptionLbl.layoutData = gridData;
            container.addChild(descriptionLbl);

            textLabel = new Label();
            textLabel.text = "Kategoria";
            textLabel.format = TextFormatUtil.setFormat(textLabel.format, 45);
            container.addChild(textLabel);

            categoryLbl = new Label();
            categoryLbl.format = TextFormatUtil.setFormatAlignRight(textLabel.format);
            container.addChild(categoryLbl);

            content = container;

            viewAddedSignal.dispatch();
        }

        override public function onActionSelected(action:ActionBase):void
        {
            if (action == editAction)
            {
                editTransaction.dispatch();
            }
            else if (action == deleteAction)
            {
                var confirmDialog:AlertDialog = new AlertDialog();
                confirmDialog.title = "Potwierdzenie";
                confirmDialog.message = "Czy napewno usunąć wybraną transakcję?";
                confirmDialog.addButton("TAK");
                confirmDialog.addButton("NIE");
                confirmDialog.addEventListener(Event.SELECT, onDeleteConfirmation);
                confirmDialog.show();
            }
            else
            {
                super.onActionSelected(action);
            }
        }

        private function onDeleteConfirmation(event:Event):void
        {
            if (event.target.selectedIndex == 0)
            {
                deleteTransaction.dispatch(isWallet);

                popAndDeletePage();
            }
        }

        public function showDetails(transaction:TransactionVO):void
        {
            var amountLabel:String = transaction.currencyAmountString;
            if (transaction.direction)
            {
                // jesli robimy refresh - znamy direction i mozemy ustawic czy plus czy minus
                if (transaction.direction == ApplicationConstants.TRANSACTION_DIRECTION_WITHDRAWAL)
                {
                    amountLbl.text = "-" + amountLabel + " " + transaction.currencyName;
                }
                else
                {
                    amountLbl.text = amountLabel + " " + transaction.currencyName;
                }
            }
            else
            {
                // transakcja z API - nie ma direction - wyswietlamy tak jak jest
                amountLbl.text = amountLabel + " " + transaction.currencyName;
            }

            dateLbl.text = transaction.transactionOn;
            descriptionLbl.text = transaction.description;
            categoryLbl.text = transaction.categoryName;
        }

        public function addEditView():void
        {
            var editView:EditTransactionView = new EditTransactionView();
            pushPage(editView);
        }
    }
}
