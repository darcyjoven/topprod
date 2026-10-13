/*
================================================================================
檔案代號:tc_obe_file
檔案名稱:包裝方式檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_obe_file
(
tc_obe01    varchar2(40) NOT NULL,   /*料件编号                               */
tc_obe011   number(5) NOT NULL,      /*包装序号                               */
tc_obe02    number(15,3),            /*包装量                                 */
tc_obe021   varchar2(4),             /*包裝單位                               */
tc_obe03    number(15,3),            /*内包装量                               */
tc_obe031   varchar2(4),             /*内包裝單位                             */
tc_obe04    number(15,3),            /*外包装量                               */
tc_obe041   varchar2(4),             /*外包裝單位                             */
tc_obe05    number(20,8),            /*包装量与库存单位转换率                 */
tc_obe06    number(15,3),            /*内包装重g                              */
tc_obe07    number(15,3),            /*外包装重g                              */
tc_obe081   number(15,3),            /* 内包长  mm                            */
tc_obe082   number(15,3),            /* 内包宽 mm                             */
tc_obe083   number(15,3),            /* 内包高  mm                            */
tc_obe091   number(15,3),            /* 外包长                                */
tc_obe092   number(15,3),            /* 外包宽                                */
tc_obe093   number(15,3),            /* 外包高                                */
tc_obeud01  varchar2(20),            /* NO USE                                */
tc_obeud02  varchar2(20),            /* NO USE                                */
tc_obeud03  varchar2(20),            /* NO USE                                */
tc_obeud04  number(15,3),            /* NO USE                                */
tc_obeud05  number(15,3),            /* NO USE                                */
tc_obeud06  number(15,3),            /* NO USE                                */
tc_obeud07  date,                    /* NO USE                                */
tc_obeud08  date,                    /* NO USE                                */
tc_obeud09  date                     /* NO USE                                */
);

alter table tc_obe_file add  constraint tpc_obe_pk primary key  (tc_obe01,tc_obe011) enable validate;
grant select on tc_obe_file to tiptopgp;
grant update on tc_obe_file to tiptopgp;
grant delete on tc_obe_file to tiptopgp;
grant insert on tc_obe_file to tiptopgp;
grant index on tc_obe_file to public;
grant select on tc_obe_file to ods;
