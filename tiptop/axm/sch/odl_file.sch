/*
================================================================================
檔案代號:odl_file
檔案名稱:订货会基本资料维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table odl_file
(
odl01       varchar2(10) DEFAULT ' ' NOT NULL, /*訂購會編號*/
odl02       varchar2(100),           /*订购会名称                             */
odl03       date,                    /*开始日期                               */
odl04       date,                    /*截止日期                               */
odl05       varchar2(1000),          /*備注                                   */
odlacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
odldate     date,                    /*最近更改日                             */
odlgrup     varchar2(10),            /*资料所有部门                           */
odlorig     varchar2(10),            /*资料建立部门                           */
odloriu     varchar2(10),            /*资料建立者                             */
odluser     varchar2(10),            /*资料所有者                             */
odlmodu     varchar2(10)             /*资料更改者                             */
);

alter table odl_file add  constraint odl_pk primary key  (odl01) enable validate;
grant select on odl_file to tiptopgp;
grant update on odl_file to tiptopgp;
grant delete on odl_file to tiptopgp;
grant insert on odl_file to tiptopgp;
grant index on odl_file to public;
grant select on odl_file to ods;
