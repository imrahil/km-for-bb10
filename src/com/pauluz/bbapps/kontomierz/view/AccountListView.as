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
    import com.pauluz.bbapps.kontomierz.view.components.AccountListCellRenderer;

    import mx.logging.ILogger;

    import qnx.fuse.ui.core.SizeOptions;

    import qnx.fuse.ui.events.ListEvent;
    import qnx.fuse.ui.layouts.Align;
    import qnx.fuse.ui.layouts.gridLayout.GridData;

    import qnx.fuse.ui.listClasses.List;
    import qnx.fuse.ui.navigation.TitlePage;

    public class AccountListView extends TitlePage
    {
        private var logger:ILogger;
        public var accountList:List;

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

            accountList = new List();
            accountList.cellRenderer = AccountListCellRenderer;
//            accountList.addEventListener(ListEvent.ITEM_CLICKED, listClicked);

            var listData:GridData = new GridData();
            listData.hAlign = Align.FILL;
            listData.setOptions(SizeOptions.RESIZE_BOTH);

            accountList.layoutData = listData;

            content.addChild(accountList);
        }
    }
}
