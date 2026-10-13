/*
================================================================================
檔案代號:wpda_file
檔案名稱:电子采购趣价分量计价档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table wpda_file
(
wpda01      varchar2(15) DEFAULT ' ' NOT NULL, /*電子需求序號*/
wpda02      varchar2(10) DEFAULT ' ' NOT NULL, /*厂商编号*/
wpda03      number(15,3) DEFAULT '0' NOT NULL, /*啟起數量*/
wpda04      number(15,3) DEFAULT '0' NOT NULL, /*截止数量*/
wpda05      number(20,6) DEFAULT '0' NOT NULL, /*单价*/
wpda06      varchar2(10)             /*来源工厂                               */
);

create        index wpda_01 on wpda_file (wpda01,wpda02);
alter table wpda_file add  constraint wpda_pk primary key  (wpda01,wpda02,wpda03) enable validate;
grant select on wpda_file to tiptopgp;
grant update on wpda_file to tiptopgp;
grant delete on wpda_file to tiptopgp;
grant insert on wpda_file to tiptopgp;
grant index on wpda_file to public;
grant select on wpda_file to ods;
