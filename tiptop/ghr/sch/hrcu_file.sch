/*
================================================================================
檔案代號:hrcu_file
檔案名稱:个税税表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcu_file
(
hrcu01      varchar2(20) NOT NULL,   /*税表编号                               */
hrcu02      varchar2(100),           /*税表名称                               */
hrcu03      varchar2(1),             /*是否1元以下纳税额按0元计税             */
hrcu04      varchar2(1),             /*包含1元                                */
hrcu05      number(5) NOT NULL,      /*级数                                   */
hrcu06      number(15,3),            /*本税最低额                             */
hrcu07      number(15,3),            /*本税最高额                             */
hrcu08      number(15,3),            /*薪资不含税最低额                       */
hrcu09      number(15,3),            /*薪资不含税最高额                       */
hrcu10      number(15,3),            /*税率(%)                                */
hrcu11      number(15,3),            /*速算扣除数                             */
hrcu12      varchar2(255),           /*备注                                   */
hrcuacti    varchar2(1),             /*资料有效码                             */
hrcuuser    varchar2(10),            /*资料所有者                             */
hrcugrup    varchar2(10),            /*资料所有群                             */
hrcumodu    varchar2(10),            /*资料更改者                             */
hrcudate    date,                    /*最近修改日                             */
hrcuoriu    varchar2(10),            /*资料建立者                             */
hrcuorig    varchar2(10),            /*资料建立部门                           */
hrcuud01    varchar2(255),           /*自订栏位-Textedit                      */
hrcuud02    varchar2(40),            /*自订栏位-文字                          */
hrcuud03    varchar2(40),            /*自订栏位-文字                          */
hrcuud04    varchar2(40),            /*自订栏位-文字                          */
hrcuud05    varchar2(40),            /*自订栏位-文字                          */
hrcuud06    varchar2(40),            /*自订栏位-文字                          */
hrcuud07    number(15,3),            /*自订栏位-数值                          */
hrcuud08    number(15,3),            /*自订栏位-数值                          */
hrcuud09    number(15,3),            /*自订栏位-数值                          */
hrcuud10    number(10),              /*自订栏位-整数                          */
hrcuud11    number(10),              /*自订栏位-整数                          */
hrcuud12    number(10),              /*自订栏位-整数                          */
hrcuud13    date,                    /*自订栏位-日期                          */
hrcuud14    date,                    /*自订栏位-日期                          */
hrcuud15    date                     /*自订栏位-日期                          */
);

alter table hrcu_file add  constraint tpc_hrcu_pk primary key  (hrcu01,hrcu05) enable validate;
grant select on hrcu_file to tiptopgp;
grant update on hrcu_file to tiptopgp;
grant delete on hrcu_file to tiptopgp;
grant insert on hrcu_file to tiptopgp;
grant index on hrcu_file to public;
grant select on hrcu_file to ods;
