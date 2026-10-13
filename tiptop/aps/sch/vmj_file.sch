/*
================================================================================
檔案代號:vmj_file
檔案名稱:APS工作站维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vmj_file
(
vmj01       varchar2(10) DEFAULT ' ' NOT NULL, /*资源编号*/
vmj02       varchar2(60),            /*周行事历                               */
vmj03       varchar2(60),            /*日行事历                               */
vmj04       number(1),               /*产能类型                               */
vmj07       number(1),               /*连批条件检查码(1~5)                    */
vmj10       number(9) DEFAULT '999'  /*CPT介面上的排序号                      */
);

alter table vmj_file add  constraint vmj_pk primary key  (vmj01) enable validate;
grant select on vmj_file to tiptopgp;
grant update on vmj_file to tiptopgp;
grant delete on vmj_file to tiptopgp;
grant insert on vmj_file to tiptopgp;
grant index on vmj_file to public;
grant select on vmj_file to ods;
