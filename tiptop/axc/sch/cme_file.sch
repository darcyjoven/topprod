/*
================================================================================
檔案代號:cme_file
檔案名稱:料件分类毛利费用率维护
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cme_file
(
cme01       number(5) NOT NULL,      /*年度                                   */
cme02       number(5) NOT NULL,      /*月份                                   */
cme03       varchar2(10) NOT NULL,   /*分类码                                 */
                                     /*成本分群                               */
cme04       number(15,3),            /*销售费用率                             */
                                     /*銷售費用率                             */
cme05       number(15,3),            /*销售毛利率                             */
                                     /*銷售毛利率                             */
cme031      varchar2(10) DEFAULT ' ' NOT NULL, /*产品分类*/
cme06       varchar2(1) DEFAULT '1' NOT NULL, /*料件分类来源*/
cmelegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cme_file add  constraint cme_pk primary key  (cme01,cme02,cme03,cme031,cme06) enable validate;
grant select on cme_file to tiptopgp;
grant update on cme_file to tiptopgp;
grant delete on cme_file to tiptopgp;
grant insert on cme_file to tiptopgp;
grant index on cme_file to public;
grant select on cme_file to ods;
