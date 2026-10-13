/*
================================================================================
檔案代號:doc_file
檔案名稱:单据别设定档(for s_auto_assign_no)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table doc_file
(
docacti     varchar2(1) DEFAULT 'N' NOT NULL, /*资料有效码*/
docauno     varchar2(1) DEFAULT 'N' NOT NULL, /*自动编号否*/
dockind     varchar2(2),             /*单据性质                               */
docslip     varchar2(5) DEFAULT ' ' NOT NULL, /*单别*/
docsys      varchar2(10) DEFAULT ' ' NOT NULL /*模组编号*/
);

alter table doc_file add  constraint doc_pk primary key  (docsys,docslip) enable validate;
grant select on doc_file to tiptopgp;
grant update on doc_file to tiptopgp;
grant delete on doc_file to tiptopgp;
grant insert on doc_file to tiptopgp;
grant index on doc_file to public;
grant select on doc_file to ods;
