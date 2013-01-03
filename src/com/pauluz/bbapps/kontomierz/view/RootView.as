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
    import com.pauluz.bbapps.kontomierz.utils.StringHelper;

    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.dialog.AlertDialog;
    import qnx.fuse.ui.dialog.LoginDialog;
    import qnx.fuse.ui.dialog.PasswordChangeDialog;
    import qnx.fuse.ui.layouts.Align;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.layouts.gridLayout.GridLayout;
    import qnx.fuse.ui.progress.ActivityIndicator;

    public class RootView extends Sprite
    {
        public var loginSignal:Signal = new Signal(UserVO);
        public var registerSignal:Signal = new Signal(UserVO);
        public var errorSignal:Signal = new Signal();

        private var spinnerContainer:Container;

        public function RootView()
        {
            this.addEventListener(Event.ADDED_TO_STAGE, create)
        }

        private function create(event:Event):void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, create);

            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.addEventListener(Event.RESIZE, stageResize);
        }

        private function stageResize(event:Event):void
        {
            this.width = stage.stageWidth;
            this.height = stage.stageHeight;
        }

        // *******************
        //   login dialog
        // *******************
        public function addLoginDialog(email:String = ""):void
        {
            var loginDialog:LoginDialog = createLoginDialog();
            loginDialog.username = email;
            loginDialog.show();
        }

        private function createLoginDialog():LoginDialog
        {
            var loginDialog:LoginDialog = new LoginDialog();
            loginDialog.title = "Logowanie";
            loginDialog.usernamePrompt = "E-mail";
            loginDialog.passwordPrompt = "Hasło";
            loginDialog.rememberMeLabel = "Zapamiętaj mnie";
            loginDialog.addButton("Zaloguj");
            loginDialog.addButton("Załóż konto");
            loginDialog.addEventListener(Event.SELECT, loginDialogClicked);

            return loginDialog;
        }

        private function loginDialogClicked(event:Event):void
        {
            var oldLoginDialog:LoginDialog = event.target as LoginDialog;

            switch (oldLoginDialog.selectedIndex)
            {
                case 0:
                    var email:String = StringHelper.trim(oldLoginDialog.username);
                    var password:String = StringHelper.trim(oldLoginDialog.password);

                    var newLoginDialog:LoginDialog = createLoginDialog();

                    if (!email)
                    {
                        newLoginDialog.errorText = "Proszę podać e-mail!";
                        newLoginDialog.password = password;
                        newLoginDialog.show();
                    }
                    else if (!StringHelper.checkEmail(email))
                    {
                        newLoginDialog.errorText = "Podany e-mail jest niepoprawny!";
                        newLoginDialog.password = password;
                        newLoginDialog.show();
                    }
                    else if (!password)
                    {
                        newLoginDialog.errorText = "Proszę podać hasło!";
                        newLoginDialog.username = email;
                        newLoginDialog.show();
                    }
                    else
                    {
                        var user:UserVO = new UserVO();
                        user.email = email;
                        user.password = password;
                        user.rememberMe = oldLoginDialog.rememberMe;

                        loginSignal.dispatch(user);
                    }

                    break;
                case 1:
                    addRegisterDialog();
                    break;
            }
        }

        // *******************
        //   register dialog
        // *******************
        public function addRegisterDialog(email:String = ""):void
        {
            var registerDialog:PasswordChangeDialog = createRegisterDialog();
            registerDialog.username = email;
            registerDialog.show();
        }

        private function createRegisterDialog():PasswordChangeDialog
        {
            var registerDialog:PasswordChangeDialog = new PasswordChangeDialog();
            registerDialog.title = "Rejestracja";
            registerDialog.usernamePrompt = "E-mail";
            registerDialog.passwordPrompt = "Hasło";
            registerDialog.newPasswordPrompt = "Potwierdzenie hasła";
            registerDialog.addButton("Załóż konto");
            registerDialog.addButton("Anuluj");
            registerDialog.addEventListener(Event.SELECT, registerDialogClicked);

            return registerDialog;
        }

        private function registerDialogClicked(event:Event):void
        {
            var oldRegisterDialog:PasswordChangeDialog = event.target as PasswordChangeDialog;
            oldRegisterDialog.removeEventListener(Event.SELECT, registerDialogClicked);

            switch (oldRegisterDialog.selectedIndex)
            {
                case 0:
                    var email:String = StringHelper.trim(oldRegisterDialog.username);
                    var password:String = StringHelper.trim(oldRegisterDialog.password);
                    var confirmPassword:String = StringHelper.trim(oldRegisterDialog.newPassword);

                    var newRegisterDialog:PasswordChangeDialog = createRegisterDialog();

                    if (!email)
                    {
                        newRegisterDialog.errorText = "Proszę podać e-mail!";
                        newRegisterDialog.password = password;
                        newRegisterDialog.newPassword = confirmPassword;
                        newRegisterDialog.show();
                    }
                    else if (!StringHelper.checkEmail(email))
                    {
                        newRegisterDialog.errorText = "Podany e-mail jest niepoprawny!";
                        newRegisterDialog.password = password;
                        newRegisterDialog.newPassword = confirmPassword;
                        newRegisterDialog.show();
                    }
                    else if (!password)
                    {
                        newRegisterDialog.errorText = "Proszę podać hasło!";
                        newRegisterDialog.username = email;
                        newRegisterDialog.newPassword = confirmPassword;
                        newRegisterDialog.show();
                    }
                    else if (!confirmPassword)
                    {
                        newRegisterDialog.errorText = "Proszę podać potwierdzenie hasła!";
                        newRegisterDialog.username = email;
                        newRegisterDialog.password = password;
                        newRegisterDialog.show();
                    }
                    else if (password != confirmPassword)
                    {
                        newRegisterDialog.errorText = "Podane hasła są różne!";
                        newRegisterDialog.username = email;
                        newRegisterDialog.show();
                    }
                    else
                    {
                        var user:UserVO = new UserVO();
                        user.email = email;
                        user.password = password;
                        user.confirmPassword = confirmPassword;

                        registerSignal.dispatch(user);
                    }

                    break;
                case 1:
                    addLoginDialog();
                    break;
            }
        }

        public function addSpinner():void
        {
            this.width = stage.stageWidth;
            this.height = stage.stageHeight;

            spinnerContainer = new Container();
            spinnerContainer.width = stage.stageWidth;
            spinnerContainer.height = stage.stageHeight;

            var s:Sprite = new Sprite();
            var g:Graphics = s.graphics;
            g.beginFill(0x0c151c);
            g.drawRect(0, 0, 10, 10);
            g.endFill();
            spinnerContainer.background = s;

            var layout:GridLayout = new GridLayout();
            layout.hAlign = Align.CENTER;
            layout.vAlign = Align.CENTER;
            spinnerContainer.layout = layout;
            var containerData:GridData = new GridData();
            containerData.hAlign = Align.CENTER;
            spinnerContainer.layoutData = containerData;

            var activityIndicator:ActivityIndicator = new ActivityIndicator();
            var layoutData:GridData = new GridData();
            layoutData.hAlign = Align.CENTER;
            layoutData.vAlign = Align.CENTER;
            activityIndicator.layoutData = layoutData;
            activityIndicator.animate(true);

            spinnerContainer.addChild(activityIndicator);

            this.addChild(spinnerContainer);
        }

        public function showError(message:String):void
        {
            this.removeChild(spinnerContainer);

            var errorDialog:AlertDialog = new AlertDialog();
            errorDialog.title = "Błąd";
            errorDialog.message = message;
            errorDialog.addButton("OK");
            errorDialog.addEventListener(Event.SELECT, errorDialogClicked);
            errorDialog.show();
        }

        private function errorDialogClicked(event:Event):void
        {
            errorSignal.dispatch();
        }

        public function addMainView():void
        {
            if (spinnerContainer && this.contains(spinnerContainer))
            {
                this.removeChild(spinnerContainer);
            }

            var mainView:MainView = new MainView();
            this.addChild(mainView);
        }
    }
}
