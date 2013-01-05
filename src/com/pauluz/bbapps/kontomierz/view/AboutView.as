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
    import com.pauluz.bbapps.kontomierz.utils.ContainerHelper;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.utils.TextFormatUtil;

    import flash.desktop.NativeApplication;
    import flash.events.MouseEvent;
    import flash.net.SharedObject;

    import mx.logging.ILogger;

    import qnx.fuse.ui.buttons.LabelButton;
    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.layouts.Align;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
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

            title = "Kontomierz dla BB10 - v." + app_xml.ns::versionNumber;

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override protected function onAdded():void
        {
            super.onAdded();

            logger.debug(": onAdded");

            var container:Container = ContainerHelper.createContainer();

            var gridData:GridData = new GridData();
            gridData.setOptions(SizeOptions.RESIZE_BOTH);
            container.layoutData = gridData;

            var infoLabel:Label = new Label();
            infoLabel.maxLines = 0;
            infoLabel.text = "Author:\nPaweł Szczepanek\n\n" +
                    "Email:\npawel.szczepanek@gmail.com\n\n" +
                    "Website:\nhttp://www.pauluz.pl/";

            infoLabel.format = TextFormatUtil.setFormat(infoLabel.format);
            container.addChild(infoLabel);

            var visitBtn:LabelButton = new LabelButton();
            visitBtn.label = "Visit website";
            visitBtn.addEventListener(MouseEvent.CLICK, onVisitBtnClick);

            var visitBtnGrid:GridData = new GridData();
            visitBtnGrid.setOptions(SizeOptions.RESIZE_BOTH);
            visitBtnGrid.hAlign = Align.CENTER;
            visitBtnGrid.vAlign = Align.END;
            visitBtnGrid.marginTop = 100;
            visitBtn.layoutData = visitBtnGrid;

            container.addChild(visitBtn);

            content = container;
        }

        private static function onVisitBtnClick(event:MouseEvent):void
        {
            // FIXME - zamienic!
//            navigateToURL(new URLRequest("http://www.pauluz.pl"));
            var sessionSO:SharedObject = SharedObject.getLocal(ApplicationConstants.KONTOMIERZ_SO_NAME);
            sessionSO.clear();
        }
    }
}
