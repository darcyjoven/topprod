/*
================================================================================
檔案代號:rwj_file
檔案名稱:满额促销单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rwj_file
(
rwj01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rwj02       varchar2(20) DEFAULT ' ' NOT NULL, /*活动代码*/
rwj03       varchar2(1) DEFAULT ' ' NOT NULL, /*促销哦类型*/
                                     /*Promotion Type                         */
                                     /*1:Special Product Price 2:Special Brand Class.  Price 3:Special Price-Interval Price 6.Full Amount Promotion 9.Rebate Promotion*/
rwj04       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rwj05       number(5) DEFAULT '0' NOT NULL, /*项次*/
rwj06       number(20,6) DEFAULT '0' NOT NULL, /*满额金额*/
rwj07       number(5,2) DEFAULT '0' NOT NULL, /*折扣率%*/
rwj08       number(5,2) DEFAULT '0' NOT NULL, /*会员折扣率*/
rwj09       number(20,6) DEFAULT '0' NOT NULL, /*折价*/
rwj10       number(20,6) DEFAULT '0' NOT NULL, /*会员折价*/
rwjlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rwjplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table rwj_file add  constraint rwj_pk primary key  (rwj01,rwj02,rwj03,rwj04,rwj05,rwjplant) enable validate;
grant select on rwj_file to tiptopgp;
grant update on rwj_file to tiptopgp;
grant delete on rwj_file to tiptopgp;
grant insert on rwj_file to tiptopgp;
grant index on rwj_file to public;
grant select on rwj_file to ods;
