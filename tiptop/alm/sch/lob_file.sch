/*
================================================================================
檔案代號:lob_file
檔案名稱:合同变更数据档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lob_file
(
lob01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同编号*/
lob02       varchar2(20) DEFAULT ' ' NOT NULL, /*合同版本号*/
lob03       varchar2(20) DEFAULT ' ' NOT NULL, /*场地编号*/
lob04       number(20,2),            /*经营面积                               */
lob05       number(20,2),            /*建筑面积                               */
loblegal    varchar2(10) NOT NULL,   /*所属法人                               */
lobplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table lob_file add  constraint lob_pk primary key  (lob01,lob02,lob03) enable validate;
grant select on lob_file to tiptopgp;
grant update on lob_file to tiptopgp;
grant delete on lob_file to tiptopgp;
grant insert on lob_file to tiptopgp;
grant index on lob_file to public;
grant select on lob_file to ods;
