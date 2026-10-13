/*
================================================================================
檔案代號:lqc_file
檔案名稱:券核销状态档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lqc_file
(
lqc01       varchar2(20) DEFAULT ' ' NOT NULL, /*券编号*/
lqc02       varchar2(1),             /*券原始状态                             */
lqc03       date,                    /*原始状态日期                           */
lqc04       date,                    /*核销日期                               */
lqc05       varchar2(1) DEFAULT ' ' NOT NULL, /*核销状态*/
lqc06       number(20),              /*核销次数                               */
lqclegal    varchar2(10) NOT NULL,   /*所属法人                               */
lqcplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table lqc_file add  constraint lqc_pk primary key  (lqc01) enable validate;
grant select on lqc_file to tiptopgp;
grant update on lqc_file to tiptopgp;
grant delete on lqc_file to tiptopgp;
grant insert on lqc_file to tiptopgp;
grant index on lqc_file to public;
grant select on lqc_file to ods;
