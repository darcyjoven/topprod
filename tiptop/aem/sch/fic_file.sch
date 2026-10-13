/*
================================================================================
檔案代號:fic_file
檔案名稱:设备类型档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fic_file
(
fic01       varchar2(10) NOT NULL,   /*类型编号                               */
fic02       varchar2(80),            /*名称                                   */
fic03       varchar2(1)              /*铭牌存在否                             */
);

alter table fic_file add  constraint fic_pk primary key  (fic01) enable validate;
grant select on fic_file to tiptopgp;
grant update on fic_file to tiptopgp;
grant delete on fic_file to tiptopgp;
grant insert on fic_file to tiptopgp;
grant index on fic_file to public;
grant select on fic_file to ods;
