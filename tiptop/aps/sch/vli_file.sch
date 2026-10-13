/*
================================================================================
檔案代號:vli_file
檔案名稱:atp插單記錄檔
檔案目的:記錄atp查詢資訊(產品編號,數量,預計達成日0
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vli_file
(
vli01       varchar2(10) NOT NULL,   /*APS版本                                */
vli02       varchar2(10) NOT NULL,   /*储存版本                               */
vli03       varchar2(40) NOT NULL,   /*产品编号                               */
vli04       number(5) DEFAULT '1' NOT NULL, /*序号*/
vli05       number(15,3) DEFAULT '0' NOT NULL, /*ATP插单数量*/
vli06       varchar2(10) DEFAULT ' ' NOT NULL, /*客户需求日*/
vli07       varchar2(10) DEFAULT ' ' NOT NULL, /*业务员编号*/
vli08       varchar2(10) DEFAULT ' ' NOT NULL, /*客户编号*/
vli09       number(5) DEFAULT '1' NOT NULL, /*优先顺序*/
vli10       varchar2(10),            /*预计可递交日                           */
vli11       varchar2(10),            /*预计递交状况                           */
vliplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
vlilegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table vli_file add  constraint vli_pk primary key  (vli01,vli02,vli03,vli04) enable validate;
grant select on vli_file to tiptopgp;
grant update on vli_file to tiptopgp;
grant delete on vli_file to tiptopgp;
grant insert on vli_file to tiptopgp;
grant index on vli_file to public;
grant select on vli_file to ods;
