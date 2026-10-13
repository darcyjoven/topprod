/*
================================================================================
檔案代號:hrdka_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdka_file
(
hrdka01     varchar2(20) NOT NULL,   /*计算项编号                             */
hrdka02     number(5) NOT NULL,      /*数组下标(显示顺序)                     */
hrdka03     number(5),               /*数组元素ID                             */
hrdka04     varchar2(1000),          /*实际名称                               */
hrdka05     varchar2(1000),          /*显示名称                               */
hrdka06     number(5),               /*行序                                   */
hrdka07     number(5),               /*长度                                   */
hrdka08     number(5),               /*起始X坐标                              */
hrdka09     number(5),               /*起始Y坐标                              */
hrdka10     number(5),               /*结束X坐标                              */
hrdka11     number(5),               /*结束Y坐标                              */
hrdka12     varchar2(20)             /*类型                                   */
);

alter table hrdka_file add  constraint tpc_hrdka_pk primary key  (hrdka01,hrdka02) enable validate;
grant select on hrdka_file to tiptopgp;
grant update on hrdka_file to tiptopgp;
grant delete on hrdka_file to tiptopgp;
grant insert on hrdka_file to tiptopgp;
grant index on hrdka_file to public;
grant select on hrdka_file to ods;
