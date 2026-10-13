/*
================================================================================
檔案代號:ljn_file
檔案名稱:合同变更场地资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ljn_file
(
ljn01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同变更单号*/
ljn02       number(5),               /*合同版本                               */
ljn03       number(5) DEFAULT '0' NOT NULL, /*项次*/
ljn04       varchar2(20),            /*场地编号                               */
ljn05       varchar2(10),            /*楼栋编号                               */
ljn06       varchar2(10),            /*楼层编号                               */
ljn07       varchar2(10),            /*区域编号                               */
ljn08       number(20,6),            /*建筑面积                               */
ljn09       number(20,6),            /*測量面積                               */
ljn10       number(20,6),            /*经营面积                               */
ljnlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
ljnplant    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table ljn_file add  constraint ljn_pk primary key  (ljn01,ljn03) enable validate;
grant select on ljn_file to tiptopgp;
grant update on ljn_file to tiptopgp;
grant delete on ljn_file to tiptopgp;
grant insert on ljn_file to tiptopgp;
grant index on ljn_file to public;
grant select on ljn_file to ods;
