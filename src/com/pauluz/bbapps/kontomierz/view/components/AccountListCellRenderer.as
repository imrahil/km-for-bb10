/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view.components
{
    import com.pauluz.bbapps.kontomierz.model.vo.AccountVO;

    import qnx.fuse.ui.listClasses.CellRenderer;

    public class AccountListCellRenderer extends CellRenderer
    {
        override public function set data(value:Object):void
        {
            super.data = value;

            if (value)
            {
                this.setLabel((value as AccountVO).display_name);
            }
        }
    }
}
