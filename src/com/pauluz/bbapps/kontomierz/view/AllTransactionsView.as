/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view
{
    import com.pauluz.bbapps.kontomierz.constants.Resources;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.utils.ContainerHelper;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.view.components.TransactionListCellRenderer;

    import flash.events.Event;

    import mx.logging.ILogger;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.core.Action;
    import qnx.fuse.ui.core.ActionBase;
    import qnx.fuse.ui.core.ActionSet;
    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.dialog.AlertDialog;
    import qnx.fuse.ui.events.ActionEvent;
    import qnx.fuse.ui.events.ContextMenuEvent;
    import qnx.fuse.ui.events.ListEvent;
    import qnx.fuse.ui.layouts.Align;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.listClasses.List;
    import qnx.fuse.ui.listClasses.ListSelectionMode;
    import qnx.fuse.ui.navigation.NavigationPaneProperties;
    import qnx.fuse.ui.navigation.TitlePage;
    import qnx.ui.data.DataProvider;

    public class AllTransactionsView extends TitlePage
    {
        private var logger:ILogger;
        private var container:Container;
        public var transactionsList:List;
        private var _contextMenuOpen:Boolean;

        private var editAction:Action;
        private var deleteAction:Action;

        public var viewAddedSignal:Signal = new Signal();
        public var storeSelectedTransaction:Signal = new Signal(TransactionVO);
        public var storeSelectedTransactionForEdit:Signal = new Signal(TransactionVO);

        public var deleteTransaction:Signal = new Signal(TransactionVO);

        public function AllTransactionsView()
        {
            super();

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override protected function init():void
        {
            super.init();

            var prop:NavigationPaneProperties = new NavigationPaneProperties();
            prop.backButton = new Action("Konta");
            paneProperties = prop;
        }

        override protected function onAdded():void
        {
            super.onAdded();

            logger.debug(": onAdded");

            content = ContainerHelper.createSpinner();

            titleBar.acceptAction = new Action("Odśwież");

            viewAddedSignal.dispatch();
        }

        private function createUI():void
        {
            container = ContainerHelper.createEmptyContainer(0xFFFFFF);

            transactionsList = new List();
            transactionsList.selectionMode = ListSelectionMode.SINGLE;
            transactionsList.cellRenderer = TransactionListCellRenderer;
            transactionsList.addEventListener(ListEvent.ITEM_CLICKED, transactionListClicked);
            transactionsList.addEventListener(ContextMenuEvent.OPENING, contextMenuOpening);
            transactionsList.addEventListener(ContextMenuEvent.CLOSING, contextMenuClosing);
            transactionsList.addEventListener(ActionEvent.ACTION_SELECTED, contextMenuSelected);

            var listData:GridData = new GridData();
            listData.hAlign = Align.FILL;
            listData.setOptions(SizeOptions.RESIZE_BOTH);

            transactionsList.layoutData = listData;

            var actionSet:ActionSet = new ActionSet();
            actionSet.subtitle = "Opcje transakcji";

            editAction = new Action("Edytuj", new Resources.ICON_EDIT());
            deleteAction = new Action("Usuń", new Resources.ICON_DELETE());

            var actions:Vector.<ActionBase> = new Vector.<ActionBase>();
            actions.push(editAction);
            actions.push(deleteAction);

            actionSet.actions = actions;

            var contextActions:Vector.<ActionSet> = new Vector.<ActionSet>();
            contextActions.push(actionSet);

            transactionsList.contextActions = contextActions;

            container.addChild(transactionsList);
        }

        private function transactionListClicked(event:ListEvent):void
        {
            if (_contextMenuOpen)
            {
                return;
            }

            storeSelectedTransaction.dispatch(event.data as TransactionVO);
        }

        private function contextMenuOpening(event:ContextMenuEvent):void
        {
            _contextMenuOpen = true;
        }

        private function contextMenuClosing(event:ContextMenuEvent):void
        {
            _contextMenuOpen = false;
        }

        private function contextMenuSelected(event:ActionEvent):void
        {
            if (event.action == editAction)
            {
                var selectedTransaction:TransactionVO = transactionsList.selectedItem as TransactionVO;

                if (selectedTransaction)
                {
                    storeSelectedTransactionForEdit.dispatch(selectedTransaction);
                }
            }
            else if (event.action == deleteAction)
            {
                var confirmDialog:AlertDialog = new AlertDialog();
                confirmDialog.title = "Potwierdzenie";
                confirmDialog.message = "Czy napewno usunąć wybraną transakcję?";
                confirmDialog.addButton("TAK");
                confirmDialog.addButton("NIE");
                confirmDialog.addEventListener(Event.SELECT, onDeleteConfirmation);
                confirmDialog.show();
            }
        }

        private function onDeleteConfirmation(event:Event):void
        {
            var selectedTransaction:TransactionVO = transactionsList.selectedItem as TransactionVO;

            if (event.target.selectedIndex == 0 && selectedTransaction)
            {
                deleteTransaction.dispatch(selectedTransaction);

                content = ContainerHelper.createSpinner();
            }
        }

        public function addDetailView():void
        {
            var detailView:SingleTransactionView = new SingleTransactionView();
            pushPage(detailView);
        }

        public function addEditView():void
        {
            var editView:EditTransactionView = new EditTransactionView();
            pushPage(editView);
        }

        public function addData(data:DataProvider):void
        {
            createUI();

            content = container;
            transactionsList.dataProvider = data;
        }
    }
}
