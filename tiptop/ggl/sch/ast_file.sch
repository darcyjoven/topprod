/*
================================================================================
檔案代號:ast_file
檔案名稱:来源科目MISC明细科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ast_file
(
ast00       varchar2(5) DEFAULT ' ' NOT NULL, /*来源帐套*/
ast01       varchar2(24) DEFAULT ' ' NOT NULL, /*来源会计科目编号*/
ast03       varchar2(24) DEFAULT ' ' NOT NULL, /*来源科目misc明细科目*/
ast09       varchar2(10) DEFAULT ' ' NOT NULL, /*来源公司编号*/
ast10       varchar2(10) DEFAULT ' ' NOT NULL, /*对冲公司编号*/
ast12       varchar2(5) DEFAULT ' ' NOT NULL, /*对冲帐套*/
ast13       varchar2(10) DEFAULT ' ' NOT NULL /*族群编号*/
);

alter table ast_file add  constraint ast_pk primary key  (ast00,ast01,ast03,ast09,ast10,ast12,ast13) enable validate;
grant select on ast_file to tiptopgp;
grant update on ast_file to tiptopgp;
grant delete on ast_file to tiptopgp;
grant insert on ast_file to tiptopgp;
grant index on ast_file to public;
grant select on ast_file to ods;
