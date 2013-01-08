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

    import mx.logging.ILogger;

    import qnx.fuse.ui.navigation.TitlePage;

    public class EmptyView extends TitlePage
    {
        private var logger:ILogger;

        public function EmptyView()
        {
            super();

            title = "...";

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override protected function onAdded():void
        {
            super.onAdded();

            logger.debug(": onAdded");

        }
    }
}
