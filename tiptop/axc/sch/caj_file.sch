/*
================================================================================
檔案代號:caj_file
檔案名稱:固定/变动成本分析资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table caj_file
(
caj01       number(5) NOT NULL,      /*年度                                   */
caj02       number(5) NOT NULL,      /*月份                                   */
caj04       varchar2(40) NOT NULL,   /*主件料号                               */
                                     /*主件料號                               */
                                     /*需存在在料件基本資料主檔               */
caj05       number(20,6),            /*本月投入金额                           */
                                     /*本月投入金額                           */
caj06       number(20,6),            /*固定成本                               */
caj07       number(20,6),            /*变动成本                               */
                                     /*變動成本                               */
cajlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table caj_file add  constraint caj_pk primary key  (caj01,caj02,caj04) enable validate;
grant select on caj_file to tiptopgp;
grant update on caj_file to tiptopgp;
grant delete on caj_file to tiptopgp;
grant insert on caj_file to tiptopgp;
grant index on caj_file to public;
grant select on caj_file to ods;
