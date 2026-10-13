/*
================================================================================
檔案代號:bnj_file
檔案名稱:委外工单年度结存档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table bnj_file
(
bnj01       varchar2(20) NOT NULL,   /*工单号码                               */
bnj02       number(15,3) NOT NULL,   /*生产数量-结存入库量                    */
bnjplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bnjlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table bnj_file add  constraint bnj_pk primary key  (bnj01) enable validate;
grant select on bnj_file to tiptopgp;
grant update on bnj_file to tiptopgp;
grant delete on bnj_file to tiptopgp;
grant insert on bnj_file to tiptopgp;
grant index on bnj_file to public;
grant select on bnj_file to ods;
