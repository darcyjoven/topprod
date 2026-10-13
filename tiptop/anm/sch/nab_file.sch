/*
================================================================================
檔案代號:nab_file
檔案名稱:关系企业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nab_file
(
nab01       varchar2(8) NOT NULL,    /*关系企业编号                           */
                                     /*關係企業編號                           */
nab02       varchar2(40),            /*简称                                   */
nab03       varchar2(80)             /*全名                                   */
);

alter table nab_file add  constraint nab_pk primary key  (nab01) enable validate;
grant select on nab_file to tiptopgp;
grant update on nab_file to tiptopgp;
grant delete on nab_file to tiptopgp;
grant insert on nab_file to tiptopgp;
grant index on nab_file to public;
grant select on nab_file to ods;
