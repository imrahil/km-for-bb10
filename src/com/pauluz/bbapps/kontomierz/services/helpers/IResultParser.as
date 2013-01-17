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
    import qnx.ui.data.SectionDataProvider;

    public interface IResultParser
    {
        function parseLoginRegisterResponse(result:String):String;

        function parseAllAccountsResponse(result:String):DataProvider;
        function parseAllAccountsResponseAndFindDefaultWalletId(result:String):int;
        function parseAllTransactionsResponse(result:String):DataProvider;
        function parseAllCategoriesResponse(result:String):SectionDataProvider;
        function parseAllCurrenciesResponse(result:String):DataProvider;
    }
}
