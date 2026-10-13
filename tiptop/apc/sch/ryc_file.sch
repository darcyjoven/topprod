/*
================================================================================
檔案代號:ryc_file
檔案名稱:收银机资料维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ryc_file
(
ryc01       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心代码*/
ryc02       varchar2(10) DEFAULT ' ' NOT NULL, /*收银机代码*/
ryc03       varchar2(80),            /*收银机名称                             */
ryc04       varchar2(20),            /*收款机IP地址                           */
ryc05       varchar2(1),             /*POS传输机器                            */
rycacti     varchar2(1),             /*资料有效码                             */
ryccrat     date,                    /*资料更改日                             */
rycdate     date,                    /*最近更改日                             */
rycgrup     varchar2(10),            /*资料所有部门                           */
rycmodu     varchar2(10),            /*资料更改者                             */
rycuser     varchar2(10),            /*资料所有者                             */
rycorig     varchar2(10),            /*资料建立部门                           */
rycoriu     varchar2(10),            /*资料建立者                             */
ryc06       varchar2(1),
ryc07       varchar2(1) DEFAULT 'N' NOT NULL, /*使用电子发票否*/
ryc08       number(5) DEFAULT '0' NOT NULL, /*电子发票安全库存量*/
rycpos      varchar2(1) DEFAULT ' ' NOT NULL /*已传POS否*/
);

alter table ryc_file add  constraint ryc_pk primary key  (ryc01,ryc02) enable validate;
grant select on ryc_file to tiptopgp;
grant update on ryc_file to tiptopgp;
grant delete on ryc_file to tiptopgp;
grant insert on ryc_file to tiptopgp;
grant index on ryc_file to public;
grant select on ryc_file to ods;
