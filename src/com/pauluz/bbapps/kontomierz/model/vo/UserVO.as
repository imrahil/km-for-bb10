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
     * Defines the <code>UserVO<code> Value Object implementation
     *
     */
    [Bindable]
    public class UserVO
    {
        public var email:String;
        public var password:String;
        public var confirmPassword:String;
    }
}
