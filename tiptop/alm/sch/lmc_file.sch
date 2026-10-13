/*
================================================================================
檔案代號:lmc_file
檔案名稱:楼层基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmc_file
(
lmc01       varchar2(10),            /*no use 原门店编号                      */
lmc02       varchar2(10) DEFAULT ' ' NOT NULL, /*楼栋编号*/
lmc03       varchar2(10) DEFAULT ' ' NOT NULL, /*楼层编号*/
lmc04       varchar2(30),            /*楼层名称                               */
lmc05       number(20,6),            /*经营面积                               */
lmc06       number(20,6),            /*建筑面积                               */
lmc07       varchar2(1),             /*有效否                                 */
lmclegal    varchar2(10) NOT NULL,   /*所属法人                               */
lmcstore    varchar2(10) DEFAULT ' ' NOT NULL, /*门店编号*/
lmc08       number(20,6),            /*图纸建筑面积                           */
lmc09       number(20,6),            /*图纸测量面积                           */
lmc10       number(20,6),            /*測量面積                               */
lmc11       number(5,2),             /*建筑公摊率(%)                          */
lmc12       number(5,2)              /*公摊系数                               */
);

alter table lmc_file add  constraint lmc_pk primary key  (lmcstore,lmc02,lmc03) enable validate;
grant select on lmc_file to tiptopgp;
grant update on lmc_file to tiptopgp;
grant delete on lmc_file to tiptopgp;
grant insert on lmc_file to tiptopgp;
grant index on lmc_file to public;
grant select on lmc_file to ods;
