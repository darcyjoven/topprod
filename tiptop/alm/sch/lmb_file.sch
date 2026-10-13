/*
================================================================================
檔案代號:lmb_file
檔案名稱:楼栋基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmb_file
(
lmb01       varchar2(10),            /*no use 原门店编号                      */
lmb02       varchar2(10) DEFAULT ' ' NOT NULL, /*楼栋编号*/
lmb03       varchar2(30),            /*楼栋名称                               */
lmb04       number(20,6),            /*经营面积                               */
lmb05       number(20,6),            /*建筑面积                               */
lmb06       varchar2(1),             /*有效否                                 */
lmblegal    varchar2(10) NOT NULL,   /*所属法人                               */
lmbstore    varchar2(10) DEFAULT ' ' NOT NULL, /*门店编号*/
lmb07       number(20,6),            /*图纸建筑面积                           */
lmb08       number(20,6),            /*图纸测量面积                           */
lmb09       number(20,6)             /*測量面積                               */
);

alter table lmb_file add  constraint lmb_pk primary key  (lmbstore,lmb02) enable validate;
grant select on lmb_file to tiptopgp;
grant update on lmb_file to tiptopgp;
grant delete on lmb_file to tiptopgp;
grant insert on lmb_file to tiptopgp;
grant index on lmb_file to public;
grant select on lmb_file to ods;
