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
    import com.pauluz.bbapps.kontomierz.view.components.TransactionListCellRenderer;


    import mx.logging.ILogger;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.core.Container;

    import qnx.fuse.ui.core.SizeOptions;

    import qnx.fuse.ui.events.ListEvent;
    import qnx.fuse.ui.layouts.Align;
    import qnx.fuse.ui.layouts.gridLayout.GridData;

    import qnx.fuse.ui.listClasses.List;

    import qnx.fuse.ui.navigation.TitlePage;
    import qnx.ui.data.DataProvider;

    public class WalletView extends TitlePage
    {
        private var logger:ILogger;

        private var container:Container;
        private var transactionsList:List;

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
            transactionsList.cellRenderer = TransactionListCellRenderer;
            transactionsList.addEventListener(ListEvent.ITEM_CLICKED, transactionListClicked);

            var listData:GridData = new GridData();
            listData.hAlign = Align.FILL;
            listData.setOptions(SizeOptions.RESIZE_BOTH);

            transactionsList.layoutData = listData;

            container.addChild(transactionsList);

            content = ContainerHelper.createSpinner();

            viewAddedSignal.dispatch();
        }

        private function transactionListClicked(event:ListEvent):void
        {
            storeSelectedTransaction.dispatch(event.data as TransactionVO);
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
