/*
================================================================================
檔案代號:wpb_file
檔案名稱:预测采购需求档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table wpb_file
(
wpb01       varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
wpb02       date DEFAULT sysdate NOT NULL, /*预计需求日期*/
wpb03       number(15,3) DEFAULT '0' NOT NULL, /*需求数量*/
wpb04       varchar2(1) DEFAULT 'N' NOT NULL, /*电子采购否*/
wpb05       varchar2(15)             /*电子采购序号                           */
);

alter table wpb_file add  constraint wpb_pk primary key  (wpb01,wpb02) enable validate;
grant select on wpb_file to tiptopgp;
grant update on wpb_file to tiptopgp;
grant delete on wpb_file to tiptopgp;
grant insert on wpb_file to tiptopgp;
grant index on wpb_file to public;
grant select on wpb_file to ods;
