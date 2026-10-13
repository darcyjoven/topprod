/*
================================================================================
檔案代號:bnf_file
檔案名稱:保税料件月统计档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table bnf_file
(
bnf01       varchar2(40) NOT NULL,   /*料件编号                               */
bnf02       varchar2(10) NOT NULL,   /*仓库编号                               */
bnf03       number(5) NOT NULL,      /*年度                                   */
bnf04       number(5) NOT NULL,      /*月份                                   */
bnf05       number(15,3) NOT NULL,   /*本期入库总量                           */
bnf06       number(15,3) NOT NULL,   /*本期出库总量                           */
bnf07       number(15,3) NOT NULL,   /*期末数量                               */
bnf08       number(15,3) NOT NULL,   /*本期保税进货数                         */
bnf09       number(15,3) NOT NULL,   /*本期非保税进货数                       */
bnf10       number(15,3) NOT NULL,   /*本期内销数量                           */
bnf11       number(15,3) NOT NULL,   /*本期内销折合原料数量                   */
bnf12       number(15,3) NOT NULL,   /*本期结存非保税数量                     */
bnf21       number(15,3),            /*本期厂内生产领用数量(原料帐            */
bnf22       number(15,3),            /*本期委外加工领用数量(原料帐            */
bnf23       number(15,3),            /*本期外运领用数量(原料帐)               */
bnf24       number(15,3),            /*本期其他领用数量(原料帐)               */
bnf25       number(15,3),            /*本期退料数量(原料帐)                   */
bnf26       number(15,3),            /*本期出口数量(原料帐)                   */
bnf27       number(15,3),            /*本期报废数量(原料帐)                   */
bnf28       number(15,3),            /*本期出口数量(成品帐)                   */
bnf29       number(15,3),            /*本期成品存仓数(转运用成品帐            */
bnf30       number(15,3),            /*本期成品出仓数(转运用成品帐            */
bnf31       number(15,3),            /*本期其它成品出仓数(转运用成            */
bnfplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bnflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table bnf_file add  constraint bnf_pk primary key  (bnf01,bnf02,bnf03,bnf04) enable validate;
grant select on bnf_file to tiptopgp;
grant update on bnf_file to tiptopgp;
grant delete on bnf_file to tiptopgp;
grant insert on bnf_file to tiptopgp;
grant index on bnf_file to public;
grant select on bnf_file to ods;
