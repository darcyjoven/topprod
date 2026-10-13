/*
================================================================================
檔案代號:vag_file
檔案名稱:aps儲位主檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vag_file
(
vag01       varchar2(10) DEFAULT ' ' NOT NULL, /*仓库编号*/
vag02       varchar2(10) DEFAULT ' ' NOT NULL, /*库位编号*/
vag03       varchar2(40),            /*库位名称                               */
vag04       number(5),               /*供给优先顺序                           */
vag05       number(1),               /*是否客供料                             */
vag06       number(1),               /*是否受供给法则限制, 0;否 1:是          */
vag07       varchar2(60),            /*APS保留字段文字                        */
vag08       varchar2(60),            /*APS保留字段文字                        */
vag09       varchar2(60),            /*APS保留字段文字                        */
vag10       number(9),               /*APS保留字段数值                        */
vag11       number(18,8),            /*APS保留字段浮点数                      */
vag12       number(18,8),            /*APS保留字段浮点数                      */
vag13       date,                    /*APS保留字段日期                        */
vag14       date,                    /*APS保留字段日期                        */
vaglegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vagplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vag_file add  constraint vag_pk primary key  (vaglegal,vagplant,vag01,vag02) enable validate;
grant select on vag_file to tiptopgp;
grant update on vag_file to tiptopgp;
grant delete on vag_file to tiptopgp;
grant insert on vag_file to tiptopgp;
grant index on vag_file to public;
grant select on vag_file to ods;
