/*
================================================================================
檔案代號:skm_file
檔案名稱:报工群组资料档
檔案目的:报工群组资料单身档
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table skm_file
(
skm01       varchar2(10) DEFAULT ' ' NOT NULL, /*群组编号*/
skm03       varchar2(40) DEFAULT ' ' NOT NULL, /*款式料号*/
skm04       varchar2(10) DEFAULT ' ' NOT NULL, /*员工编号*/
skm05       varchar2(10) DEFAULT ' ' NOT NULL, /*工艺单元编号*/
skm06       number(15,6) DEFAULT '0' NOT NULL, /*同工艺单元报工比例*/
skm07       date DEFAULT sysdate NOT NULL, /*生效日期*/
skm08       date                     /*失效日期                               */
);

alter table skm_file add  constraint skm_pk primary key  (skm01,skm03,skm04,skm05) enable validate;
grant select on skm_file to tiptopgp;
grant update on skm_file to tiptopgp;
grant delete on skm_file to tiptopgp;
grant insert on skm_file to tiptopgp;
grant index on skm_file to public;
grant select on skm_file to ods;
