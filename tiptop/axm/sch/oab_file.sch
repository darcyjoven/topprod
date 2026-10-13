/*
================================================================================
檔案代號:oab_file
檔案名稱:销售分类档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oab_file
(
oab01       varchar2(10) NOT NULL,   /*销售分类码                             */
                                     /*銷售分類碼                             */
oab02       varchar2(80)             /*分类名称                               */
                                     /*分類名稱                               */
);

alter table oab_file add  constraint oab_pk primary key  (oab01) enable validate;
grant select on oab_file to tiptopgp;
grant update on oab_file to tiptopgp;
grant delete on oab_file to tiptopgp;
grant insert on oab_file to tiptopgp;
grant index on oab_file to public;
grant select on oab_file to ods;
