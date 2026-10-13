/*
================================================================================
檔案代號:zau_file
檔案名稱:自定义查询权限设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zau_file
(
zau01       varchar2(80) NOT NULL,   /*查询单id                               */
zau02       varchar2(20),            /*资料所有者字段                         */
zau03       varchar2(20),            /*资料群组字段                           */
zau04       varchar2(1) NOT NULL     /*客制码                                 */
);

alter table zau_file add  constraint zau_pk primary key  (zau01,zau04) enable validate;
grant select on zau_file to tiptopgp;
grant update on zau_file to tiptopgp;
grant delete on zau_file to tiptopgp;
grant insert on zau_file to tiptopgp;
grant index on zau_file to public;
grant select on zau_file to ods;
