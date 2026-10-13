/*
================================================================================
檔案代號:cxz_file
檔案名稱:工单成本项目资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cxz_file
(
cxz01       varchar2(40) NOT NULL,   /*工单单号重覆性生产产品成本             */
cxz02       varchar2(10) NOT NULL,   /*成本中心                               */
cxz03       varchar2(10) NOT NULL,   /*成本项目                               */
cxz04       number(20,6),            /*人工总成本                             */
cxz05       number(20,6),            /*制费总成本                             */
cxz06       number(15,3),            /*人工指标总数                           */
cxz07       number(15,3),            /*制费指标总数                           */
cxz08       varchar2(1) DEFAULT ' ' NOT NULL, /*成本分类*/
cxzlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cxz_file add  constraint cxz_pk primary key  (cxz01,cxz02,cxz03,cxz08) enable validate;
grant select on cxz_file to tiptopgp;
grant update on cxz_file to tiptopgp;
grant delete on cxz_file to tiptopgp;
grant insert on cxz_file to tiptopgp;
grant index on cxz_file to public;
grant select on cxz_file to ods;
