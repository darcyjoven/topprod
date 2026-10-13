/*
================================================================================
檔案代號:rtq_file
檔案名稱:合同經營品類單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rtq_file
(
rtq01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同编号*/
rtq02       number(5) DEFAULT '0' NOT NULL, /*版本号*/
rtq03       varchar2(10) DEFAULT ' ' NOT NULL, /*签订机构*/
rtq04       number(5) DEFAULT '0' NOT NULL, /*项次*/
rtq05       varchar2(1) DEFAULT ' ' NOT NULL, /*代码种类*/
                                     /*Code Categories 1:Brand Class. 2:Brand */
rtq06       varchar2(10),            /*品类代码                               */
rtqlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rtqplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table rtq_file add  constraint rtq_pk primary key  (rtq01,rtq02,rtq03,rtq04,rtq05,rtqplant) enable validate;
grant select on rtq_file to tiptopgp;
grant update on rtq_file to tiptopgp;
grant delete on rtq_file to tiptopgp;
grant insert on rtq_file to tiptopgp;
grant index on rtq_file to public;
grant select on rtq_file to ods;
