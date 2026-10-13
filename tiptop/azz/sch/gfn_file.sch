/*
================================================================================
檔案代號:gfn_file
檔案名稱:动态图表可用属性配置文件
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gfn_file
(
gfn01       varchar2(30) DEFAULT ' ' NOT NULL, /*图表代码*/
gfn02       varchar2(20) DEFAULT ' ' NOT NULL, /*图表名称*/
gfn03       varchar2(50) DEFAULT ' ' NOT NULL, /*属性名称*/
gfn04       number(5) DEFAULT '1' NOT NULL, /*序号*/
gfn05       varchar2(255) DEFAULT ' ' NOT NULL, /*属性值*/
gfn06       varchar2(1) DEFAULT ' ', /*No use                                 */
gfn07       varchar2(1) DEFAULT ' ' NOT NULL /*客制码*/
);

alter table gfn_file add  constraint gfn_pk primary key  (gfn01,gfn02,gfn03,gfn04) enable validate;
grant select on gfn_file to tiptopgp;
grant update on gfn_file to tiptopgp;
grant delete on gfn_file to tiptopgp;
grant insert on gfn_file to tiptopgp;
grant index on gfn_file to public;
grant select on gfn_file to ods;
