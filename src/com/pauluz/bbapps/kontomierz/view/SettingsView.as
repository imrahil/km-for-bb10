/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view
{
    import com.pauluz.bbapps.kontomierz.constants.Resources;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import mx.logging.ILogger;

    import qnx.fuse.ui.actionbar.ActionPlacement;
    import qnx.fuse.ui.core.Action;
    import qnx.fuse.ui.core.ActionBase;
    import qnx.fuse.ui.navigation.TitlePage;

    public class SettingsView extends TitlePage
    {
        private var logger:ILogger;
        private var aboutAction:Action;

        public function SettingsView()
        {
            super();

            title = "Ustawienia";

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override protected function init():void
        {
            super.init();

            aboutAction = new Action("O programie", new Resources.ICON_ABOUT());
            aboutAction.actionBarPlacement = ActionPlacement.ON_BAR;

            actions = new Vector.<Action>();
            actions.push(aboutAction);
        }

        override protected function onAdded():void
        {
            super.onAdded();

            logger.debug(": onAdded");

        }

        override public function onActionSelected(action:ActionBase):void
        {
            if (action == aboutAction)
            {
                var aboutPage:AboutView = new AboutView();
                pushPage(aboutPage);
            }
            else
            {
                super.onActionSelected(action);
            }
        }
    }
}
