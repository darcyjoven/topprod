/*
================================================================================
檔案代號:rwc_file
檔案名稱:商品特价单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rwc_file
(
rwc01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rwc02       varchar2(20) DEFAULT ' ' NOT NULL, /*活动代码*/
rwc03       varchar2(1) DEFAULT ' ' NOT NULL, /*促销哦类型*/
                                     /*Promotion Type                         */
                                     /*1:Special Product Price 2:Special Brand Class.  Price 3:Special Price-Interval Price*/
rwc04       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rwc05       number(5) DEFAULT '0' NOT NULL, /*项次*/
rwc06       varchar2(40),            /*产品编号                               */
rwc07       varchar2(4),             /*库存单位                               */
rwc08       varchar2(40),            /*产品条码                               */
rwc09       varchar2(4),             /*促销单位                               */
rwc10       number(16,8),            /*换算率                                 */
                                     /*Conversion Rate - Promotion Unit: Stock Unit*/
rwc11       varchar2(1),             /*特价方式                               */
                                     /*Price Preference Method 1:Promotion 2:Discount*/
rwc12       number(5,2),             /*折扣率%                                */
rwc13       number(20,6),            /*特卖价                                 */
rwc14       number(5,2),             /*会员折扣率                             */
rwc15       number(20,6),            /*会员特卖价                             */
rwc16       varchar2(1),             /*依会员等级促销                         */
rwc17       number(5,2),             /*最低折价扣率                           */
rwc18       number(20,6),            /*最低特卖价                             */
rwc19       date,                    /*促销开始日期                           */
rwc20       date,                    /*促销结束日期                           */
rwc21       varchar2(8),             /*促销开始时间                           */
rwc22       varchar2(8),             /*促销结束时间                           */
rwc23       varchar2(255),           /*备注                                   */
rwc24       varchar2(1),             /*有效否                                 */
rwclegal    varchar2(10) NOT NULL,   /*所属法人                               */
rwcplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rwcpos      varchar2(1)              /*已传POS否                              */
);

alter table rwc_file add  constraint rwc_pk primary key  (rwc01,rwc02,rwc03,rwc04,rwc05,rwcplant) enable validate;
grant select on rwc_file to tiptopgp;
grant update on rwc_file to tiptopgp;
grant delete on rwc_file to tiptopgp;
grant insert on rwc_file to tiptopgp;
grant index on rwc_file to public;
grant select on rwc_file to ods;
