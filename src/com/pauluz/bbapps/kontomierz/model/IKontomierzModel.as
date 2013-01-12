package com.pauluz.bbapps.kontomierz.model
{
    import com.pauluz.bbapps.kontomierz.model.vo.AccountVO;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;

    public interface IKontomierzModel
    {
        function get apiKey():String;
        function set apiKey(value:String):void;

        function get selectedAccount():AccountVO;
        function set selectedAccount(value:AccountVO):void;

        function get selectedTransaction():TransactionVO;
        function set selectedTransaction(value:TransactionVO):void;

        function get defaultWalletId():int;
        function set defaultWalletId(value:int):void;
    }
}
