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

    public class ScheduleView extends TitlePage
    {
        private var logger:ILogger;

        public function ScheduleView()
        {
            super();

            title = "Płatności";

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override protected function onAdded():void
        {
            super.onAdded();

            logger.debug(": onAdded");

            var container:Container = ContainerHelper.createContainer();

            var textLabel:Label = new Label();
            textLabel.text = "Już niedługo...";
            textLabel.format = TextFormatUtil.setFormat(textLabel.format);
            container.addChild(textLabel);

            content = container;
        }
    }
}
