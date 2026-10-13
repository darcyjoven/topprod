/*
================================================================================
檔案代號:gsl_file
檔案名稱:投资现值维护资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table gsl_file
(
gsl01       varchar2(20) NOT NULL,   /*投资单号                               */
gsl02       date NOT NULL,           /*现价日期                               */
gsl03       number(20,6),            /*现价(本币)                             */
gsl04       varchar2(255),           /*备注                                   */
gslacti     varchar2(1),             /*资料有效码                             */
gsluser     varchar2(10),            /*资料所有者                             */
gslgrup     varchar2(10),            /*资料所有部门                           */
gslmodu     varchar2(10),            /*资料更改者                             */
gsldate     date,                    /*最近更改日                             */
gsllegal    varchar2(10) NOT NULL,   /*所属法人                               */
gslorig     varchar2(10),            /*资料建立部门                           */
gsloriu     varchar2(10)             /*资料建立者                             */
);

alter table gsl_file add  constraint gsl_pk primary key  (gsl01,gsl02) enable validate;
grant select on gsl_file to tiptopgp;
grant update on gsl_file to tiptopgp;
grant delete on gsl_file to tiptopgp;
grant insert on gsl_file to tiptopgp;
grant index on gsl_file to public;
grant select on gsl_file to ods;
