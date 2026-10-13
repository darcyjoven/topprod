/*
================================================================================
檔案代號:vaa_file
檔案名稱:APS  工作模式
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vaa_file
(
vaa01       varchar2(60) DEFAULT ' ' NOT NULL, /*工作模式编号*/
vaa02       number(9) DEFAULT '0' NOT NULL, /*开始时间(整数)*/
vaa03       number(9) DEFAULT '0' NOT NULL, /*结束时间(整数)*/
vaa04       number(1),               /*工作类型设置                           */
vaa05       varchar2(80),            /*工作模式名称                           */
vaa06       varchar2(80),            /*工作模式描述                           */
vaa07       varchar2(60),            /*APS保留字段文字                        */
vaa08       varchar2(60),            /*APS保留字段文字                        */
vaa09       varchar2(60),            /*APS保留字段文字                        */
vaa10       number(9),               /*APS保留字段数值                        */
vaa11       number(18,8),            /*APS保留字段浮点数                      */
vaa12       number(18,8),            /*APS保留字段浮点数                      */
vaa13       date,                    /*APS保留字段日期                        */
vaa14       date,                    /*APS保留字段日期                        */
vaalegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vaaplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vaa_file add  constraint vaa_pk primary key  (vaalegal,vaaplant,vaa01,vaa02) enable validate;
grant select on vaa_file to tiptopgp;
grant update on vaa_file to tiptopgp;
grant delete on vaa_file to tiptopgp;
grant insert on vaa_file to tiptopgp;
grant index on vaa_file to public;
grant select on vaa_file to ods;
