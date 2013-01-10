/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view
{
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.view.components.TransactionListCellRenderer;

    import mx.logging.ILogger;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.core.Action;
    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.layouts.Align;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.listClasses.List;
    import qnx.fuse.ui.navigation.NavigationPaneProperties;
    import qnx.fuse.ui.navigation.TitlePage;

    public class AllTransactionsView extends TitlePage
    {
        private var logger:ILogger;
        public var transactionsList:List;

        public var viewAddedSignal:Signal = new Signal();

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

            transactionsList = new List();
            transactionsList.cellRenderer = TransactionListCellRenderer;
//            transactionsList.addEventListener(ListEvent.ITEM_CLICKED, listClicked);

            var listData:GridData = new GridData();
            listData.hAlign = Align.FILL;
            listData.setOptions(SizeOptions.RESIZE_BOTH);

            transactionsList.layoutData = listData;

            content.addChild(transactionsList);

            viewAddedSignal.dispatch();
        }

//        private function listClicked(event:ListEvent):void
//        {
//        }
    }
}