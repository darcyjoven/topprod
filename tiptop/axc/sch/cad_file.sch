/*
================================================================================
檔案代號:cad_file
檔案名稱:每月人工制费明细资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cad_file
(
cad01       number(5) NOT NULL,      /*年度                                   */
cad02       number(5) NOT NULL,      /*月份                                   */
cad03       varchar2(10) NOT NULL,   /*成本中心                               */
cad04       varchar2(10) NOT NULL,   /*成本项目                               */
                                     /*成本項目                               */
cad05       varchar2(1),             /*成本分类 1.人工成本 2.制费一           */
cad06       varchar2(24) NOT NULL,   /*会计科目                               */
                                     /*會計科目                               */
cad07       varchar2(1),             /*固定/变动别(F/V)                       */
                                     /*固定/變動別(F/V)                       */
cad08       number(20,6),            /*本月投入成本                           */
cadlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cad_file add  constraint cad_pk primary key  (cad01,cad02,cad03,cad04,cad06) enable validate;
grant select on cad_file to tiptopgp;
grant update on cad_file to tiptopgp;
grant delete on cad_file to tiptopgp;
grant insert on cad_file to tiptopgp;
grant index on cad_file to public;
grant select on cad_file to ods;
