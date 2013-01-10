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
    import qnx.fuse.ui.layouts.gridLayout.GridLayout;
    import qnx.fuse.ui.navigation.NavigationPane;
    import qnx.fuse.ui.navigation.Tab;

    public class ContainerHelper
    {
        public static function createContainer():Container
        {
            var container:Container = new Container();
            var layout:GridLayout = new GridLayout();
            layout.paddingLeft = 50;
            layout.paddingRight = 50;
            layout.paddingTop = 50;
            layout.paddingBottom = 50;
            layout.vSpacing = 40;
            container.layout = layout;

            var s:Sprite = new Sprite();
            var g:Graphics = s.graphics;
            g.beginFill(0x0c151c);
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
    }
}
