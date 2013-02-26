package com.pauluz.bbapps.kontomierz.view.components
{
    import flash.events.Event;

    import qnx.fuse.ui.picker.Picker;
    import qnx.ui.data.DataProvider;

    public class DatePicker extends Picker
    {
        public function DatePicker(years_back:int = 2)
        {
            super();

            // year col
            var yearArr:Array = [];
            var monthsArr:Array = [
                { data: 1, label: 'Sty' },
                { data: 2, label: 'Lut' },
                { data: 3, label: 'Mar' },
                { data: 4, label: 'Kwi' },
                { data: 5, label: 'Maj' },
                { data: 6, label: 'Cze' },
                { data: 7, label: 'Lip' },
                { data: 8, label: 'Sie' },
                { data: 9, label: 'Wrz' },
                { data: 10, label: 'Paź' },
                { data: 11, label: 'Lis' },
                { data: 12, label: 'Gru' }
            ];
            var dateArr:Array = [];
            var today:Date = new Date();
            var yr:int;

            for (yr = today.fullYear; yr >= today.fullYear - years_back; yr--)
            {
                yearArr.push({data: yr, label: yr});
            }

            var day:int;
            for (day = 1; day <= 31; day++)
            {
                dateArr.push({ data: day, label: day });
            }

            this.dataProvider = new DataProvider([new DataProvider(yearArr), new DataProvider(monthsArr), new DataProvider(dateArr)]);

            this.valueFunction = dateDisplay;

            this.addEventListener(Event.SELECT, itemSelected);
        }

        private function dateDisplay(items:Array):String
        {
            var monthNumber:int = items[1]['data'];
            var monthNumberString:String = (monthNumber < 10) ? "0" + monthNumber.toString() : monthNumber.toString();

            var dayNumber:int = items[2]['label'];
            var dayNumberString:String = (dayNumber < 10) ? "0" + dayNumber.toString() : dayNumber.toString();

            return items[0]['label'] + '-' + monthNumberString + '-' + dayNumberString;
        }

        public function setDateIndex(year:int, month:int, date:int):void
        {
            var yrdata:DataProvider = this.getItemAt(0) as DataProvider;
            var modata:DataProvider = this.getItemAt(1) as DataProvider;
            var dtdata:DataProvider = this.getItemAt(2) as DataProvider;
            var item:Object;
            var yridx:int = 0;
            var moidx:int = 0;
            var dtidx:int = 0;
            var count:int;

            count = 0;
            for each(item in yrdata.data)
            {
                if (item.data == year)
                {
                    yridx = count;
                    break;
                }
                count++;
            }

            count = 0;
            for each(item in modata.data)
            {
                if (item.data == month)
                {
                    moidx = count;
                    break;
                }
                count++;
            }

            count = 0;
            for each(item in dtdata.data)
            {
                if (item.data == date)
                {
                    dtidx = count;
                    break;
                }
                count++;
            }

            this.selectedIndices = [yridx, moidx, dtidx];
        }

        public function setDate(value:Date):void
        {
            this.setDateIndex(value.fullYear, value.month + 1, value.date);
        }

        public function setDateFromString(value:String):void
        {
            var dateArr:Array = value.split("-");
            var newDate:Date = new Date(parseInt(dateArr[0]), parseInt(dateArr[1]) - 1, parseInt(dateArr[2]));

            this.setDateIndex(newDate.fullYear, newDate.month, newDate.date);
        }

        public final function get year():int
        {
            var ar:Array = this.selectedItems;
            return ar[0].data;
        }

        public final function get month():int
        {
            var ar:Array = this.selectedItems;
            return ar[1].data;
        }

        public final function get date():int
        {
            var ar:Array = this.selectedItems;
            return ar[2].data;
        }

        private function itemSelected(event:Event):void
        {
            var ar:Array = this.selectedItems;
            var yr:int = ar[0].data;
            var mo:int = ar[1].data;
            var dt:int = ar[2].data;

            //trace( 'item selected ' + yr + ' ' + mo + ' ' + dt );

            var date:Date = new Date(yr, mo - 1, 1);
            // advance 1 month
            if (date.month < 11)
                date.month++;
            else
                date.month = 0;

            // back a day
            date.time = date.time - (1000 * 60 * 60 * 24 );

            // date will be the number of days in that month
            //trace( 'max ' + date.date );

            var d:int;
            var maxd:int = date.date;
            var newdates:Array = [];
            for (d = 1; d <= maxd; d++)
            {
                newdates.push({ data: d, label: d });
            }
            this.replaceItemAt(new DataProvider(newdates), 2);

            if (dt > maxd)dt = maxd;

            this.setDateIndex(yr, mo, dt);
        }
    }
}
