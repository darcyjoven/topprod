/*
================================================================================
檔案代號:tqj_file
檔案名稱:客户层级关系单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tqj_file
(
tqj01       varchar2(10) NOT NULL,   /*上级客户代码                           */
tqj02       number(5) NOT NULL,      /*项次                                   */
tqj03       varchar2(10) NOT NULL,   /*下级客户代码                           */
tqj04       date,                    /*生效日期                               */
tqj05       date                     /*失效日期                               */
);

alter table tqj_file add  constraint tqj_pk primary key  (tqj01,tqj02) enable validate;
grant select on tqj_file to tiptopgp;
grant update on tqj_file to tiptopgp;
grant delete on tqj_file to tiptopgp;
grant insert on tqj_file to tiptopgp;
grant index on tqj_file to public;
grant select on tqj_file to ods;
