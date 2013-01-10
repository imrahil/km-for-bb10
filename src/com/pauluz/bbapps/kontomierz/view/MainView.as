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

    import flash.display.Sprite;

    import mx.logging.ILogger;

    import qnx.fuse.ui.navigation.Page;
    import qnx.fuse.ui.navigation.Tab;
    import qnx.fuse.ui.navigation.TabbedPane;

    public class MainView extends Page
    {
        private var logger:ILogger;

        private var tabbedPane:TabbedPane;
        private var tabOverFlow:Sprite;

        public function MainView()
        {
            super();

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override protected function onAdded():void
        {
            super.onAdded();

            logger.debug(": onAdded");

            tabOverFlow = new Sprite();
            addChild(tabOverFlow);

            tabbedPane = new TabbedPane();
            tabbedPane.tabOverflowParent = tabOverFlow;

            var tabs:Vector.<Tab> = new Vector.<Tab>();

            tabs.push(ContainerHelper.createNavPane("Konta", new Resources.ICON_ACCOUNTS(), AccountListView));
            tabs.push(ContainerHelper.createTab("Portfel", new Resources.ICON_WALLET(), WalletView));
            tabs.push(ContainerHelper.createTab("Dodaj", new Resources.ICON_ADD(), EmptyView));
            tabs.push(ContainerHelper.createTab("Budżety", new Resources.ICON_BUDGETS(), EmptyView));
            tabs.push(ContainerHelper.createTab("Płatności", new Resources.ICON_SCHEDULES(), EmptyView));
            tabs.push(ContainerHelper.createTab("Kategorie", new Resources.ICON_CATEGORIES(), EmptyView));
            tabs.push(ContainerHelper.createTab("Tagi", new Resources.ICON_TAGS(), EmptyView));
            tabs.push(ContainerHelper.createTab("Wykresy", new Resources.ICON_CHARTS(), ChartsView));
            tabs.push(ContainerHelper.createNavPane("Ustawienia", new Resources.ICON_SETTINGS(), SettingsView));

            tabbedPane.tabs = tabs;
            tabbedPane.activeTab = tabs[0];

            content = tabbedPane;
        }
    }
}
