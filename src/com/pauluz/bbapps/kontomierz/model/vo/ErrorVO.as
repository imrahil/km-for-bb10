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
        public var email:String;
        public var dialogType:String;

        public function ErrorVO(message:String, email:String, dialogType:String)
        {
            this.message = message;
            this.email = email;
            this.dialogType = dialogType;
        }
    }
}
