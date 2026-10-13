/*
================================================================================
檔案代號:tc_omc_file
檔案名稱:期初开账资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_omc_file
(
tc_omc01    number(10) NOT NULL,     /*年度                                   */
tc_omc02    number(10) NOT NULL,     /*期别                                   */
tc_omc03    varchar2(40) NOT NULL,   /*料件                                   */
tc_omc04    varchar2(40),            /*属性                                   */
tc_omc05    varchar2(4),             /*单位                                   */
tc_omc06    number(15,3),            /*数量                                   */
tc_omc07    number(20,6),            /*材料                                   */
tc_omc08    number(20,6),            /*人工                                   */
tc_omc09    number(20,6),            /*制费                                   */
tc_omc10    number(20,6),            /*加工费                                 */
tc_omc11    number(20,6),            /*单价                                   */
tc_omcud01  varchar2(40),            /*自订字段-文字                          */
tc_omcud02  varchar2(40),            /*自订字段-文字                          */
tc_omcud03  varchar2(40),            /*自订字段-文字                          */
tc_omcud04  varchar2(40),            /*自订字段-文字                          */
tc_omcud05  varchar2(255),           /*自订字段-文字                          */
tc_omcud06  number(15,3),            /*自订字段-数字                          */
tc_omcud07  number(15,3),            /*自订字段-数字                          */
tc_omcud08  number(15,3),            /*自订字段-数字                          */
tc_omcud09  number(20,6),            /*自订字段-数字                          */
tc_omcud10  number(20,6),            /*自订字段-数字                          */
tc_omcud11  number(20,6),            /*自订字段-数字                          */
tc_omcud12  number(20,6),            /*自订字段-数字                          */
tc_omcud13  date,                    /*自订字段-时间                          */
tc_omcud14  date,                    /*自订字段-时间                          */
tc_omcud15  date,                    /*自订字段-时间                          */
tc_omcud16  date,                    /*自订字段-时间                          */
tc_omcud17  number(10),              /*自订字段-整数                          */
tc_omcud18  number(10),              /*自订字段-整数                          */
tc_omcud19  number(10),              /*自订字段-整数                          */
tc_omcud20  number(10)               /*自订字段-整数                          */
);

create unique index tic_omc_01 on tc_omc_file (tc_omc01,tc_omc02,tc_omc03);
alter table tc_omc_file add  constraint tpc_omc_pk primary key  (tc_omc01,tc_omc02,tc_omc03) enable validate;
grant select on tc_omc_file to tiptopgp;
grant update on tc_omc_file to tiptopgp;
grant delete on tc_omc_file to tiptopgp;
grant insert on tc_omc_file to tiptopgp;
grant index on tc_omc_file to public;
grant select on tc_omc_file to ods;
