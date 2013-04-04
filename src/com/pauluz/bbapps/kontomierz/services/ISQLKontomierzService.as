package com.pauluz.bbapps.kontomierz.services
{
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;

    import qnx.ui.data.SectionDataProvider;

    public interface ISQLKontomierzService
    {
        function loadUserAPIKey():void
        function saveUserAPIKey(apiKey:String):void

        function getAllAccounts():void
        function saveAllAccounts(accountsList:Array):void

        function getAllTransactions(accountId:int):void;
        function getAllWalletTransactions():void;
        function getAllTransactionsForCategory(categoryId:int):void;
        function saveAllTransactions(accountId:int, transactionsList:Array, isWallet:Boolean):void;

        function checkSyncStatus():void;
        function syncOfflineChanges():void;

        function createTransaction(transaction:TransactionVO):void;
        function updateTransaction(transaction:TransactionVO):void;
        function deleteTransaction(id:int, wallet:Boolean):void;

        function deleteSyncDeletedTransaction(id:int):void;
        function deleteSyncInsertTransaction(id:int):void;
        function deleteSyncUpdatedTransaction(id:int):void;

        function saveCategories(categoriesList:SectionDataProvider, direction:String):void;
        function loadCategories(direction:String):void;
        function loadUsedCategories():void;

        function saveCurrencies(currenciesList:Array):void;
        function loadCurrencies():void;

        function deleteOnLogout():void;
    }
}
