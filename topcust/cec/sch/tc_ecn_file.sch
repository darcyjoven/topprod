/*
================================================================================
檔案代號:tc_ecn_file
檔案名稱:主件作业编号参数维护作业	
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_ecn_file
(
tc_ecn01    varchar2(40) NOT NULL,   /*主件料号                               */
tc_ecn02    varchar2(15) NOT NULL,   /*作业编号                               */
tc_ecn03    varchar2(20),            /*尺寸                                   */
tc_ecn04    number(20,6),            /*受镀面积                               */
tc_ecn05    number(20,6),            /*金厚                                   */
tc_ecn06    number(20,6),            /*镍厚                                   */
tc_ecn07    number(20,6),            /*钯厚                                   */
tc_ecn08    number(20,6),            /*线速                                   */
tc_ecnacti  varchar2(1),             /*有效否                                 */
tc_ecnud01  varchar2(40),            /*自定义1                                */
tc_ecnud02  varchar2(40),            /*自定义2                                */
tc_ecnud03  varchar2(40),            /*自定义3                                */
tc_ecnud04  varchar2(40),            /*自定义4                                */
tc_ecnud05  varchar2(40),            /*自定义5                                */
tc_ecnud06  number(20,6),            /*铜厚                                   */
tc_ecnud07  number(20,6),            /*自定义7                                */
tc_ecnud08  number(15,3),            /*自定义8                                */
tc_ecnud09  date,                    /*自定义9                                */
tc_ecnud10  date,                    /*自定义10                               */
tc_ecn09    number(5) NOT NULL       /*项次                                   */
);

alter table tc_ecn_file add  constraint tpc_ecn_pk primary key  (tc_ecn01,tc_ecn02,tc_ecn09) enable validate;
grant select on tc_ecn_file to tiptopgp;
grant update on tc_ecn_file to tiptopgp;
grant delete on tc_ecn_file to tiptopgp;
grant insert on tc_ecn_file to tiptopgp;
grant index on tc_ecn_file to public;
grant select on tc_ecn_file to ods;
