/*
================================================================================
檔案代號:icd_file
檔案名稱:ICD理由码资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table icd_file
(
icd01       varchar2(10) NOT NULL,   /*码别编号                               */
icd02       varchar2(1) NOT NULL,    /*码类型                                 */
icd03       varchar2(255),           /*说明内容                               */
icd04       varchar2(5),             /*保税异动类型                           */
icd05       varchar2(24),            /*存货差异科目编号                       */
icd06       number(5),               /*no use                                 */
icdacti     varchar2(1),             /*资料有效码                             */
icddate     date,                    /*最后更改日期                           */
icdgrup     varchar2(10),            /*用户部门                               */
icdmodu     varchar2(10),            /*最后更改资料者                         */
icduser     varchar2(10),            /*原始资料建立者                         */
icdorig     varchar2(10),            /*资料建立部门                           */
icdoriu     varchar2(10)             /*资料建立者                             */
);

alter table icd_file add  constraint icd_pk primary key  (icd01,icd02) enable validate;
grant select on icd_file to tiptopgp;
grant update on icd_file to tiptopgp;
grant delete on icd_file to tiptopgp;
grant insert on icd_file to tiptopgp;
grant index on icd_file to public;
grant select on icd_file to ods;
