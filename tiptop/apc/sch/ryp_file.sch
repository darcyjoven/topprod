/*
================================================================================
檔案代號:ryp_file
檔案名稱:POS模块基本资料档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table ryp_file
(
ryp01       varchar2(40) DEFAULT ' ' NOT NULL, /*模块编号*/
ryp02       varchar2(1) DEFAULT ' ' NOT NULL, /*模块等级*/
ryp03       varchar2(40),            /*上级模块                               */
rypacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
rypcrat     date,                    /*资料创建日                             */
rypdate     date,                    /*最近更改日                             */
rypgrup     varchar2(10),            /*资料所有群                             */
rypmodu     varchar2(10),            /*资料更改者                             */
ryporig     varchar2(10),            /*资料建立部门                           */
ryporiu     varchar2(10),            /*资料建立者                             */
ryppos      varchar2(1) DEFAULT ' ' NOT NULL, /*已传POS否*/
rypuser     varchar2(10),            /*资料所有者                             */
ryp04       varchar2(1) DEFAULT ' ' NOT NULL, /*功能类型*/
ryp05       varchar2(40),            /*程序名称                               */
ryp06       varchar2(40)             /*参数                                   */
);

alter table ryp_file add  constraint ryp_pk primary key  (ryp01) enable validate;
grant select on ryp_file to tiptopgp;
grant update on ryp_file to tiptopgp;
grant delete on ryp_file to tiptopgp;
grant insert on ryp_file to tiptopgp;
grant index on ryp_file to public;
grant select on ryp_file to ods;
