/*
================================================================================
檔案代號:vas_file
檔案名稱:aps(顧客)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vas_file
(
vas01       varchar2(10) DEFAULT ' ' NOT NULL, /*客户编号*/
vas02       varchar2(10),            /*客户群组编号                           */
vas03       varchar2(40),            /*客户名称                               */
vas04       varchar2(10),            /*客户群组名称                           */
vas05       varchar2(60),            /*APS保留字段文字                        */
vas06       varchar2(60),            /*APS保留字段文字                        */
vas07       varchar2(60),            /*APS保留字段文字                        */
vas08       number(9),               /*APS保留字段数值                        */
vas09       number(18,8),            /*APS保留字段浮点数                      */
vas10       number(18,8),            /*APS保留字段浮点数                      */
vas11       date,                    /*APS保留字段日期                        */
vas12       date,                    /*APS保留字段日期                        */
vaslegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vasplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vas_file add  constraint vas_pk primary key  (vaslegal,vasplant,vas01) enable validate;
grant select on vas_file to tiptopgp;
grant update on vas_file to tiptopgp;
grant delete on vas_file to tiptopgp;
grant insert on vas_file to tiptopgp;
grant index on vas_file to public;
grant select on vas_file to ods;
