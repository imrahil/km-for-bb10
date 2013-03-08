package com.pauluz.bbapps.kontomierz.services
{
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;

    import qnx.ui.data.SectionDataProvider;

    public interface ISQLKontomierzService
    {
        function saveUserAPIKey(apiKey:String):void
        function loadUserAPIKey():void
        function deleteUserAPIKey():void

        function getAllAccounts():void
        function saveAllAccounts(accountsList:Array):void
        function deleteAccounts():void

        function getAllTransactions(accountId:int, wallet:Boolean):void;
        function getAllTransactionsForCategory(categoryId:int):void;

        function createTransaction(transaction:TransactionVO):void;
        function updateTransaction(transaction:TransactionVO):void;
        function deleteTransaction(id:int, wallet:Boolean):void;

        function saveCategories(categoriesList:SectionDataProvider, direction:String):void;
        function checkOfflineCategories(direction:String):void;
        function loadCategories(direction:String):void;
        function deleteCategories():void;

        function saveCurrencies(currenciesList:Array):void;
        function checkOfflineCurrencies():void;
        function loadCurrencies():void;
        function deleteCurrencies():void;
    }
}
