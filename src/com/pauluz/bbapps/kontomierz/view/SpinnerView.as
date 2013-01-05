/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view
{
    import com.pauluz.bbapps.kontomierz.model.vo.UserVO;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import flash.display.Graphics;
    import flash.display.Sprite;

    import mx.logging.ILogger;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.buttons.CheckBox;
    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.layouts.Align;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.layouts.gridLayout.GridLayout;
    import qnx.fuse.ui.navigation.Page;
    import qnx.fuse.ui.progress.ActivityIndicator;
    import qnx.fuse.ui.text.Label;
    import qnx.fuse.ui.text.TextInput;

    public class SpinnerView extends Page
    {
        private var logger:ILogger;

        public var loginSignal:Signal = new Signal(UserVO);

        private var emailTextInput:TextInput;
        private var passwordTextInput:TextInput;
        private var rememberMeCheckbox:CheckBox;
        private var errorLabel:Label;

        public function SpinnerView():void
        {
            super();

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override protected function onAdded():void
        {
            super.onAdded();

            logger.debug(": onAdded");

            var container:Container = new Container();

            var s:Sprite = new Sprite();
            var g:Graphics = s.graphics;
            g.beginFill(0x0c151c);
            g.drawRect(0, 0, 10, 10);
            g.endFill();

            container.background = s;

            var layout:GridLayout = new GridLayout();
            layout.hAlign = Align.CENTER;
            layout.vAlign = Align.CENTER;
            container.layout = layout;
            var containerData:GridData = new GridData();
            containerData.hAlign = Align.CENTER;
            container.layoutData = containerData;

            var activityIndicator:ActivityIndicator = new ActivityIndicator();
            var layoutData:GridData = new GridData();
            layoutData.hAlign = Align.CENTER;
            layoutData.vAlign = Align.CENTER;
            activityIndicator.layoutData = layoutData;
            activityIndicator.animate(true);

            container.addChild(activityIndicator);

            content = container;
        }
    }
}
