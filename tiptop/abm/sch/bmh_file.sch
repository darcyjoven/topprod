/*
================================================================================
檔案代號:bmh_file
檔案名稱:BOM底稿产品结构插件位置
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bmh_file
(
bmh01       varchar2(40) DEFAULT ' ' NOT NULL, /*主件料件编号*/
bmh02       number(5) DEFAULT '0' NOT NULL, /*项次*/
bmh03       varchar2(40) DEFAULT ' ' NOT NULL, /*元件料件编号*/
bmh04       date DEFAULT sysdate NOT NULL, /*生效日期*/
bmh05       number(5) DEFAULT '0' NOT NULL, /*行序*/
bmh06       varchar2(10),            /*插件位置                               */
bmh07       number(16,8),            /*组成用量                               */
bmh08       varchar2(20) DEFAULT ' ' NOT NULL, /*特性代码*/
bmh09       varchar2(20) DEFAULT ' ' NOT NULL, /*底稿编号*/
bmh10       number(10) DEFAULT '0' NOT NULL /*项次*/
);

alter table bmh_file add  constraint bmh_pk primary key  (bmh01,bmh02,bmh03,bmh04,bmh05,bmh08,bmh09,bmh10) enable validate;
grant select on bmh_file to tiptopgp;
grant update on bmh_file to tiptopgp;
grant delete on bmh_file to tiptopgp;
grant insert on bmh_file to tiptopgp;
grant index on bmh_file to public;
grant select on bmh_file to ods;
