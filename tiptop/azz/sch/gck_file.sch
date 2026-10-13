/*
================================================================================
檔案代號:gck_file
檔案名稱:字段属性定义档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gck_file
(
gck01       varchar2(3) NOT NULL,    /*字段属性代码                           */
gck02       varchar2(40),            /*属性简称                               */
gck03       varchar2(30),            /*资料类型                               */
gck04       varchar2(255),           /*说明                                   */
gck05       varchar2(10),            /*更改者                                 */
gck06       date                     /*更改日                                 */
);

alter table gck_file add  constraint gck_pk primary key  (gck01) enable validate;
grant select on gck_file to tiptopgp;
grant update on gck_file to tiptopgp;
grant delete on gck_file to tiptopgp;
grant insert on gck_file to tiptopgp;
grant index on gck_file to public;
grant select on gck_file to ods;
