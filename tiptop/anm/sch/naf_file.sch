/*
================================================================================
檔案代號:naf_file
檔案名稱:银行对账单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table naf_file
(
naf01       varchar2(20) DEFAULT ' ' NOT NULL, /*对账单号*/
naf02       varchar2(11) DEFAULT ' ' NOT NULL, /*对账银行编号*/
naf03       number(5) DEFAULT '0' NOT NULL, /*年度*/
naf04       number(5) DEFAULT '0' NOT NULL, /*期别*/
nafconf     varchar2(1),             /*审核否                                 */
nafdate     date,                    /*最近更改日                             */
nafgrup     varchar2(10),            /*资料所有部门                           */
naflegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
nafmodu     varchar2(10),            /*资料更改者                             */
nafuser     varchar2(10)             /*资料所有者                             */
);

alter table naf_file add  constraint naf_pk primary key  (naf01) enable validate;
grant select on naf_file to tiptopgp;
grant update on naf_file to tiptopgp;
grant delete on naf_file to tiptopgp;
grant insert on naf_file to tiptopgp;
grant index on naf_file to public;
grant select on naf_file to ods;
