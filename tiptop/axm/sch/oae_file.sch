/*
================================================================================
檔案代號:oae_file
檔案名稱:常用说明单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oae_file
(
oae01       varchar2(4) NOT NULL,    /*说明代码                               */
                                     /*說明代碼                               */
oae02       varchar2(80)             /*说明简述                               */
                                     /*說明簡述                               */
);

alter table oae_file add  constraint oae_pk primary key  (oae01) enable validate;
grant select on oae_file to tiptopgp;
grant update on oae_file to tiptopgp;
grant delete on oae_file to tiptopgp;
grant insert on oae_file to tiptopgp;
grant index on oae_file to public;
grant select on oae_file to ods;
