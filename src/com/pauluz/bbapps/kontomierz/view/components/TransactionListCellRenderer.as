/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view.components
{
    import com.pauluz.bbapps.kontomierz.model.vo.AccountVO;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;

    import flashx.textLayout.formats.TextAlign;

    import qnx.fuse.ui.listClasses.CellRenderer;
    import qnx.fuse.ui.text.Label;
    import qnx.fuse.ui.text.TextFormat;

    public class TransactionListCellRenderer extends CellRenderer
    {
        private var balance:Label;

        public function TransactionListCellRenderer()
        {
            super();
        }

        override protected function init():void
        {
            super.init();

            if (!this.balance)
            {
                this.balance = new Label();
                this.balance.maxLines = 1;
                this.balance.selectable = false;

                addChild(this.balance);
            }
        }

        override public function set data(value:Object):void
        {
            super.data = value;

            if (value)
            {
                var transaction:TransactionVO = value as TransactionVO;
                this.setLabel(transaction.description);

                if (balance)
                {
                    var balanceLabel:String = transaction.currencyAmount.toString().replace(".", ",");
                    balance.text = balanceLabel + " " + transaction.currencyName;
                }
            }
        }

        override protected function drawLabel(arg1:Number, arg2:Number):void
        {
            super.drawLabel(arg1, arg2);

            this.label.width -= 260;

            this.balance.x = this.label.x + this.label.width;
            this.balance.y = this.label.y;
            this.balance.width = arg1 - (this.label.width + this.paddingLeft + this.paddingRight);
            this.balance.height = this.label.height;
        }

        override protected function setLabelState(arg1:String):void
        {
            super.setLabelState(arg1);

            if (this.label != null)
            {
                var loc1:TextFormat = this.getTextFormatForState(arg1);
                if (loc1 != null)
                {
                    loc1.align = TextAlign.RIGHT;
                    this.balance.format = loc1;
                }
            }
        }
    }
}
