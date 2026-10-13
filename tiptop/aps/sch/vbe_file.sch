/*
================================================================================
檔案代號:vbe_file
檔案名稱:APS锁定使用设备
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vbe_file
(
vbe01       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
vbe02       varchar2(80) DEFAULT ' ' NOT NULL, /*工艺路线*/
vbe03       varchar2(60) DEFAULT ' ' NOT NULL, /*加工序号*/
vbe04       varchar2(6) DEFAULT ' ' NOT NULL, /*作业编号*/
vbe05       varchar2(10) DEFAULT ' ' NOT NULL, /*资源编号*/
vbe06       number(15,3),            /*未完成量                               */
vbe07       number(1),               /*是否排程                               */
vbeplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
vbelegal    varchar2(10) NOT NULL,   /*所属法人                               */
vbe08       varchar2(60),            /*APS保留字段文字                        */
vbe09       varchar2(60),            /*APS保留字段文字                        */
vbe10       varchar2(60),            /*APS保留字段文字                        */
vbe11       number(9),               /*APS保留字段数值                        */
vbe12       number(18,8),            /*APS保留字段浮点数                      */
vbe13       number(18,8),            /*APS保留字段浮点数                      */
vbe14       date,                    /*APS保留字段日期                        */
vbe15       date,                    /*APS保留字段日期                        */
vbe16       varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table vbe_file add  constraint vbe_pk primary key  (vbelegal,vbeplant,vbe01,vbe02,vbe03,vbe04,vbe05,vbe16) enable validate;
grant select on vbe_file to tiptopgp;
grant update on vbe_file to tiptopgp;
grant delete on vbe_file to tiptopgp;
grant insert on vbe_file to tiptopgp;
grant index on vbe_file to public;
grant select on vbe_file to ods;
