/*
================================================================================
檔案代號:bgx_file
檔案名稱:薪资部门会计科目维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bgx_file
(
bgx01       varchar2(10) NOT NULL,   /*部门代码                               */
                                     /*部門代碼                               */
bgx02       varchar2(1) NOT NULL,    /*直间接                                 */
                                     /*直間接  1.直接 2.間接                  */
bgx03       varchar2(6) NOT NULL,    /*费用项目                               */
                                     /*費用項目                               */
bgx04       varchar2(24),            /*会计科目                               */
                                     /*會計科目                               */
bgxacti     varchar2(1),             /*资料有效否                             */
bgxuser     varchar2(10),            /*资料所有者                             */
bgxgrup     varchar2(10),            /*资料所有群                             */
bgxmodu     varchar2(10),            /*资料更改者                             */
bgxdate     date,                    /*最近更改日                             */
bgxorig     varchar2(10),            /*资料建立部门                           */
bgxoriu     varchar2(10)             /*资料建立者                             */
);

alter table bgx_file add  constraint bgx_pk primary key  (bgx01,bgx02,bgx03) enable validate;
grant select on bgx_file to tiptopgp;
grant update on bgx_file to tiptopgp;
grant delete on bgx_file to tiptopgp;
grant insert on bgx_file to tiptopgp;
grant index on bgx_file to public;
grant select on bgx_file to ods;
