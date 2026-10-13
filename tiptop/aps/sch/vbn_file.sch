/*
================================================================================
檔案代號:vbn_file
檔案名稱:工模具保修明細檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vbn_file
(
vbn01       varchar2(60) NOT NULL,   /*工模具编号                             */
vbn02       date NOT NULL,           /*开始时间                               */
vbn03       date,                    /*结束时间                               */
vbn04       varchar2(60),            /*APS保留字段文字                        */
vbn05       varchar2(60),            /*APS保留字段文字                        */
vbn06       varchar2(60),            /*APS保留字段文字                        */
vbn07       number(9),               /*APS保留字段数值                        */
vbn08       number(18,8),            /*APS保留字段浮点数                      */
vbn09       number(18,8),            /*APS保留字段浮点数                      */
vbn10       date,                    /*APS保留字段日期                        */
vbn11       date,                    /*APS保留字段日期                        */
vbnlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vbnplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vbn_file add  constraint vbn_pk primary key  (vbnlegal,vbnplant,vbn01,vbn02) enable validate;
grant select on vbn_file to tiptopgp;
grant update on vbn_file to tiptopgp;
grant delete on vbn_file to tiptopgp;
grant insert on vbn_file to tiptopgp;
grant index on vbn_file to public;
grant select on vbn_file to ods;
