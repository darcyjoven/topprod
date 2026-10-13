/*
================================================================================
檔案代號:hrcs_file
檔案名稱:标准薪资日历
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcs_file
(
hrcs01      varchar2(20) NOT NULL,   /*公司编号                               */
hrcs02      number(5) NOT NULL,      /*年度                                   */
hrcs03      date NOT NULL,           /*日期                                   */
hrcs04      varchar2(20),            /*星期                                   */
hrcs05      varchar2(20),            /*日历类型                               */
hrcs06      varchar2(255),           /*备注                                   */
hrcsacti    varchar2(1),             /*资料有效否                             */
hrcsuser    varchar2(10),            /*资料所有者                             */
hrcsgrup    varchar2(10),            /*资料所有部门                           */
hrcsmodu    varchar2(10),            /*资料修改者                             */
hrcsdate    date,                    /*最近修改日                             */
hrcsoriu    varchar2(10),            /*资料建立者                             */
hrcsorig    varchar2(10),            /*资料建立部门                           */
hrcsud01    varchar2(255),           /*自订栏位-Textedit                      */
hrcsud02    varchar2(40),            /*自订栏位-文字                          */
hrcsud03    varchar2(40),            /*自订栏位-文字                          */
hrcsud04    varchar2(40),            /*自订栏位-文字                          */
hrcsud05    varchar2(40),            /*自订栏位-文字                          */
hrcsud06    varchar2(40),            /*自订栏位-文字                          */
hrcsud07    number(15,3),            /*自订栏位-数值                          */
hrcsud08    number(15,3),            /*自订栏位-数值                          */
hrcsud09    number(15,3),            /*自订栏位-数值                          */
hrcsud10    number(10),              /*自订栏位-整数                          */
hrcsud11    number(10),              /*自订栏位-整数                          */
hrcsud12    number(10),              /*自订栏位-整数                          */
hrcsud13    date,                    /*自订栏位-日期                          */
hrcsud14    date,                    /*自订栏位-日期                          */
hrcsud15    date                     /*自订栏位-日期                          */
);

alter table hrcs_file add  constraint tpc_hrcs_pk primary key  (hrcs01,hrcs02,hrcs03) enable validate;
grant select on hrcs_file to tiptopgp;
grant update on hrcs_file to tiptopgp;
grant delete on hrcs_file to tiptopgp;
grant insert on hrcs_file to tiptopgp;
grant index on hrcs_file to public;
grant select on hrcs_file to ods;
