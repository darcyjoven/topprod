/*
================================================================================
檔案代號:smyb_file
檔案名稱:制造管理系统 使用单据性质-条码相关资料档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table smyb_file
(
smyb01      varchar2(1) DEFAULT '1' NOT NULL, /*条码控管方式*/
smyb02      varchar2(5),             /*完工入库单别                           */
smybslip    varchar2(5) DEFAULT ' ' NOT NULL, /*单别*/
smyb03      varchar2(1) DEFAULT ' ' NOT NULL
);

alter table smyb_file add  constraint smyb_pk primary key  (smybslip) enable validate;
grant select on smyb_file to tiptopgp;
grant update on smyb_file to tiptopgp;
grant delete on smyb_file to tiptopgp;
grant insert on smyb_file to tiptopgp;
grant index on smyb_file to public;
grant select on smyb_file to ods;
