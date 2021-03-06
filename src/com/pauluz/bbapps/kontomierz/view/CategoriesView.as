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
    import com.pauluz.bbapps.kontomierz.utils.ContainerHelper;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.view.components.CustomSectionHeaderRenderer;

    import mx.logging.ILogger;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.buttons.ToggleSwitch;
    import qnx.fuse.ui.core.Action;

    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.events.ActionEvent;
    import qnx.fuse.ui.events.ListEvent;
    import qnx.fuse.ui.layouts.Align;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.listClasses.SectionList;
    import qnx.fuse.ui.navigation.TitlePage;
    import qnx.ui.data.SectionDataProvider;

    public class CategoriesView extends TitlePage
    {
        private var logger:ILogger;

        private var container:Container;
        private var categoriesList:SectionList;

        private var filterAction:Action;

        public var viewAddedSignal:Signal = new Signal();
        public var filterSignal:Signal = new Signal();
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

            container = ContainerHelper.createEmptyContainer(0xFFFFFF);

            filterAction = new Action("Używane");
            titleBar.acceptAction = filterAction;
            titleBar.addEventListener(ActionEvent.ACTION_SELECTED, onRefreshAction);

            categoriesList = new SectionList();
            categoriesList.headerHeight = 80;
            categoriesList.headerSkin = CustomSectionHeaderRenderer;
            categoriesList.addEventListener(ListEvent.ITEM_CLICKED, categoryListClicked);

            var listData:GridData = new GridData();
            listData.hAlign = Align.FILL;
            listData.setOptions(SizeOptions.RESIZE_BOTH);
            categoriesList.layoutData = listData;

            container.addChild(categoriesList);

            content = ContainerHelper.createSpinner();

            viewAddedSignal.dispatch();
        }

        private function onRefreshAction(event:ActionEvent):void
        {
            logger.debug(": onRefreshAction");

            filterSignal.dispatch();

            filterAction.label = (filterAction.label == "Używane") ? "Wszystkie" : "Używane";
        }

        private function categoryListClicked(event:ListEvent):void
        {
            logger.debug(": categoryListClicked");

            var category:CategoryVO = event.data as CategoryVO;

            if (!category.header)
            {
                storeSelectedCategory.dispatch(category);
            }
        }

        public function addCategoryTransactionsView(title:String):void
        {
            logger.debug(": addCategoryTransactionsView");

            var categoryTransactionsView:CategoryAllTransactionsView = new CategoryAllTransactionsView();
            categoryTransactionsView.title = title;

            pushPage(categoryTransactionsView);
        }

        public function addData(categories:SectionDataProvider):void
        {
            logger.debug(": addData");

            if (content != container)
            {
                content = container;
            }

            categoriesList.dataProvider = categories;
        }
    }
}
