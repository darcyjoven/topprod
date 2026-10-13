/*
================================================================================
檔案代號:bng_file
檔案名稱:保税料件内销折合档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table bng_file
(
bng01       varchar2(40),            /*主件编号                               */
bng02       varchar2(10),            /*仓库编号                               */
bng03       number(5),               /*年度                                   */
bng04       number(5),               /*月份                                   */
bng05       varchar2(40),            /*元件编号                               */
bng06       number(5),               /*元件项次                               */
bng07       number(16,8),            /*单位用量                               */
bng08       number(15,3),            /*内销折合数                             */
                                     /*主件內銷數*bng07                       */
bngplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bnglegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index bng_01 on bng_file (bng01,bng02,bng03,bng04);
grant select on bng_file to tiptopgp;
grant update on bng_file to tiptopgp;
grant delete on bng_file to tiptopgp;
grant insert on bng_file to tiptopgp;
grant index on bng_file to public;
grant select on bng_file to ods;
