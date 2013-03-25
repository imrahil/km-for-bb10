/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.services
{
    import com.destroytoday.core.IPromise;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.model.vo.UserVO;

    public interface IKontomierzService
    {
        function login(user:UserVO):IPromise;
        function register(user:UserVO):IPromise;

        function getAllAccounts():IPromise

//        function createWallet(name:String, balance:Number, currency:String, liquid:Boolean):void
//        function updateWallet(id:int, name:String, balance:Number, currency:String, liquid:Boolean):void
//        function deleteWallet(id:int):void

        function getAllTransactions(accountId:int):IPromise;
        function getAllWalletTransactions():IPromise;
        function getAllTransactionsForCategory(categoryId:int):IPromise;

        function createTransaction(transaction:TransactionVO):IPromise;
        function updateTransaction(transaction:TransactionVO):IPromise;
        function deleteTransaction(id:int, wallet:Boolean):IPromise;

        function getAllWithdrawalCategories():IPromise;
        function getAllDepositCategories():IPromise;
//        function getAllTags():void;
        function getAllCurrencies():IPromise;
    }
}
