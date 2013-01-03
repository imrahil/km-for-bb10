/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.services
{
    import com.pauluz.bbapps.kontomierz.model.vo.UserVO;

    public interface IKontomierzService
    {
        function login(user:UserVO):void;
        function register(user:UserVO):void;
    }
}
