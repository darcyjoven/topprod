/*
================================================================================
檔案代號:tc_sfc_file
檔案名稱:归集点维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_sfc_file
(
tc_sfc01    varchar2(20) NOT NULL,   /*归集点                                 */
tc_sfc02    varchar2(6) NOT NULL,    /*作业编号                               */
tc_sfcud01  varchar2(255),           /*归集点说明                             */
tc_sfcud02  varchar2(40),            /*自定义字段                             */
tc_sfcud03  varchar2(40),            /*自定义字段                             */
tc_sfcud04  varchar2(40),            /*自定义字段                             */
tc_sfcud05  varchar2(40),            /*自定义字段                             */
tc_sfcud06  varchar2(40),            /*自定义字段                             */
tc_sfcud07  number(15,3),            /*自定义字段                             */
tc_sfcud08  number(15,3),            /*自定义字段                             */
tc_sfcud09  number(15,3),            /*自定义字段                             */
tc_sfcud10  number(10),              /*自定义字段                             */
tc_sfcud11  number(10),              /*自定义字段                             */
tc_sfcud12  number(10),              /*自定义字段                             */
tc_sfcud13  date,                    /*自定义字段                             */
tc_sfcud14  date,                    /*自定义字段                             */
tc_sfcud15  date                     /*自定义字段                             */
);

alter table tc_sfc_file add  constraint tpc_sfc_pk primary key  (tc_sfc01,tc_sfc02) enable validate;
grant select on tc_sfc_file to tiptopgp;
grant update on tc_sfc_file to tiptopgp;
grant delete on tc_sfc_file to tiptopgp;
grant insert on tc_sfc_file to tiptopgp;
grant index on tc_sfc_file to public;
grant select on tc_sfc_file to ods;
