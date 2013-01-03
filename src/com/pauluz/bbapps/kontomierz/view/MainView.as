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

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;

    import qnx.fuse.ui.navigation.Tab;
    import qnx.fuse.ui.navigation.TabbedPane;

    public class MainView extends Sprite
    {
        private var tabbedPane:TabbedPane;
        private var tabOverFlow:Sprite;

        public function MainView()
        {
            this.addEventListener(Event.ADDED_TO_STAGE, create)
        }

        private function create(event:Event):void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, create);

            stage.addEventListener(Event.RESIZE, stageResize);

            tabOverFlow = new Sprite();
            addChild(tabOverFlow);

            tabbedPane = new TabbedPane();
            tabbedPane.tabOverflowParent = tabOverFlow;

            var tabs:Vector.<Tab> = new Vector.<Tab>();

            tabs.push(createTab("O programie", new Resources.ICON_ABOUT(), AboutView));

            tabbedPane.tabs = tabs;
            tabbedPane.activeTab = tabs[0];

            addChild(tabbedPane);

            tabbedPane.width = stage.stageWidth;
            tabbedPane.height = stage.stageHeight;
        }

        private function stageResize(event:Event):void
        {
            tabbedPane.width = stage.stageWidth;
            tabbedPane.height = stage.stageHeight;
        }

        private function createTab(label:String, icon:Object, content:Class):Tab
        {
            var tab:Tab = new Tab(label, icon);
            tab.content = new content();

            return(tab);
        }
    }
}
