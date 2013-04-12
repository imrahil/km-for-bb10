package com.pauluz.bbapps.kontomierz.view.components
{
    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.dialog.AlertDialog;
    import qnx.fuse.ui.dialog.ListDialogCellRenderer;
    import qnx.fuse.ui.layouts.Align;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.listClasses.ListSelectionMode;
    import qnx.fuse.ui.listClasses.SectionList;
    import qnx.ui.data.SectionDataProvider;

    public class CategoryListDialog extends AlertDialog
    {
        private var _list:SectionList;
        private var _itemCount:int;

        public function CategoryListDialog()
        {
            super();
        }

        protected override function createContent(container:Container):void
        {
            super.createContent(container);

            var containerLayoutData:GridData = container.layoutData as GridData;
            containerLayoutData.setOptions(SizeOptions.RESIZE_VERTICAL);
            container.layoutData = containerLayoutData;

            this._list = new SectionList();
            this._list.cellRenderer = ListDialogCellRenderer;
            this._list.headerHeight = 80;
            this._list.headerSkin = CustomSectionHeaderRenderer;
            this._list.selectionMode = ListSelectionMode.SINGLE;

            var layoutData:GridData = new GridData();
            layoutData.hAlign = Align.FILL;
            layoutData.setOptions(SizeOptions.RESIZE_BOTH);
            this._list.layoutData = layoutData;

            container.addChild(this._list);
        }

        public function items(value:SectionDataProvider, itemCount:int):void
        {
            this._list.dataProvider = value;
            this._itemCount = itemCount;

            layoutChanged = true;
            invalidateProperties();
        }

        public function get list():SectionList
        {
            return _list;
        }

        public function get selectedItem():Object
        {
            if (_list && _list.selectedItem)
            {
                return _list.selectedItem;
            }

            return null;
        }

        protected override function updateSize():void
        {
            if (!(this._list == null) && this._list.layoutData is GridData)
            {
                (this._list.layoutData as GridData).preferredHeight = this.listPreferredHeight;

                this._list.enableShadows = false;
                this._list.scrollable = false;
            }

            super.updateSize();
        }

        private function get listPreferredHeight():int
        {
            if (this._list && this._list.dataProvider)
            {
                return this._list.rowHeight * _itemCount;
            }

            return 0;
        }

        public override function destroy():void
        {
            if (this._list)
            {
                destroyComponent(this._list);
            }

            super.destroy();
        }
    }
}
