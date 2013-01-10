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
    import com.pauluz.bbapps.kontomierz.utils.ContainerHelper;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import flash.events.MouseEvent;

    import mx.logging.ILogger;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.actionbar.ActionPlacement;
    import qnx.fuse.ui.buttons.LabelButton;
    import qnx.fuse.ui.core.Action;
    import qnx.fuse.ui.core.ActionBase;
    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.navigation.TitlePage;

    public class SettingsView extends TitlePage
    {
        private var logger:ILogger;
        private var aboutAction:Action;

        public var logoutSignal:Signal = new Signal();

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

            var container:Container = ContainerHelper.createContainer();
            var labelButton:LabelButton;
            var gridDataHolder:GridData;

//            var containerData:GridData = new GridData();
//            containerData.hAlign = Align.BEGIN;
//            containerData.vAlign = Align.BEGIN;
//            containerData.setOptions(SizeOptions.RESIZE_BOTH);
//            container.layoutData = containerData;

            labelButton = new LabelButton();
            labelButton.label = "Zmiana e-maila";
            gridDataHolder = new GridData();
            gridDataHolder.setOptions(SizeOptions.RESIZE_HORIZONTAL);
            labelButton.layoutData = gridDataHolder;
//            labelButton.addEventListener(MouseEvent.CLICK, onZalogujClick);
            container.addChild(labelButton);

            labelButton = new LabelButton();
            labelButton.label = "Zmiana hasła";
            gridDataHolder = new GridData();
            gridDataHolder.setOptions(SizeOptions.RESIZE_HORIZONTAL);
            labelButton.layoutData = gridDataHolder;
//            labelButton.addEventListener(MouseEvent.CLICK, onZalogujClick);
            container.addChild(labelButton);

            labelButton = new LabelButton();
            labelButton.label = "Wyloguj";
            gridDataHolder = new GridData();
            gridDataHolder.setOptions(SizeOptions.RESIZE_HORIZONTAL);
            labelButton.layoutData = gridDataHolder;
            labelButton.addEventListener(MouseEvent.CLICK, onWylogujClick);
            container.addChild(labelButton);

            content = container;
        }

        private function onWylogujClick(event:MouseEvent):void
        {
            logoutSignal.dispatch();
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
