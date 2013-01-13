/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.utils
{
    import com.pauluz.bbapps.kontomierz.constants.Resources;

    import flash.display.Graphics;
    import flash.display.Sprite;

    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.layouts.Align;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.layouts.gridLayout.GridLayout;
    import qnx.fuse.ui.navigation.NavigationPane;
    import qnx.fuse.ui.navigation.Tab;
    import qnx.fuse.ui.progress.ActivityIndicator;

    public class ContainerHelper
    {
        public static function createContainer(padding:int = 50, backgroundColor:uint = 0x0c151c):Container
        {
            var container:Container = new Container();
            var layout:GridLayout = new GridLayout();
            layout.paddingLeft = padding;
            layout.paddingRight = padding;
            layout.paddingTop = padding;
            layout.paddingBottom = padding;
            layout.vSpacing = 40;
            container.layout = layout;

            var s:Sprite = new Sprite();
            var g:Graphics = s.graphics;
            g.beginFill(backgroundColor);
            g.drawRect(0, 0, 10, 10);
            g.endFill();

            container.background = s;

            return container;
        }

        public static function createEmptyContainer(backgroundColor:uint = 0x0c151c):Container
        {
            var container:Container = new Container();
            container.layout = new GridLayout();

            var gridData:GridData = new GridData();
            gridData.setOptions(SizeOptions.RESIZE_BOTH);
            container.layoutData = gridData;

            var s:Sprite = new Sprite();
            var g:Graphics = s.graphics;
            g.beginFill(backgroundColor);
            g.drawRect(0, 0, 10, 10);
            g.endFill();

            container.background = s;

            return container;
        }

        public static function createWhiteContainer():Container
        {
            var container:Container = new Container();
            var layout:GridLayout = new GridLayout();
            layout.paddingLeft = 15;
            layout.paddingRight = 15;
            layout.paddingTop = 15;
            layout.paddingBottom = 15;
            layout.vSpacing = 20;
            container.layout = layout;

            var s:Sprite = new Sprite();
            var g:Graphics = s.graphics;
            g.beginFill(0xFFFFFF);
            g.drawRect(0, 0, 10, 10);
            g.endFill();

            container.background = s;

            return container;
        }

        public static function createTab(label:String, icon:Object, content:Class):Tab
        {
            var tab:Tab = new Tab(label, icon);
            tab.content = new content();

            return tab;
        }

        public static function createNavPane(label:String, icon:Object, content:Class):Tab
        {
            var navPane:NavigationPane = new NavigationPane();
            navPane.push(new content());
            var navTab:Tab = new Tab(label, icon);
            navTab.content = navPane;

            return(navTab);
        }

        public static function createSpinner():Container
        {
            var container:Container = new Container();

            var layout:GridLayout = new GridLayout();
            layout.hAlign = Align.CENTER;
            layout.vAlign = Align.CENTER;
            container.layout = layout;
            var containerData:GridData = new GridData();
            containerData.hAlign = Align.CENTER;
            container.layoutData = containerData;

            var s:Sprite = new Sprite();
            var g:Graphics = s.graphics;
            g.beginFill(0xFFFFFF);
            g.drawRect(0, 0, 10, 10);
            g.endFill();

            container.background = s;

            var activityIndicator:ActivityIndicator = new ActivityIndicator();
            var layoutData:GridData = new GridData();
            layoutData.hAlign = Align.CENTER;
            layoutData.vAlign = Align.CENTER;
            activityIndicator.layoutData = layoutData;
            activityIndicator.animate(true);

            container.addChild(activityIndicator);

            return container;
        }

        public static function createTwoColumnGridData():GridLayout
        {
            var labelGrid:GridLayout = new GridLayout();
            labelGrid.numColumns = 2;
            labelGrid.hSpacing = 20;

            return labelGrid;
        }
    }
}
