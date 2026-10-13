/*
================================================================================
檔案代號:vbc_file
檔案名稱:aps(加班資訊)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vbc_file
(
vbc01       varchar2(10) DEFAULT ' ' NOT NULL, /*资源编号*/
vbc02       date DEFAULT sysdate NOT NULL, /*日期*/
vbc03       number(9) DEFAULT '0' NOT NULL, /*开始时间(秒数)*/
vbc04       number(9),               /*结束时间(秒数)                         */
vbc05       number(1),               /*是否排程                               */
vbc031      varchar2(8) DEFAULT '00:00:00', /*加班开始时间*/
vbc041      varchar2(8) DEFAULT '00:00:00', /*加班结束时间*/
vbc06       number(1) DEFAULT '0' NOT NULL, /*是否为外包*/
vbc07       number(1) DEFAULT '0' NOT NULL, /*资源类型*/
vbc08       number(1),               /*加班型态                               */
vbc09       varchar2(60),            /*APS保留字段文字                        */
vbc10       varchar2(60),            /*APS保留字段文字                        */
vbc11       varchar2(60),            /*APS保留字段文字                        */
vbc12       number(9),               /*APS保留字段数值                        */
vbc13       number(18,8),            /*APS保留字段浮点数                      */
vbc14       number(18,8),            /*APS保留字段浮点数                      */
vbc15       date,                    /*APS保留字段日期                        */
vbc16       date,                    /*APS保留字段日期                        */
vbclegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vbcplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vbc_file add  constraint vbc_pk primary key  (vbclegal,vbcplant,vbc01,vbc02,vbc03,vbc06,vbc07) enable validate;
grant select on vbc_file to tiptopgp;
grant update on vbc_file to tiptopgp;
grant delete on vbc_file to tiptopgp;
grant insert on vbc_file to tiptopgp;
grant index on vbc_file to public;
grant select on vbc_file to ods;
