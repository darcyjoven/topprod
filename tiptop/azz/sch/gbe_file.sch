/*
================================================================================
檔案代號:gbe_file
檔案名稱:程序版号资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gbe_file
(
gbe01       varchar2(10) NOT NULL,   /*工作单号                               */
gbe02       varchar2(5),             /*模组                                   */
gbe03       varchar2(40) NOT NULL,   /*程序编号                               */
gbe04       varchar2(10)             /*版号                                   */
);

alter table gbe_file add  constraint gbe_pk primary key  (gbe01,gbe03) enable validate;
grant select on gbe_file to tiptopgp;
grant update on gbe_file to tiptopgp;
grant delete on gbe_file to tiptopgp;
grant insert on gbe_file to tiptopgp;
grant index on gbe_file to public;
grant select on gbe_file to ods;
