/*
================================================================================
檔案代號:vaf_file
檔案名稱:aps倉庫主檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vaf_file
(
vaf01       varchar2(10) DEFAULT ' ' NOT NULL, /*仓库编号*/
vaf02       varchar2(40),            /*仓库名称                               */
vaf03       number(5),               /*优先顺序                               */
vaf04       number(1),               /*存货是否不可转移                       */
vaf05       number(1),               /*是否为主仓位                           */
vaf06       number(1),               /*是否为客供料                           */
vaf07       number(1),               /*是否受供给法则限制, 0;否 1:是          */
vaf08       varchar2(60),            /*APS保留字段文字                        */
vaf09       varchar2(60),            /*APS保留字段文字                        */
vaf10       varchar2(60),            /*APS保留字段文字                        */
vaf11       number(9),               /*APS保留字段数值                        */
vaf12       number(18,8),            /*APS保留字段浮点数                      */
vaf13       number(18,8),            /*APS保留字段浮点数                      */
vaf14       date,                    /*APS保留字段日期                        */
vaf15       date,                    /*APS保留字段日期                        */
vaflegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vafplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vaf_file add  constraint vaf_pk primary key  (vaflegal,vafplant,vaf01) enable validate;
grant select on vaf_file to tiptopgp;
grant update on vaf_file to tiptopgp;
grant delete on vaf_file to tiptopgp;
grant insert on vaf_file to tiptopgp;
grant index on vaf_file to public;
grant select on vaf_file to ods;
