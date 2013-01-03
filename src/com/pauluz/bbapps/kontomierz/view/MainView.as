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

    import flash.display.Sprite;
    import flash.events.Event;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.dialog.LoginDialog;
    import qnx.fuse.ui.dialog.PasswordChangeDialog;

    public class MainView extends Sprite
    {
        public var loginSignal:Signal = new Signal(UserVO);
        public var registerSignal:Signal = new Signal(UserVO);

        public function addLoginDialog():void
        {
            var loginDialog:LoginDialog = new LoginDialog();
            loginDialog.title = "Logowanie";
            loginDialog.usernamePrompt = "E-mail";
            loginDialog.passwordPrompt = "Hasło";
            loginDialog.rememberMeLabel = "Zapamiętaj mnie";
            loginDialog.addButton("Zaloguj");
            loginDialog.addButton("Załóż konto");
            loginDialog.addEventListener(Event.SELECT, loginDialogClicked);
            loginDialog.show();
        }

        private function loginDialogClicked(event:Event):void
        {
            var loginDialog:LoginDialog = event.target as LoginDialog;

            switch (loginDialog.selectedIndex)
            {
                case 0:
                    var user:UserVO = new UserVO();
                    user.email = StringHelper.trim(loginDialog.username);
                    user.password = StringHelper.trim(loginDialog.password);
                    loginSignal.dispatch(user);

                    break;
                case 1:
                    addRegisterDialog();
                    break;
            }
        }

        private function addRegisterDialog():void
        {
            var registerDialog:PasswordChangeDialog = createRegisterDialog();
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
    }
}
