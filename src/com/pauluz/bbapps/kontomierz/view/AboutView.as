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
    import com.useitbetter.uDash;

    import flash.desktop.NativeApplication;
    import flash.events.MouseEvent;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;

    import mx.logging.ILogger;

    import qnx.fuse.ui.buttons.LabelButton;
    import qnx.fuse.ui.core.Action;
    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.layouts.Align;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.listClasses.ScrollDirection;
    import qnx.fuse.ui.navigation.NavigationPaneProperties;
    import qnx.fuse.ui.navigation.TitlePage;
    import qnx.fuse.ui.text.Label;

    public class AboutView extends TitlePage
    {
        private var logger:ILogger;

        public function AboutView()
        {
            super();

            var app_xml:XML = NativeApplication.nativeApplication.applicationDescriptor;
            var ns:Namespace = app_xml.namespace();

            title = "Wydatki - v." + app_xml.ns::versionNumber;

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override protected function init():void
        {
            super.init();

            var prop:NavigationPaneProperties = new NavigationPaneProperties();
            prop.backButton = new Action("Ustawienia");
            paneProperties = prop;
        }

        override protected function onAdded():void
        {
            super.onAdded();

            logger.debug(": onAdded");

            var container:Container = ContainerHelper.createContainer();
            container.scrollDirection = ScrollDirection.VERTICAL;

            var gridData:GridData = new GridData();
            gridData.setOptions(SizeOptions.RESIZE_BOTH);
            container.layoutData = gridData;

            var infoLabel:Label = new Label();
            infoLabel.maxLines = 8;
            infoLabel.text = "Author:\nPaweł Szczepanek\n\n" +
                    "Email:\nblackberry@pauluz.pl\n\n" +
                    "Website:\nhttp://www.pauluz.pl/";

            infoLabel.format = TextFormatUtil.setFormat(infoLabel.format, 45);
            container.addChild(infoLabel);

            var visitBtn:LabelButton = new LabelButton();
            visitBtn.label = "Odwiedź stronę domową";
            visitBtn.addEventListener(MouseEvent.CLICK, onVisitBtnClick);

            var visitBtnGrid:GridData = new GridData();
            visitBtnGrid.setOptions(SizeOptions.RESIZE_HORIZONTAL);
            visitBtnGrid.hAlign = Align.CENTER;
            visitBtnGrid.vAlign = Align.END;
            visitBtnGrid.marginTop = 30;
            visitBtnGrid.marginBottom = 30;
            visitBtn.layoutData = visitBtnGrid;

            container.addChild(visitBtn);

            var descLabel:Label = new Label();
            descLabel.maxLines = 5;
            descLabel.text = "Wydatki to nieoficjalna aplikacja serwisu Kontomierz.pl\n\n" +
                    "Żadne Twoje dane nie są przechwytywane i wysyłane bez Twojej wiedzy.";

            descLabel.format = TextFormatUtil.setFormat(descLabel.format, 35);
            container.addChild(descLabel);

            content = container;

            uDash.recorder.saveMeta(uDash.metaevents.SECTION, "AboutView")
        }

        private static function onVisitBtnClick(event:MouseEvent):void
        {
            navigateToURL(new URLRequest("http://www.pauluz.pl"));
        }
    }
}
