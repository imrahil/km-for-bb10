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
    import com.pauluz.bbapps.kontomierz.model.vo.UserVO;
    import com.pauluz.bbapps.kontomierz.utils.ContainerHelper;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.pauluz.bbapps.kontomierz.utils.StringHelper;
    import com.pauluz.bbapps.kontomierz.utils.TextFormatUtil;

    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.ui.Keyboard;

    import mx.logging.ILogger;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.buttons.CheckBox;
    import qnx.fuse.ui.buttons.LabelButton;
    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.layouts.gridLayout.GridLayout;
    import qnx.fuse.ui.listClasses.ScrollDirection;
    import qnx.fuse.ui.navigation.TitlePage;
    import qnx.fuse.ui.skins.SkinStates;
    import qnx.fuse.ui.text.KeyboardType;
    import qnx.fuse.ui.text.Label;
    import qnx.fuse.ui.text.ReturnKeyType;
    import qnx.fuse.ui.text.TextInput;

    public class LoginView extends TitlePage
    {
        private var logger:ILogger;

        public var loginSignal:Signal = new Signal(UserVO);

        private var emailTextInput:TextInput;
        private var passwordTextInput:TextInput;
        private var rememberMeCheckbox:CheckBox;
        private var errorLabel:Label;

        public function LoginView()
        {
            super();

            title = "Logowanie";

            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        override protected function onAdded():void
        {
            super.onAdded();

            logger.debug(": onAdded");

            var textLabel:Label;
            var gridDataHolder:GridData;
            var labelButton:LabelButton;

            var container:Container = ContainerHelper.createContainer();
            container.scrollDirection = ScrollDirection.VERTICAL;

            var gridData:GridData = new GridData();
            gridData.setOptions(SizeOptions.RESIZE_BOTH);
            container.layoutData = gridData;

            // LABEL EMAIL
            textLabel = new Label();
            textLabel.text = "E-mail:";
            textLabel.format = TextFormatUtil.setFormat(textLabel.format);
            container.addChild(textLabel);

            // INPUT EMAIL
            emailTextInput = new TextInput();
            emailTextInput.prompt = "Podaj swój e-mail";
            emailTextInput.spellCheck = false;
            emailTextInput.autoCorrect = false;
            emailTextInput.softKeyboardType = KeyboardType.EMAIL;
            emailTextInput.returnKeyLabel = ReturnKeyType.NEXT;
            emailTextInput.addEventListener(KeyboardEvent.KEY_UP, onEmailKeyUp);
            container.addChild(emailTextInput);

            // LABEL HASŁO
            textLabel = new Label();
            textLabel.text = "Hasło:";
            textLabel.format = TextFormatUtil.setFormat(textLabel.format);
            container.addChild(textLabel);

            // INPUT HASŁO
            passwordTextInput = new TextInput();
            passwordTextInput.prompt = "Podaj swoje hasło";
            passwordTextInput.displayAsPassword = true;
            passwordTextInput.spellCheck = false;
            passwordTextInput.autoCorrect = false;
            passwordTextInput.softKeyboardType = KeyboardType.PASSWORD;
            passwordTextInput.returnKeyLabel = ReturnKeyType.SUBMIT;
            passwordTextInput.addEventListener(KeyboardEvent.KEY_UP, onPasswordKeyUp);
            container.addChild(passwordTextInput);

            // CHECKBOX ZAPAMIETAJ MNIE
            var checkboxContainer:Container = new Container();
            checkboxContainer.layout = new GridLayout();
            rememberMeCheckbox = new CheckBox();
            rememberMeCheckbox.label = "Zapamiętaj mnie";
            rememberMeCheckbox.paddingLeft = 15;
            rememberMeCheckbox.setTextFormatForState(TextFormatUtil.setFormat(textLabel.format), SkinStates.UP);
            rememberMeCheckbox.setTextFormatForState(TextFormatUtil.setFormat(textLabel.format), SkinStates.DOWN);
            rememberMeCheckbox.setTextFormatForState(TextFormatUtil.setFormat(textLabel.format), SkinStates.SELECTED);
            rememberMeCheckbox.setTextFormatForState(TextFormatUtil.setFormat(textLabel.format), SkinStates.DOWN_SELECTED);
            checkboxContainer.addChild(rememberMeCheckbox);
            container.addChild(checkboxContainer);

            // ERROR LABEL
            errorLabel = new Label();
            errorLabel.format = TextFormatUtil.setErrorFormat(textLabel.format);
            container.addChild(errorLabel);

            // LAYOUT DLA PRZYCISKOW
            var buttonsGrid:GridLayout = new GridLayout();
            buttonsGrid.numColumns = 3;
            buttonsGrid.paddingTop = 10;
            buttonsGrid.hSpacing = 20;
            var buttonsContainer:Container = new Container();
            buttonsContainer.layout = buttonsGrid;

            // button ZALOGUJ
            labelButton = new LabelButton();
            labelButton.label = "Zaloguj";
            gridDataHolder = new GridData();
            gridDataHolder.setOptions(SizeOptions.RESIZE_HORIZONTAL);
            labelButton.layoutData = gridDataHolder;
            labelButton.addEventListener(MouseEvent.CLICK, onZalogujClick);
            buttonsContainer.addChild(labelButton);

            // button ZALOZ KONTO
            labelButton = new LabelButton();
            labelButton.label = "Załóż konto";
            labelButton.enabled = false;
            gridDataHolder = new GridData();
            gridDataHolder.setOptions(SizeOptions.RESIZE_HORIZONTAL);
            labelButton.layoutData = gridDataHolder;
            buttonsContainer.addChild(labelButton);

            // button DEMO
            labelButton = new LabelButton();
            labelButton.label = "Demo";
            gridDataHolder = new GridData();
            labelButton.layoutData = gridDataHolder;
            gridDataHolder.setOptions(SizeOptions.RESIZE_HORIZONTAL);
            labelButton.addEventListener(MouseEvent.CLICK, onDemoClick);
            buttonsContainer.addChild(labelButton);

            container.addChild(buttonsContainer);

            content = container;
        }

        private function onEmailKeyUp(event:KeyboardEvent):void
        {
            if (event.keyCode == Keyboard.ENTER)
            {
                stage.focus = passwordTextInput;
            }
        }

        private function onPasswordKeyUp(event:KeyboardEvent):void
        {
            if (event.keyCode == Keyboard.ENTER)
            {
                stage.focus = null;

                zaloguj();
            }
        }

        private function onZalogujClick(event:MouseEvent):void
        {
            zaloguj();
        }

        private function onDemoClick(event:MouseEvent):void
        {
            var user:UserVO = new UserVO();
            user.email = ApplicationConstants.KONTOMIERZ_DEMO_EMAIL;

            loginSignal.dispatch(user);
        }

        private function zaloguj():void
        {
            var email:String = StringHelper.trim(emailTextInput.text);
            var password:String = StringHelper.trim(passwordTextInput.text);

            if (!email)
            {
                errorLabel.text = "Proszę podać e-mail!";
            }
            else if (!StringHelper.checkEmail(email))
            {
                errorLabel.text = "Podany e-mail jest niepoprawny!";
            }
            else if (!password)
            {
                errorLabel.text = "Proszę podać hasło!";
            }
            else
            {
                errorLabel.text = "";

                var user:UserVO = new UserVO();
                user.email = email;
                user.password = password;
                user.rememberMe = rememberMeCheckbox.selected;

                loginSignal.dispatch(user);

                emailTextInput.text = "";
                passwordTextInput.text = "";
            }
        }
    }
}
