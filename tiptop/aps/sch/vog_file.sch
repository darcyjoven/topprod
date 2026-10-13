/*
================================================================================
檔案代號:vog_file
檔案名稱:aps(資源負荷)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vog_file
(
vog00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
vog01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
vog02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
vog03       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
vog04       varchar2(80) DEFAULT ' ' NOT NULL, /*工艺路线*/
vog05       varchar2(60) DEFAULT ' ' NOT NULL, /*工艺序号*/
vog06       varchar2(40) DEFAULT ' ' NOT NULL, /*元件料号*/
vog07       date,                    /*需求时点                               */
vog08       varchar2(6),             /*作业编号                               */
vog09       varchar2(60),            /*APS保留字段文字                        */
vog10       varchar2(60),            /*APS保留字段文字                        */
vog11       varchar2(60),            /*APS保留字段文字                        */
vog12       number(9),               /*APS保留字段数值                        */
vog13       number(18,8),            /*APS保留字段浮点数                      */
vog14       number(18,8),            /*APS保留字段浮点数                      */
vog15       date,                    /*APS保留字段日期                        */
vog16       date,                    /*APS保留字段日期                        */
voglegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vogplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属工厂*/
vog012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table vog_file add  constraint vog_pk primary key  (vog00,vog01,vog02,vog03,vog04,vog05,vog06,vog012) enable validate;
grant select on vog_file to tiptopgp;
grant update on vog_file to tiptopgp;
grant delete on vog_file to tiptopgp;
grant insert on vog_file to tiptopgp;
grant index on vog_file to public;
grant select on vog_file to ods;
