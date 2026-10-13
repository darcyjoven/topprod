/*
================================================================================
檔案代號:nsa_file
檔案名稱:转账媒体结构单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nsa_file
(
nsa01       varchar2(10) DEFAULT ' ' NOT NULL, /*媒体编号*/
nsa02       varchar2(80),            /*媒体名称                               */
nsa03       varchar2(1),             /*媒体性质                               */
nsa04       varchar2(20),            /*媒体档名                               */
nsa05       varchar2(255),           /*备注                                   */
nsa06       varchar2(1)              /*转出方式                               */
);

alter table nsa_file add  constraint nsa_pk primary key  (nsa01) enable validate;
grant select on nsa_file to tiptopgp;
grant update on nsa_file to tiptopgp;
grant delete on nsa_file to tiptopgp;
grant insert on nsa_file to tiptopgp;
grant index on nsa_file to public;
grant select on nsa_file to ods;
