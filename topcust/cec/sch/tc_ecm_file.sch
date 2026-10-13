/*
================================================================================
檔案代號:tc_ecm_file
檔案名稱:工单作业编号参数修改作业	
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_ecm_file
(
tc_ecm00    varchar2(40) NOT NULL,   /*工单单号                               */
tc_ecm01    varchar2(40) NOT NULL,   /*主件料号                               */
tc_ecm02    varchar2(15) NOT NULL,   /*作业编号                               */
tc_ecm03    varchar2(20),            /*尺寸                                   */
tc_ecm04    number(20,6),            /*受镀面积                               */
tc_ecm05    number(20,6),            /*金厚                                   */
tc_ecm06    number(20,6),            /*镍厚                                   */
tc_ecm07    number(20,6),            /*钯厚                                   */
tc_ecm08    number(20,6),            /*线速                                   */
tc_ecmacti  varchar2(1),             /*有效否                                 */
tc_ecmud01  varchar2(40),            /*自定义1                                */
tc_ecmud02  varchar2(40),            /*自定义2                                */
tc_ecmud03  varchar2(40),            /*自定义3                                */
tc_ecmud04  varchar2(40),            /*自定义4                                */
tc_ecmud05  varchar2(40),            /*自定义5                                */
tc_ecmud06  number(15,3),            /*自定义6                                */
tc_ecmud07  number(15,3),            /*自定义7                                */
tc_ecmud08  number(15,3),            /*自定义8                                */
tc_ecmud09  date,                    /*自定义9                                */
tc_ecmud10  date,                    /*自定义10                               */
tc_ecm09    number(5) NOT NULL       /*项次                                   */
);

alter table tc_ecm_file add  constraint tpc_ecm_pk primary key  (tc_ecm00,tc_ecm01,tc_ecm02,tc_ecm09) enable validate;
grant select on tc_ecm_file to tiptopgp;
grant update on tc_ecm_file to tiptopgp;
grant delete on tc_ecm_file to tiptopgp;
grant insert on tc_ecm_file to tiptopgp;
grant index on tc_ecm_file to public;
grant select on tc_ecm_file to ods;
