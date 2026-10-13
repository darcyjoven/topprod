/*
================================================================================
檔案代號:tag_file
檔案名稱:新旧会计科目对应关系档案
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tag_file
(
tag01       number(5) DEFAULT '0' NOT NULL, /*年度*/
tag02       varchar2(5) DEFAULT ' ' NOT NULL, /*旧帐套*/
tag03       varchar2(24) DEFAULT ' ' NOT NULL, /*旧会计科目*/
tag04       varchar2(5) DEFAULT ' ' NOT NULL, /*新帐套*/
tag05       varchar2(24) DEFAULT ' ' NOT NULL, /*新会计科目*/
tagacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
tag06       varchar2(1) DEFAULT '1' NOT NULL /*使用时点*/
);

alter table tag_file add  constraint tag_pk primary key  (tag01,tag02,tag03,tag04,tag05,tag06) enable validate;
grant select on tag_file to tiptopgp;
grant update on tag_file to tiptopgp;
grant delete on tag_file to tiptopgp;
grant insert on tag_file to tiptopgp;
grant index on tag_file to public;
grant select on tag_file to ods;
