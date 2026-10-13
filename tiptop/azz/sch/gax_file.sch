/*
================================================================================
檔案代號:gax_file
檔案名稱:4GL与PER关系档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gax_file
(
gax01       varchar2(20) NOT NULL,   /*程序代码                               */
gax02       varchar2(20) NOT NULL,   /*画面档代码                             */
gax03       varchar2(1),             /*是否实际存在                           */
gax04       varchar2(1),             /*是否为 help 使用                       */
gax05       varchar2(1) NOT NULL     /*客制码                                 */
);

alter table gax_file add  constraint gax_pk primary key  (gax01,gax02,gax05) enable validate;
grant select on gax_file to tiptopgp;
grant update on gax_file to tiptopgp;
grant delete on gax_file to tiptopgp;
grant insert on gax_file to tiptopgp;
grant index on gax_file to public;
grant select on gax_file to ods;
