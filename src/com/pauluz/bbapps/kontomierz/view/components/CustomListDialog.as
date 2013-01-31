/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view.components
{
    import qnx.fuse.ui.dialog.ListDialog;

    public class CustomListDialog extends ListDialog
    {
        public function CustomListDialog()
        {
            super();
            _list.rowHeight = 190;
        }
    }
}
