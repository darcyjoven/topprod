/*
================================================================================
檔案代號:gsf_file
檔案名稱:投资费用编号基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gsf_file
(
gsf01       varchar2(6) NOT NULL,    /*费用编号                               */
                                     /*費用代號                               */
gsf02       varchar2(80),            /*费用名称                               */
                                     /*費用名稱                               */
gsf03       varchar2(1),             /*No Use                                 */
gsf04       varchar2(24),            /*会计科目                               */
                                     /*會計科目                               */
gsf05       varchar2(1),             /*No Use                                 */
gsf06       varchar2(1),             /*No Use                                 */
gsfacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
gsfuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
gsfgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
gsfmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
gsfdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
gsf041      varchar2(24),            /*会计科目二                             */
gsforig     varchar2(10),            /*资料建立部门                           */
gsforiu     varchar2(10)             /*资料建立者                             */
);

alter table gsf_file add  constraint gsf_pk primary key  (gsf01) enable validate;
grant select on gsf_file to tiptopgp;
grant update on gsf_file to tiptopgp;
grant delete on gsf_file to tiptopgp;
grant insert on gsf_file to tiptopgp;
grant index on gsf_file to public;
grant select on gsf_file to ods;
