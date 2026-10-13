/*
================================================================================
檔案代號:cak_file
檔案名稱:产品别成本项目设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cak_file
(
cak01       varchar2(10) NOT NULL,   /*产品分类                               */
                                     /*產品分類 -> ima131                     */
cak02       varchar2(10) NOT NULL,   /*成本中心                               */
cak03       varchar2(10) NOT NULL    /*成本项目                               */
                                     /*成本項目                               */
);

create        index cak_01 on cak_file (cak01);
create        index cak_02 on cak_file (cak02,cak03);
alter table cak_file add  constraint cak_pk primary key  (cak01,cak02,cak03) enable validate;
grant select on cak_file to tiptopgp;
grant update on cak_file to tiptopgp;
grant delete on cak_file to tiptopgp;
grant insert on cak_file to tiptopgp;
grant index on cak_file to public;
grant select on cak_file to ods;
