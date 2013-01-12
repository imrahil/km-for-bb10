/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view
{
    import com.pauluz.bbapps.kontomierz.model.vo.CategoryVO;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import mx.logging.ILogger;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.events.ListEvent;
    import qnx.fuse.ui.layouts.Align;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.listClasses.SectionList;
    import qnx.fuse.ui.navigation.TitlePage;

    public class CategoriesView extends TitlePage
    {
        private var logger:ILogger;

        public var categoriesList:SectionList;

        public var viewAddedSignal:Signal = new Signal();
        public var storeSelectedCategory:Signal = new Signal(CategoryVO);

        public function CategoriesView()
        {
            super();

            title = "Kategorie";

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override protected function onAdded():void
        {
            super.onAdded();

            logger.debug(": onAdded");

            categoriesList = new SectionList();
//            categoriesList.headerHeight = 110;
//            transactionsList.cellRenderer = TransactionListCellRenderer;
            categoriesList.addEventListener(ListEvent.ITEM_CLICKED, categoryListClicked);

            var listData:GridData = new GridData();
            listData.hAlign = Align.FILL;
            listData.setOptions(SizeOptions.RESIZE_BOTH);

            categoriesList.layoutData = listData;

            content.addChild(categoriesList);

            viewAddedSignal.dispatch();
        }

        private function categoryListClicked(event:ListEvent):void
        {
            storeSelectedCategory.dispatch(event.data as CategoryVO);
        }
    }
}
