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
        public var balance:Number = 0;
        public var bank_name:String;
        public var bank_plugin_name:String;
        public var currency_balance:Number = 0;
        public var currency_name:String;
        public var display_name:String;
        public var iban:String;
        public var iban_checksum:String;
        public var is_default_wallet:Boolean;
    }
}
