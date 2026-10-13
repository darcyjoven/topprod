/*
================================================================================
檔案代號:cai_file
檔案名稱:成本项目成本分析资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cai_file
(
cai01       varchar2(40) NOT NULL,   /*工单单号重覆性生产产品成本             */
                                     /*工單編號                               */
cai02       number(5) NOT NULL,      /*年度                                   */
cai03       number(5) NOT NULL,      /*月份                                   */
cai04       varchar2(40),            /*主件料号                               */
                                     /*主件料號                               */
                                     /*需存在在料件基本資料主檔               */
                                     /*為該工單生產料件編號                   */
cai05       varchar2(10) NOT NULL,   /*成本中心                               */
cai06       varchar2(10) NOT NULL,   /*成本项目                               */
                                     /*成本項目                               */
cai07       number(20,6),            /*本月投入金额                           */
                                     /*本月投入金額                           */
cai08       varchar2(1) DEFAULT ' ' NOT NULL, /*成本分类*/
cailegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cai_file add  constraint cai_pk primary key  (cai01,cai02,cai03,cai05,cai06,cai08) enable validate;
grant select on cai_file to tiptopgp;
grant update on cai_file to tiptopgp;
grant delete on cai_file to tiptopgp;
grant insert on cai_file to tiptopgp;
grant index on cai_file to public;
grant select on cai_file to ods;
