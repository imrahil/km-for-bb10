package com.pauluz.bbapps.kontomierz.services
{
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;

    public interface ISQLKontomierzService
    {
        function getAllAccounts():void

        function getAllTransactions(accountId:int, wallet:Boolean):void;
        function getAllTransactionsForCategory(categoryId:int):void;

        function createTransaction(transaction:TransactionVO):void;
        function updateTransaction(transaction:TransactionVO):void;
        function deleteTransaction(id:int, wallet:Boolean):void;

        function getAllWithdrawalCategories():void;
        function getAllDepositCategories():void;
        function getAllCurrencies():void;
    }
}
