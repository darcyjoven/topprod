/*
================================================================================
檔案代號:hrcdb_file
檔案名稱:特殊请假明细对应档
檔案目的:
上游檔案:hrcda_file
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcdb_file
(
hrcdb01     varchar2(20) NOT NULL,   /*请假单号                               */
hrcdb02     number(5) NOT NULL,      /*项次                                   */
hrcdb03     varchar2(20) NOT NULL,   /*假勤计划编号                           */
hrcdb04     number(5,2) NOT NULL,    /*请假时长                               */
hrcdb05     varchar2(20) NOT NULL,   /*请假单位                               */
hrcdb06     varchar2(1)              /*年假类型                               */
                                     /*1-结余年假 2-普通年假                  */
);

alter table hrcdb_file add  constraint tpc_hrcdb_pk primary key  (hrcdb01,hrcdb02,hrcdb03) enable validate;
grant select on hrcdb_file to tiptopgp;
grant update on hrcdb_file to tiptopgp;
grant delete on hrcdb_file to tiptopgp;
grant insert on hrcdb_file to tiptopgp;
grant index on hrcdb_file to public;
grant select on hrcdb_file to ods;
