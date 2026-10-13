/*
================================================================================
檔案代號:nnz_file
檔案名稱:支票作废档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nnz_file
(
nnz01       varchar2(20) DEFAULT ' ' NOT NULL, /*银行别*/
                                     /*銀行別                                 */
nnz02       varchar2(20) NOT NULL,   /*票号                                   */
                                     /*票號                                   */
nnz03       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
nnzuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
nnzgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
nnzmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
nnzdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
nnzoriu     varchar2(10),            /*资料建立者                             */
nnzorig     varchar2(10)             /*资料建立部门                           */
);

alter table nnz_file add  constraint nnz_pk primary key  (nnz01,nnz02) enable validate;
grant select on nnz_file to tiptopgp;
grant update on nnz_file to tiptopgp;
grant delete on nnz_file to tiptopgp;
grant insert on nnz_file to tiptopgp;
grant index on nnz_file to public;
grant select on nnz_file to ods;
