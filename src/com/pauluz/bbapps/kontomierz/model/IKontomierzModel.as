package com.pauluz.bbapps.kontomierz.model
{
    import com.pauluz.bbapps.kontomierz.model.vo.*;

    import qnx.ui.data.DataProvider;

    import qnx.ui.data.SectionDataProvider;

    public interface IKontomierzModel
    {
        function get apiKey():String;
        function set apiKey(value:String):void;

        function get selectedAccount():AccountVO;
        function set selectedAccount(value:AccountVO):void;

        function get accountsList():DataProvider;
        function set accountsList(value:DataProvider):void;

        function get selectedTransaction():TransactionVO;
        function set selectedTransaction(value:TransactionVO):void;

        function get defaultWalletId():int;
        function set defaultWalletId(value:int):void;

        function get walletTransactionsList():DataProvider;
        function set walletTransactionsList(value:DataProvider):void;
        function get isWalletListExpired():Boolean;
        function set isWalletListExpired(value:Boolean):void;

        function get categoriesList():SectionDataProvider;
        function set categoriesList(value:SectionDataProvider):void;

        function get selectedCategory():CategoryVO;
        function set selectedCategory(value:CategoryVO):void;

        function get currenciesList():DataProvider;
        function set currenciesList(value:DataProvider):void;

    }
}
