/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.model.vo
{
    /**
     *
     * Defines the <code>AccountVO<code> Value Object implementation
     *
     */
    [Bindable]
    public class AccountVO
    {
        public var id:int;
        public var accountId:int;
        public var balance:Number = 0;
        public var bankName:String = "";
        public var bankPluginName:String = "";
        public var currencyBalance:Number = 0;
        public var currencyName:String = "";
        public var displayName:String = "";
        public var iban:String = "";
        public var ibanChecksum:String = "";
        public var is_default_wallet:Boolean;

        public var isValid:Boolean;
    }
}
