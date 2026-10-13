/*
================================================================================
檔案代號:hrdf_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdf_file
(
hrdf01      varchar2(20) NOT NULL,   /*流水码                                 */
hrdf02      varchar2(50),            /*员工ID                                 */
hrdf03      date,                    /*计件日期                               */
hrdf04      number(15,2),            /*金额                                   */
hrdf05      varchar2(20),            /*状态                                   */
hrdf06      varchar2(1),             /*是否关账                               */
hrdf07      varchar2(100),           /*关账月份                               */
hrdfacti    varchar2(1),             /*资料有效码                             */
hrdfuser    varchar2(10),            /*资料所有者                             */
hrdfgrup    varchar2(10),            /*资料所有群                             */
hrdfmodu    varchar2(10),            /*资料更改者                             */
hrdfdate    date,                    /*最近修改日                             */
hrdforiu    varchar2(10),            /*资料建立者                             */
hrdforig    varchar2(10),            /*资料建立部门                           */
hrdfud01    varchar2(255),           /*自订栏位-Textedit                      */
hrdfud02    varchar2(40),            /*自订栏位-文字                          */
hrdfud03    varchar2(40),            /*自订栏位-文字                          */
hrdfud04    varchar2(40),            /*自订栏位-文字                          */
hrdfud05    varchar2(40),            /*自订栏位-文字                          */
hrdfud06    varchar2(40),            /*自订栏位-文字                          */
hrdfud07    number(15,3),            /*自订栏位-数值                          */
hrdfud08    number(15,3),            /*自订栏位-数值                          */
hrdfud09    number(15,3),            /*自订栏位-数值                          */
hrdfud10    number(10),              /*自订栏位-整数                          */
hrdfud11    number(10),              /*自订栏位-整数                          */
hrdfud12    number(10),              /*自订栏位-整数                          */
hrdfud13    date,                    /*自订栏位-日期                          */
hrdfud14    date,                    /*自订栏位-日期                          */
hrdfud15    date                     /*自订栏位-日期                          */
);

alter table hrdf_file add  constraint tpc_hrdf_pk primary key  (hrdf01) enable validate;
grant select on hrdf_file to tiptopgp;
grant update on hrdf_file to tiptopgp;
grant delete on hrdf_file to tiptopgp;
grant insert on hrdf_file to tiptopgp;
grant index on hrdf_file to public;
grant select on hrdf_file to ods;
