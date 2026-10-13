/*
================================================================================
檔案代號:hreb_file
檔案名稱:薪酬预算制定管理
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hreb_file
(
hreb00      varchar2(20) NOT NULL,   /*预算年度                               */
hreb01      varchar2(20) NOT NULL,   /*预算类别                               */
hreb02      number(15,2),            /*预算金额                               */
hreb03      number(15,2),            /*年预算总金额                           */
hreb04      varchar2(255),           /*备注                                   */
hrebacti    varchar2(1),             /*资料有效码                             */
hrebuser    varchar2(20),            /*资料所有者                             */
hrebgrup    varchar2(20),            /*资料所有群                             */
hrebmodu    varchar2(20),            /*资料更改者                             */
hrebdate    date,                    /*最近修改日                             */
hreboriu    varchar2(20),            /*资料建立者                             */
hreborig    varchar2(20),            /*资料建立部门                           */
hrebud01    varchar2(255),
hrebud02    varchar2(40),
hrebud03    varchar2(40),
hrebud04    varchar2(40),
hrebud05    varchar2(40),
hrebud06    varchar2(40),
hrebud07    number(15,3),
hrebud08    number(15,3),
hrebud09    number(15,3),
hrebud10    number(5),
hrebud11    number(5),
hrebud12    number(5),
hrebud13    date,
hrebud14    date,
hrebud15    date
);

alter table hreb_file add  constraint hreb_pk primary key  (hreb00,hreb01) enable validate;
grant select on hreb_file to tiptopgp;
grant update on hreb_file to tiptopgp;
grant delete on hreb_file to tiptopgp;
grant insert on hreb_file to tiptopgp;
grant index on hreb_file to public;
grant select on hreb_file to ods;
