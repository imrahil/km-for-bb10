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
     * Defines the <code>ErrorVO<code> Value Object implementation
     *
     */
    [Bindable]
    public class ErrorVO
    {
        public var message:String;
        public var popScreen:Boolean;

        public function ErrorVO(message:String, popScreen:Boolean = false)
        {
            this.message = message;
            this.popScreen = popScreen;
        }
    }
}
