/*
================================================================================
檔案代號:lny_file
檔案名稱:合同其它品牌单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lny_file
(
lny01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同编号*/
lny02       varchar2(20),            /*合同版本号                             */
lny03       varchar2(10) DEFAULT ' ' NOT NULL, /*品牌编号*/
lnylegal    varchar2(10) NOT NULL,   /*所属法人                               */
lnyplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
lny04       number(5) DEFAULT '0' NOT NULL /*项次*/
);

alter table lny_file add  constraint lny_pk primary key  (lny01,lny04) enable validate;
grant select on lny_file to tiptopgp;
grant update on lny_file to tiptopgp;
grant delete on lny_file to tiptopgp;
grant insert on lny_file to tiptopgp;
grant index on lny_file to public;
grant select on lny_file to ods;
