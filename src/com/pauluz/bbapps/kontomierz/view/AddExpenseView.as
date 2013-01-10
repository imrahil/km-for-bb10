/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view
{
    import com.pauluz.bbapps.kontomierz.utils.ContainerHelper;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.utils.TextFormatUtil;

    import mx.logging.ILogger;

    import qnx.fuse.ui.core.Container;

    import qnx.fuse.ui.navigation.TitlePage;
    import qnx.fuse.ui.text.Label;

    public class AddExpenseView extends TitlePage
    {
        private var logger:ILogger;

        public function AddExpenseView()
        {
            super();

            title = "Dodaj wydatek";

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override protected function onAdded():void
        {
            super.onAdded();

            logger.debug(": onAdded");

            var container:Container = ContainerHelper.createContainer();

            content = container;
        }
    }
}
