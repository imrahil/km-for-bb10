package com.pauluz.bbapps.kontomierz.model
{
    import com.pauluz.bbapps.kontomierz.model.vo.*;

    import qnx.ui.data.DataProvider;

    import qnx.ui.data.SectionDataProvider;

    public interface IKontomierzModel
    {
        function get isConnected():Boolean;
        function set isConnected(value:Boolean):void;

        function get demoMode():Boolean;
        function set demoMode(value:Boolean):void;

        function get rememberMe():Boolean;
        function set rememberMe(value:Boolean):void;

        function get apiKey():String;
        function set apiKey(value:String):void;

        function get selectedAccount():AccountVO;
        function set selectedAccount(value:AccountVO):void;

        function get defaultWallet():AccountVO;
        function set defaultWallet(value:AccountVO):void;

        function get accountsList():DataProvider;
        function set accountsList(value:DataProvider):void;

        function get selectedTransaction():TransactionVO;
        function set selectedTransaction(value:TransactionVO):void;

        function get walletTransactionsList():DataProvider;
        function set walletTransactionsList(value:DataProvider):void;

        function get withdrawalCategoriesList():SectionDataProvider;
        function set withdrawalCategoriesList(value:SectionDataProvider):void;

        function get depositCategoriesList():SectionDataProvider;
        function set depositCategoriesList(value:SectionDataProvider):void;

        function get selectedCategory():CategoryVO;
        function set selectedCategory(value:CategoryVO):void;

        function get currenciesList():Array;
        function set currenciesList(value:Array):void;

    }
}
