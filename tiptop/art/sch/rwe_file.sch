/*
================================================================================
檔案代號:rwe_file
檔案名稱:价格区间单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rwe_file
(
rwe01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rwe02       varchar2(20) DEFAULT ' ' NOT NULL, /*活动代码*/
rwe03       varchar2(1) DEFAULT ' ' NOT NULL, /*促销哦类型*/
                                     /*Promotion Type                         */
                                     /*1:Special Product Price 2:Special Brand Class.  Price 3:Special Price-Interval Price*/
rwe04       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rwe05       number(5) DEFAULT '0' NOT NULL, /*项次*/
rwe06       number(20,6) DEFAULT '0' NOT NULL, /*起始价格*/
rwe07       number(20,6) DEFAULT '0' NOT NULL, /*截止价格*/
rwe08       varchar2(1) DEFAULT ' ' NOT NULL, /*特价方式*/
                                     /*Price Preference Method 1:Promotion 2:Discount 3:Discount Amt*/
rwe09       number(5,2) DEFAULT '0' NOT NULL, /*折扣*/
rwe10       number(5,2) DEFAULT '0' NOT NULL, /*会员折扣*/
rwe11       number(20,6) DEFAULT '0' NOT NULL, /*折价*/
rwe12       number(20,6) DEFAULT '0' NOT NULL, /*会员折价*/
rwe13       varchar2(1) DEFAULT 'N' NOT NULL, /*依会员等级促销*/
rwe14       date,                    /*促销开始日期                           */
rwe15       date,                    /*促销结束日期                           */
rwe16       varchar2(8),             /*促销开始时间                           */
rwe17       varchar2(8),             /*促销结束时间                           */
rwe18       varchar2(255),           /*备注                                   */
rwe19       varchar2(1) DEFAULT 'N' NOT NULL, /*有效否*/
rwelegal    varchar2(10) NOT NULL,   /*所属法人                               */
rweplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rwepos      varchar2(1) DEFAULT 'N' NOT NULL /*已传POS否*/
);

alter table rwe_file add  constraint rwe_pk primary key  (rwe01,rwe02,rwe03,rwe04,rwe05,rweplant) enable validate;
grant select on rwe_file to tiptopgp;
grant update on rwe_file to tiptopgp;
grant delete on rwe_file to tiptopgp;
grant insert on rwe_file to tiptopgp;
grant index on rwe_file to public;
grant select on rwe_file to ods;
