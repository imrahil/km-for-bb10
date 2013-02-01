/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.constants
{
    public class ApplicationConstants
    {
        public static const KONTOMIERZ_API_ENDPOINT:String = "https://kontomierz.pl/k4/";
        public static const KONTOMIERZ_API_FORMAT_JSON:String = ".json";
        public static const KONTOMIERZ_API_FORMAT_XML:String = ".xml";

        public static const KONTOMIERZ_SO_NAME:String = "kontomierzApiKeySharedObject";

        public static const LOGIN_STATUS_NEW:String         = "userLoggedOut";
        public static const LOGIN_STATUS_REMEMBERED:String  = "userRemembered";

        public static const DIALOG_TYPE_LOGIN:String  = "dialogTypeLogin";
        public static const DIALOG_TYPE_REGISTER:String  = "dialogTypeRegister";

        public static const WALLET_ACCOUNT_NAME:String  = "Wallets";

        public static const TRANSACTION_DIRECTION_WITHDRAWAL:String  = "withdrawal";
        public static const TRANSACTION_DIRECTION_DEPOSIT:String  = "deposit";

        public static const NO_CATEGORY_LABEL:String  = "-- brak kategorii --";

        public static const DEFAULT_CURRENCY_NAME:String  = "PLN";
        public static const DEFAULT_CURRENCY_FULL_NAME:String  = "złoty polski";

    }
}
