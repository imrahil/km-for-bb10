/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.services.helpers
{
    import qnx.ui.data.DataProvider;

    public interface IResultParser
    {
        function parseLoginRegisterResponse(result:String):String;

        function parseAllAccountsResponse(result:String):DataProvider;
        function parseAllTransactionsResponse(result:String):DataProvider;
    }
}
