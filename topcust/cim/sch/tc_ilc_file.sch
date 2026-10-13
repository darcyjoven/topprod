/*
================================================================================
檔案代號:tc_ilc_file
檔案名稱:出勤人数记录
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_ilc_file
(
tc_ilc01    date,                    /*日期                                   */
tc_ilc02    varchar2(10),            /*版本                                   */
tc_ilc03    varchar2(100),           /*部门/类型                              */
tc_ilc04    varchar2(1),             /*班次                                   */
tc_ilc05    number(15),              /*出勤人数                               */
tc_ilc06    varchar2(20),
tc_ilc07    varchar2(20),
tc_ilc08    varchar2(1000),
tc_ilc09    varchar2(1000),
tc_ilc10    varchar2(1000),
tc_ilc11    number(15),
tc_ilc12    number(15),
tc_ilc13    number(15),
tc_ilc14    number(15,3),
tc_ilc15    number(15,3),
tc_ilc16    number(15,3),
tc_ilc17    date,
tc_ilc18    date,
tc_ilc19    date,
tc_ilc20    date
);

create unique index tc_ilc_idx on tc_ilc_file (tc_ilc01,tc_ilc02);
grant select on tc_ilc_file to tiptopgp;
grant update on tc_ilc_file to tiptopgp;
grant delete on tc_ilc_file to tiptopgp;
grant insert on tc_ilc_file to tiptopgp;
grant index on tc_ilc_file to public;
grant select on tc_ilc_file to ods;
