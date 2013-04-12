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
    import com.pauluz.bbapps.kontomierz.model.vo.CategoryVO;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;

    import org.robotlegs.mvcs.*;

    import qnx.ui.data.DataProvider;
    import qnx.ui.data.SectionDataProvider;

    public class KontomierzModel extends Actor implements IKontomierzModel
    {
        private var _isConnected:Boolean;

        private var _demoMode:Boolean;
        private var _rememberMe:Boolean;

        private var _apiKey:String = "";
        private var _selectedAccount:AccountVO;
        private var _defaultWallet:AccountVO;
        private var _accountsList:DataProvider;

        private var _selectedTransaction:TransactionVO;

        private var _walletTransactionsList:DataProvider;

        private var _withdrawalCategoriesList:SectionDataProvider;
        private var _depositCategoriesList:SectionDataProvider;
        private var _selectedCategory:CategoryVO;

        private var _currenciesList:Array;

        private var _syncRequired:Boolean;
        private var _syncInProgress:Boolean;
        private var _totalSyncCount:int;

        public function get isConnected():Boolean
        {
            return _isConnected;
        }

        public function set isConnected(value:Boolean):void
        {
            _isConnected = value;
        }

        public function get demoMode():Boolean
        {
            return _demoMode;
        }

        public function set demoMode(value:Boolean):void
        {
            _demoMode = value;
        }

        public function get rememberMe():Boolean
        {
            return _rememberMe;
        }

        public function set rememberMe(value:Boolean):void
        {
            _rememberMe = value;
        }

        public function get apiKey():String
        {
            return _apiKey;
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

        public function get defaultWallet():AccountVO
        {
            return _defaultWallet;
        }

        public function set defaultWallet(value:AccountVO):void
        {
            _defaultWallet = value;
        }

        public function get accountsList():DataProvider
        {
            return _accountsList;
        }

        public function set accountsList(value:DataProvider):void
        {
            _accountsList = value;
        }

        public function get selectedTransaction():TransactionVO
        {
            return _selectedTransaction;
        }

        public function set selectedTransaction(value:TransactionVO):void
        {
            _selectedTransaction = value;
        }

        public function get walletTransactionsList():DataProvider
        {
            return _walletTransactionsList;
        }

        public function set walletTransactionsList(value:DataProvider):void
        {
            _walletTransactionsList = value;
        }

        public function get withdrawalCategoriesList():SectionDataProvider
        {
            return _withdrawalCategoriesList;
        }

        public function set withdrawalCategoriesList(value:SectionDataProvider):void
        {
            _withdrawalCategoriesList = value;
        }

        public function get depositCategoriesList():SectionDataProvider
        {
            return _depositCategoriesList;
        }

        public function set depositCategoriesList(value:SectionDataProvider):void
        {
            _depositCategoriesList = value;
        }

        public function get selectedCategory():CategoryVO
        {
            return _selectedCategory;
        }

        public function set selectedCategory(value:CategoryVO):void
        {
            _selectedCategory = value;
        }

        public function get currenciesList():Array
        {
            return _currenciesList;
        }

        public function set currenciesList(value:Array):void
        {
            _currenciesList = value;
        }

        public function get syncRequired():Boolean
        {
            return _syncRequired;
        }

        public function set syncRequired(value:Boolean):void
        {
            _syncRequired = value;
        }

        public function get syncInProgress():Boolean
        {
            return _syncInProgress;
        }

        public function set syncInProgress(value:Boolean):void
        {
            _syncInProgress = value;
        }

        public function get totalSyncCount():int
        {
            return _totalSyncCount;
        }

        public function set totalSyncCount(value:int):void
        {
            _totalSyncCount = value;
        }
    }
}
