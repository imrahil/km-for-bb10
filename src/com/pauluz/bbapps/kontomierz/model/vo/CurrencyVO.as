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
     * Defines the <code>CurrencyVO<code> Value Object implementation
     *
     */
    [Bindable]
    public class CurrencyVO extends ListDialogBaseVO
    {
        public var id:int;
        public var name:String;
        public var fullName:String;

        public function get label():String
        {
            return this.name + " - " + this.fullName;
        }
    }
}
