/*
================================================================================
檔案代號:gce_file
檔案名稱:资料上传下载条件式维护档	
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gce_file
(
gce01       varchar2(10) NOT NULL,   /*格式代码                               */
gce02       number(5) NOT NULL,      /*序号                                   */
gce03       varchar2(30) NOT NULL,   /*字段代码                               */
gce04       varchar2(255)            /*运算式                                 */
);

alter table gce_file add  constraint gce_pk primary key  (gce01,gce02,gce03) enable validate;
grant select on gce_file to tiptopgp;
grant update on gce_file to tiptopgp;
grant delete on gce_file to tiptopgp;
grant insert on gce_file to tiptopgp;
grant index on gce_file to public;
grant select on gce_file to ods;
