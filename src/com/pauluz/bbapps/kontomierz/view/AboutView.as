/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view
{
    import com.pauluz.bbapps.kontomierz.constants.ApplicationConstants;
    import com.pauluz.bbapps.kontomierz.utils.TextFormatUtil;

    import flash.desktop.NativeApplication;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.net.SharedObject;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;

    import qnx.fuse.ui.buttons.LabelButton;
    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.layouts.Align;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.layouts.gridLayout.GridLayout;
    import qnx.fuse.ui.navigation.TitlePage;
    import qnx.fuse.ui.text.Label;

    public class AboutView extends TitlePage
    {
        public function AboutView()
        {
            super();

            var app_xml:XML = NativeApplication.nativeApplication.applicationDescriptor;
            var ns:Namespace = app_xml.namespace();

            title = "Kontomierz dla BB10 - v." + app_xml.ns::versionNumber;
        }

        override protected function onAdded():void
        {
            super.onAdded();

            var container:Container = new Container();
            var layout:GridLayout = new GridLayout();
            layout.paddingLeft = 50;
            layout.paddingRight = 50;
            layout.paddingTop = 50;
            layout.paddingBottom = 30;
            container.layout = layout;

            var s:Sprite = new Sprite();
            var g:Graphics = s.graphics;
            g.beginFill(0x0c151c);
            g.drawRect(0, 0, 10, 10);
            g.endFill();

            container.background = s;

            var infoLabel:Label = new Label();
            infoLabel.maxLines = 0;
            infoLabel.text = "Author: Paweł Szczepanek\n" +
                    "Email: pawel.szczepanek@gmail.com\n\n" +
                    "Website:\nhttp://www.pauluz.pl/";

            infoLabel.format = TextFormatUtil.setFormat(infoLabel.format);

            var labelData:GridData = new GridData();
            labelData.setOptions(SizeOptions.RESIZE_BOTH);
            infoLabel.layoutData = labelData;

            container.addChild(infoLabel);

            var visitBtn:LabelButton = new LabelButton();
            visitBtn.label = "Visit website";
            visitBtn.addEventListener(MouseEvent.CLICK, onVisitBtnClick);

            var visitBtnData:GridData = new GridData();
            visitBtnData.setOptions(SizeOptions.GROW_VERTICAL);
            visitBtnData.hAlign = Align.CENTER;
            visitBtnData.vAlign = Align.BEGIN;
            visitBtn.layoutData = visitBtnData;

            container.addChild(visitBtn);

            content = container;
        }

        private static function onVisitBtnClick(event:MouseEvent):void
        {
//            navigateToURL(new URLRequest("http://www.pauluz.pl"));
            var sessionSO:SharedObject = SharedObject.getLocal(ApplicationConstants.KONTOMIERZ_SO_NAME);
            sessionSO.clear();

        }
    }
}
