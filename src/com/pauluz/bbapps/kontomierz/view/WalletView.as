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


    import mx.logging.ILogger;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.core.Action;
    import qnx.fuse.ui.core.ActionBase;
    import qnx.fuse.ui.core.ActionSet;

    import qnx.fuse.ui.core.Container;

    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.events.ActionEvent;
    import qnx.fuse.ui.events.ContextMenuEvent;

    import qnx.fuse.ui.events.ListEvent;
    import qnx.fuse.ui.layouts.Align;
    import qnx.fuse.ui.layouts.gridLayout.GridData;

    import qnx.fuse.ui.listClasses.List;
    import qnx.fuse.ui.listClasses.ListSelectionMode;

    import qnx.fuse.ui.navigation.TitlePage;
    import qnx.ui.data.DataProvider;

    public class WalletView extends TitlePage
    {
        private var logger:ILogger;

        private var container:Container;
        private var transactionsList:List;
        private var _contextMenuOpen:Boolean;

        private var editAction:Action;
        private var deleteAction:Action;

        public var viewAddedSignal:Signal = new Signal();
        public var storeSelectedTransaction:Signal = new Signal(TransactionVO);

        public function WalletView()
        {
            super();

            title = "Portfel";

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override protected function onAdded():void
        {
            super.onAdded();

            logger.debug(": onAdded");

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

            container.addChild(transactionsList);

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

            content = ContainerHelper.createSpinner();

            viewAddedSignal.dispatch();
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
                // TODO
            }
            else if (event.action == deleteAction)
            {
                // TODO
            }
        }

        public function addDetailView():void
        {
            var detailView:SingleTransactionView = new SingleTransactionView();
            pushPage(detailView);
        }

        public function addData(data:DataProvider):void
        {
            content = container;
            transactionsList.dataProvider = data;
        }
    }
}
