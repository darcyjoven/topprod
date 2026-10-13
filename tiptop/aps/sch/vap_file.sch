/*
================================================================================
檔案代號:vap_file
檔案名稱:aps(投料點)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vap_file
(
vap01       varchar2(40) DEFAULT ' ' NOT NULL, /*主件品号*/
vap02       varchar2(40) DEFAULT ' ' NOT NULL, /*元件品号*/
vap03       varchar2(80) DEFAULT ' ' NOT NULL, /*工艺路线*/
vap04       varchar2(60),            /*加工序号                               */
vap05       varchar2(6),             /*作业编号                               */
vap06       varchar2(60),            /*APS保留字段文字                        */
vap07       varchar2(60),            /*APS保留字段文字                        */
vap08       varchar2(60),            /*APS保留字段文字                        */
vap09       number(9),               /*APS保留字段数值                        */
vap10       number(18,8),            /*APS保留字段浮点数                      */
vap11       number(18,8),            /*APS保留字段浮点数                      */
vap12       date,                    /*APS保留字段日期                        */
vap13       date,                    /*APS保留字段日期                        */
vaplegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vapplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vap_file add  constraint vap_pk primary key  (vaplegal,vapplant,vap01,vap02,vap03) enable validate;
grant select on vap_file to tiptopgp;
grant update on vap_file to tiptopgp;
grant delete on vap_file to tiptopgp;
grant insert on vap_file to tiptopgp;
grant index on vap_file to public;
grant select on vap_file to ods;
