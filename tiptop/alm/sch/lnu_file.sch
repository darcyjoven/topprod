/*
================================================================================
檔案代號:lnu_file
檔案名稱:合同场地信息档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lnu_file
(
lnu01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同编号*/
lnu02       varchar2(20),            /*合同版本号                             */
lnu03       varchar2(20) DEFAULT ' ' NOT NULL, /*场地编号*/
lnu04       number(20,6),            /*经营面积                               */
lnu05       number(20,6),            /*建筑面积                               */
lnulegal    varchar2(10) NOT NULL,   /*所属法人                               */
lnuplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
lnu06       number(5) DEFAULT '0' NOT NULL, /*项次*/
lnu07       number(20,6),            /*測量面積                               */
lnu08       varchar2(10),            /*楼栋                                   */
lnu09       varchar2(10),            /*楼层                                   */
lnu10       varchar2(10)             /*区域                                   */
);

alter table lnu_file add  constraint lnu_pk primary key  (lnu01,lnu06) enable validate;
grant select on lnu_file to tiptopgp;
grant update on lnu_file to tiptopgp;
grant delete on lnu_file to tiptopgp;
grant insert on lnu_file to tiptopgp;
grant index on lnu_file to public;
grant select on lnu_file to ods;
