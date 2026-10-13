/*
================================================================================
檔案代號:ggc_file
檔案名稱:库存异动作业理由码设置档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ggc_file
(
ggc01       varchar2(5) DEFAULT ' ' NOT NULL, /*异动单据单别*/
ggc02       varchar2(5) DEFAULT ' ' NOT NULL, /*来源单据单别*/
ggc03       varchar2(10) DEFAULT ' ' NOT NULL, /*分群码*/
ggc04       varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
ggc05       varchar2(10) DEFAULT ' ' NOT NULL, /*仓库编号*/
ggc06       varchar2(10) DEFAULT ' ' NOT NULL, /*员工编号*/
ggc07       varchar2(10) DEFAULT ' ' NOT NULL, /*部门编号*/
ggc08       varchar2(10) DEFAULT ' ' NOT NULL, /*理由码*/
ggc09       varchar2(1) DEFAULT ' ' NOT NULL, /*默认*/
ggcacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
ggcdate     date,                    /*最近更改日                             */
ggcgrup     varchar2(10),            /*资料所有群                             */
ggcmodu     varchar2(10),            /*资料更改者                             */
ggcorig     varchar2(10),            /*资料建立部门                           */
ggcoriu     varchar2(10),            /*资料建立者                             */
ggcuser     varchar2(10)             /*资料所有者                             */
);

alter table ggc_file add  constraint ggc_pk primary key  (ggc01,ggc02,ggc03,ggc04,ggc05,ggc06,ggc07,ggc08) enable validate;
grant select on ggc_file to tiptopgp;
grant update on ggc_file to tiptopgp;
grant delete on ggc_file to tiptopgp;
grant insert on ggc_file to tiptopgp;
grant index on ggc_file to public;
grant select on ggc_file to ods;
