/*
================================================================================
檔案代號:oar_file
檔案名稱:多角贸易营运中心编号发票/税种设置
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oar_file
(
oar01       varchar2(2) NOT NULL,    /*流程代码                               */
                                     /*流程代碼                               */
oar02       varchar2(10) NOT NULL,   /*营运中心编号                           */
                                     /*Plant No.                              */
oar03       varchar2(5),             /*发票别                                 */
                                     /*發票別                                 */
oar04       varchar2(4)              /*发票税种                               */
                                     /*發票稅別                               */
);

alter table oar_file add  constraint oar_pk primary key  (oar01,oar02) enable validate;
grant select on oar_file to tiptopgp;
grant update on oar_file to tiptopgp;
grant delete on oar_file to tiptopgp;
grant insert on oar_file to tiptopgp;
grant index on oar_file to public;
grant select on oar_file to ods;
