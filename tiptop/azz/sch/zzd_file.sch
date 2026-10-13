/*
================================================================================
檔案代號:zzd_file
檔案名稱:制造业管理辞典
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table zzd_file
(
zzd01       varchar2(40) NOT NULL,   /*英文                                   */
zzd02       varchar2(40),            /*中文                                   */
zzdacti     varchar2(1)              /*有效否                                 */
);

alter table zzd_file add  constraint zzd_pk primary key  (zzd01) enable validate;
grant select on zzd_file to tiptopgp;
grant update on zzd_file to tiptopgp;
grant delete on zzd_file to tiptopgp;
grant insert on zzd_file to tiptopgp;
grant index on zzd_file to public;
grant select on zzd_file to ods;
