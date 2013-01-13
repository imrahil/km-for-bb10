/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view
{
    import com.pauluz.bbapps.kontomierz.model.vo.AccountVO;
    import com.pauluz.bbapps.kontomierz.utils.ContainerHelper;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.view.components.AccountListCellRenderer;

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

    public class AccountListView extends TitlePage
    {
        private var logger:ILogger;

        private var container:Container;
        private var accountList:List;

        public var viewAddedSignal:Signal = new Signal();
        public var storeSelectedAccount:Signal = new Signal(AccountVO);

        public function AccountListView()
        {
            super();

            title = "Konta";

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override protected function onAdded():void
        {
            super.onAdded();

            logger.debug(": onAdded");

            container = ContainerHelper.createEmptyContainer(0xFFFFFF);

            accountList = new List();
            accountList.cellRenderer = AccountListCellRenderer;
            accountList.addEventListener(ListEvent.ITEM_CLICKED, listClicked);

            var listData:GridData = new GridData();
            listData.hAlign = Align.FILL;
            listData.setOptions(SizeOptions.RESIZE_BOTH);
            accountList.layoutData = listData;

            container.addChild(accountList);

            content = ContainerHelper.createSpinner();

            viewAddedSignal.dispatch();
        }

        private function listClicked(event:ListEvent):void
        {
            storeSelectedAccount.dispatch(event.data as AccountVO);
        }

        public function addTransactionView(title:String):void
        {
            var transactionView:AllTransactionsView = new AllTransactionsView();
            transactionView.title = title;

            pushPage(transactionView);
        }

        public function addData(data:DataProvider):void
        {
            content = container;
            accountList.dataProvider = data;
        }
    }
}
