/*
================================================================================
檔案代號:vbl_file
檔案名稱:工模具群組明細檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vbl_file
(
vbl01       varchar2(60) NOT NULL,   /*工模具群组编号                         */
vbl02       varchar2(60) NOT NULL,   /*工模具编号                             */
vbl03       varchar2(60),            /*APS保留字段文字                        */
vbl04       varchar2(60),            /*APS保留字段文字                        */
vbl05       varchar2(60),            /*APS保留字段文字                        */
vbl06       number(9),               /*APS保留字段数值                        */
vbl07       number(18,8),            /*APS保留字段浮点数                      */
vbl08       number(18,8),            /*APS保留字段浮点数                      */
vbl09       date,                    /*APS保留字段日期                        */
vbl10       date,                    /*APS保留字段日期                        */
vbllegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vblplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vbl_file add  constraint vbl_pk primary key  (vbllegal,vblplant,vbl01,vbl02) enable validate;
grant select on vbl_file to tiptopgp;
grant update on vbl_file to tiptopgp;
grant delete on vbl_file to tiptopgp;
grant insert on vbl_file to tiptopgp;
grant index on vbl_file to public;
grant select on vbl_file to ods;
