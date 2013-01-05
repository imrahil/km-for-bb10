/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view
{
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;

    import mx.logging.ILogger;

    import qnx.fuse.ui.dialog.AlertDialog;
    import qnx.fuse.ui.dialog.PasswordChangeDialog;
    import qnx.fuse.ui.navigation.NavigationPane;

    public class RootView extends Sprite
    {
        private var logger:ILogger;

        private var navigationPane:NavigationPane;

        public function RootView()
        {
            this.addEventListener(Event.ADDED_TO_STAGE, create)

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        private function create(event:Event):void
        {
            logger.debug(": create");

            this.removeEventListener(Event.ADDED_TO_STAGE, create);

            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;

            navigationPane = new NavigationPane();
            addChild(navigationPane);

            navigationPane.width = stage.stageWidth;
            navigationPane.height = stage.stageHeight;

            stage.addEventListener(Event.RESIZE, stageResize);
        }

        private function stageResize(event:Event):void
        {
            logger.debug(": stageResize");

            navigationPane.width = stage.stageWidth;
            navigationPane.height = stage.stageHeight;
        }

        // *******************
        //      MAIN VIEW
        // *******************
        public function addMainView():void
        {
            logger.debug(": addMainView");

            var mainView:MainView = new MainView();
            navigationPane.push(mainView);
        }

        // *******************
        //     LOGIN VIEW
        // *******************
        public function addLoginView(email:String = ""):void
        {
            logger.debug(": addLoginView");

            var loginView:LoginView = new LoginView();
            navigationPane.push(loginView);
        }


        // *******************
        //   register dialog
        // *******************
        public function addRegisterDialog(email:String = ""):void
        {
            logger.debug(": addRegisterDialog");

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
//            var oldRegisterDialog:PasswordChangeDialog = event.target as PasswordChangeDialog;
//            oldRegisterDialog.removeEventListener(Event.SELECT, registerDialogClicked);
//
//            switch (oldRegisterDialog.selectedIndex)
//            {
//                case 0:
//                    var email:String = StringHelper.trim(oldRegisterDialog.username);
//                    var password:String = StringHelper.trim(oldRegisterDialog.password);
//                    var confirmPassword:String = StringHelper.trim(oldRegisterDialog.newPassword);
//
//                    var newRegisterDialog:PasswordChangeDialog = createRegisterDialog();
//
//                    if (!email)
//                    {
//                        newRegisterDialog.errorText = "Proszę podać e-mail!";
//                        newRegisterDialog.password = password;
//                        newRegisterDialog.newPassword = confirmPassword;
//                        newRegisterDialog.show();
//                    }
//                    else if (!StringHelper.checkEmail(email))
//                    {
//                        newRegisterDialog.errorText = "Podany e-mail jest niepoprawny!";
//                        newRegisterDialog.password = password;
//                        newRegisterDialog.newPassword = confirmPassword;
//                        newRegisterDialog.show();
//                    }
//                    else if (!password)
//                    {
//                        newRegisterDialog.errorText = "Proszę podać hasło!";
//                        newRegisterDialog.username = email;
//                        newRegisterDialog.newPassword = confirmPassword;
//                        newRegisterDialog.show();
//                    }
//                    else if (!confirmPassword)
//                    {
//                        newRegisterDialog.errorText = "Proszę podać potwierdzenie hasła!";
//                        newRegisterDialog.username = email;
//                        newRegisterDialog.password = password;
//                        newRegisterDialog.show();
//                    }
//                    else if (password != confirmPassword)
//                    {
//                        newRegisterDialog.errorText = "Podane hasła są różne!";
//                        newRegisterDialog.username = email;
//                        newRegisterDialog.show();
//                    }
//                    else
//                    {
//                        var user:UserVO = new UserVO();
//                        user.email = email;
//                        user.password = password;
//                        user.confirmPassword = confirmPassword;
//
//                        registerSignal.dispatch(user);
//                    }
//
//                    break;
//                case 1:
//                    addLoginView();
//                    break;
//            }
        }

        public function addSpinnerView():void
        {
            logger.debug(":addSpinnerViewr");

            var spinnerView:SpinnerView = new SpinnerView();
            navigationPane.push(spinnerView);
        }

        public function showError(message:String):void
        {
            navigationPane.popAndDelete();

            var errorDialog:AlertDialog = new AlertDialog();
            errorDialog.title = "Błąd";
            errorDialog.message = message;
            errorDialog.addButton("OK");
            errorDialog.show();
        }
    }
}
