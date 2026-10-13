/*
================================================================================
檔案代號:lmy_file
檔案名稱:区域基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmy_file
(
lmy01       varchar2(10) DEFAULT ' ' NOT NULL, /*楼栋编号*/
lmy02       varchar2(10) DEFAULT ' ' NOT NULL, /*楼层编号*/
lmy03       varchar2(10) DEFAULT ' ' NOT NULL, /*区域编号*/
lmy04       varchar2(30),            /*区域名称                               */
lmy05       number(20,6),            /*建筑面积                               */
lmy06       number(20,6),            /*測量面積                               */
lmy07       number(20,6),            /*经营面积                               */
lmyacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lmylegal    varchar2(10),            /*所属法人                               */
lmystore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table lmy_file add  constraint lmy_pk primary key  (lmystore,lmy01,lmy02,lmy03) enable validate;
grant select on lmy_file to tiptopgp;
grant update on lmy_file to tiptopgp;
grant delete on lmy_file to tiptopgp;
grant insert on lmy_file to tiptopgp;
grant index on lmy_file to public;
grant select on lmy_file to ods;
