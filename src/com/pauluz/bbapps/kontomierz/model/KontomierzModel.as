/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.model
{
    import com.pauluz.bbapps.kontomierz.model.vo.AccountVO;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;

    import org.robotlegs.mvcs.*;

    public class KontomierzModel extends Actor implements IKontomierzModel
    {
        private var _apiKey:String = "";
        private var _selectedAccount:AccountVO;
        private var _selectedTransaction:TransactionVO;

        public function get apiKey():String
        {
            return _apiKey;

            // DEMO USER
//            return "e7cOI9zZTbprBddSHHnlniLsAvzBpfhqTIjeUid2be0fjb2REaWnudZqGSgxz1Lz";;
        }

        public function set apiKey(value:String):void
        {
            _apiKey = value;
        }

        public function get selectedAccount():AccountVO
        {
            return _selectedAccount;
        }

        public function set selectedAccount(value:AccountVO):void
        {
            _selectedAccount = value;
        }

        public function get selectedTransaction():TransactionVO
        {
            return _selectedTransaction;
        }

        public function set selectedTransaction(value:TransactionVO):void
        {
            _selectedTransaction = value;
        }
    }
}
