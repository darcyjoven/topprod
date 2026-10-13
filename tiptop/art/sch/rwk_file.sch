/*
================================================================================
檔案代號:rwk_file
檔案名稱:搭赠/加价购资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rwk_file
(
rwk01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rwk02       varchar2(20) DEFAULT ' ' NOT NULL, /*活动代码*/
rwk03       varchar2(1) DEFAULT ' ' NOT NULL, /*促销哦类型*/
                                     /*Promotion Type 4.Assembly Promotion 6.Full Amount Promotion*/
rwk04       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rwk05       number(5) DEFAULT '0' NOT NULL, /*项次*/
rwk06       varchar2(40),            /*搭赠品号                               */
rwk07       varchar2(1),             /*搭赠方式                               */
                                     /*Gift-Giving Methods 5:Price-Added      */
rwk08       number(15,3),            /*数量                                   */
rwk09       number(20,6),            /*加价金额                               */
rwk10       number(20,6),            /*会员加价金额                           */
rwklegal    varchar2(10) NOT NULL,   /*所属法人                               */
rwkplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table rwk_file add  constraint rwk_pk primary key  (rwk01,rwk02,rwk03,rwk04,rwk05,rwkplant) enable validate;
grant select on rwk_file to tiptopgp;
grant update on rwk_file to tiptopgp;
grant delete on rwk_file to tiptopgp;
grant insert on rwk_file to tiptopgp;
grant index on rwk_file to public;
grant select on rwk_file to ods;
