/*
================================================================================
檔案代號:tc_imaa_file
檔案名稱:料件备注资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_imaa_file
(
tc_imaa01   varchar2(40) NOT NULL,   /*料件编号                               */
tc_imaa02   varchar2(40) NOT NULL,   /*作业编号                               */
tc_imaa03   varchar2(100),           /*备注1                                  */
tc_imaa04   varchar2(100),           /*备注2                                  */
tc_imaa05   varchar2(1000),          /*备注3                                  */
tc_imaa06   varchar2(1000),          /*备注4                                  */
tc_imaa07   date,                    /*日期                                   */
tc_imaa08   date,                    /*日期                                   */
tc_imaa09   date,                    /*日期                                   */
tc_imaa10   date,                    /*日期                                   */
tc_imaa11   varchar2(20),            /*修改人员                               */
tc_imaa12   date,                    /*修改日期                               */
tc_imaa13   varchar2(20)             /*修改时间                               */
);

alter table tc_imaa_file add  constraint tpc_imaa_pk primary key  (tc_imaa01,tc_imaa02) enable validate;
grant select on tc_imaa_file to tiptopgp;
grant update on tc_imaa_file to tiptopgp;
grant delete on tc_imaa_file to tiptopgp;
grant insert on tc_imaa_file to tiptopgp;
grant index on tc_imaa_file to public;
grant select on tc_imaa_file to ods;
