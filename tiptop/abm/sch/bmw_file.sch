/*
================================================================================
檔案代號:bmw_file
檔案名稱:ECN 插件位置维护
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bmw_file
(
bmw01       varchar2(20) NOT NULL,   /*ECN 单号                               */
                                     /*ECN 單號                               */
bmw02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
bmw03       number(5) NOT NULL,      /*行序                                   */
bmw04       varchar2(10),            /*插件位置                               */
bmw05       number(16,8),            /*插件位置数量                           */
                                     /*插件位置數量                           */
bmwplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bmwlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table bmw_file add  constraint bmw_pk primary key  (bmw01,bmw02,bmw03) enable validate;
grant select on bmw_file to tiptopgp;
grant update on bmw_file to tiptopgp;
grant delete on bmw_file to tiptopgp;
grant insert on bmw_file to tiptopgp;
grant index on bmw_file to public;
grant select on bmw_file to ods;
