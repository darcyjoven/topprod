/*
================================================================================
檔案代號:gau_file
檔案名稱:主键与外键关联纪录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gau_file
(
gau01       varchar2(20) NOT NULL,   /*主键Primary Key 字段名称               */
gau02       varchar2(20),            /*主键Primary Key Table名称              */
gau03       varchar2(20) NOT NULL,   /*外键Foreign Key 字段名称               */
gau04       varchar2(20),            /*外键Foreign Key Table名称              */
gau05       varchar2(50),            /*No Use                                 */
gau06       varchar2(50),            /*No Use                                 */
gau07       varchar2(50)             /*No Use                                 */
);

alter table gau_file add  constraint gau_pk primary key  (gau01,gau03) enable validate;
grant select on gau_file to tiptopgp;
grant update on gau_file to tiptopgp;
grant delete on gau_file to tiptopgp;
grant insert on gau_file to tiptopgp;
grant index on gau_file to public;
grant select on gau_file to ods;
