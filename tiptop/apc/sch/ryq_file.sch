/*
================================================================================
檔案代號:ryq_file
檔案名稱:POS功能基本资料档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table ryq_file
(
ryq01       varchar2(40) DEFAULT ' ' NOT NULL, /*功能编号*/
ryq02       varchar2(40),            /*模块编号                               */
ryq03       varchar2(1) DEFAULT ' ' NOT NULL, /*是否支付方式*/
ryqacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
ryqcrat     date,                    /*资料创建日                             */
ryqdate     date,                    /*最近更改日                             */
ryqgrup     varchar2(10),            /*资料所有群                             */
ryqmodu     varchar2(10),            /*资料更改者                             */
ryqorig     varchar2(10),            /*资料建立部门                           */
ryqoriu     varchar2(10),            /*资料建立者                             */
ryqpos      varchar2(1) DEFAULT ' ' NOT NULL, /*已传POS否*/
ryquser     varchar2(10),            /*资料所有者                             */
ryq04       varchar2(1) DEFAULT ' ' NOT NULL, /*功能类型*/
ryq05       varchar2(40),            /*程序名称                               */
ryq06       varchar2(40)             /*参数                                   */
);

alter table ryq_file add  constraint ryq_pk primary key  (ryq01) enable validate;
grant select on ryq_file to tiptopgp;
grant update on ryq_file to tiptopgp;
grant delete on ryq_file to tiptopgp;
grant insert on ryq_file to tiptopgp;
grant index on ryq_file to public;
grant select on ryq_file to ods;
