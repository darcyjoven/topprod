/*
================================================================================
檔案代號:oaf_file
檔案名稱:常用说明单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oaf_file
(
oaf01       varchar2(4) NOT NULL,    /*说明代码                               */
                                     /*說明代碼                               */
oaf02       number(5) NOT NULL,      /*行序                                   */
oaf03       varchar2(255)            /*说明                                   */
                                     /*說明                                   */
);

alter table oaf_file add  constraint oaf_pk primary key  (oaf01,oaf02) enable validate;
grant select on oaf_file to tiptopgp;
grant update on oaf_file to tiptopgp;
grant delete on oaf_file to tiptopgp;
grant insert on oaf_file to tiptopgp;
grant index on oaf_file to public;
grant select on oaf_file to ods;
