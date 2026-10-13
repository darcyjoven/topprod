/*
================================================================================
檔案代號:hraj_file
檔案名稱:身份证区域档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hraj_file
(
hraj01      varchar2(6) NOT NULL,    /*身份证号                               */
hraj02      varchar2(50),            /*所属区域                               */
hraj03      varchar2(4000),          /*备注                                   */
hrajacti    varchar2(1)              /*有效码                                 */
);

alter table hraj_file add  constraint tpc_hraj_pk primary key  (hraj01) enable validate;
grant select on hraj_file to tiptopgp;
grant update on hraj_file to tiptopgp;
grant delete on hraj_file to tiptopgp;
grant insert on hraj_file to tiptopgp;
grant index on hraj_file to public;
grant select on hraj_file to ods;
