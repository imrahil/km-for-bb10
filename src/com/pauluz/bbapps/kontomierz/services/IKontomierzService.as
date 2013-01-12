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

        function getAllAccounts(apiKey:String):void

        function createWallet(name:String, balance:Number, currency:String, liquid:Boolean, apiKey:String):void
        function updateWallet(id:int, name:String, balance:Number, currency:String, liquid:Boolean, apiKey:String):void
        function deleteWallet(id:int, apiKey:String):void

        function getAllTransactions(accountId:int, apiKey:String):void;
        function getAllTransactionsForCategory(categoryId:int, apiKey:String):void;

//        function createTransaction(...):void;
//        function updateTransaction(id:int, ...):void;
//        function deleteTransaction(id:int):void;

        function getAllCategories(apiKey:String):void;
//        function getAllTags():void;

    }
}
