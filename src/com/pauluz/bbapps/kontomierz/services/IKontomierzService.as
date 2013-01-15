/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.services
{
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.model.vo.UserVO;

    public interface IKontomierzService
    {
        function login(user:UserVO):void;
        function register(user:UserVO):void;

        function getAllAccounts():void

        function createWallet(name:String, balance:Number, currency:String, liquid:Boolean):void
        function updateWallet(id:int, name:String, balance:Number, currency:String, liquid:Boolean):void
        function deleteWallet(id:int):void

        function getAllTransactions(accountId:int, wallet:Boolean):void;
        function getAllTransactionsForCategory(categoryId:int):void;

        function createTransaction(transaction:TransactionVO):void;
//        function updateTransaction(id:int, ...):void;
        function deleteTransaction(id:int, wallet:Boolean):void;

        function getAllCategories():void;
//        function getAllTags():void;

    }
}
