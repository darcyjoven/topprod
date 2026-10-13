/*
================================================================================
檔案代號:hrcz_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcz_file
(
hrcz01      varchar2(20) NOT NULL,   /*周期性薪资编码                         */
hrcz02      varchar2(50),            /*周期性薪资名称                         */
hrcz03      varchar2(20),            /*所属公司ID                             */
hrcz04      date,                    /*创建日期                               */
hrcz05      varchar2(255),           /*备注                                   */
hrczacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrczuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrczgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrczmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrczdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrczoriu    varchar2(10),            /*资料建立者                             */
hrczorig    varchar2(10),            /*资料建立部门                           */
hrczud01    varchar2(255),           /*自订栏位-Textedit                      */
hrczud02    varchar2(40),            /*自订栏位-文字                          */
hrczud03    varchar2(40),            /*自订栏位-文字                          */
hrczud04    varchar2(40),            /*自订栏位-文字                          */
hrczud05    varchar2(40),            /*自订栏位-文字                          */
hrczud06    varchar2(40),            /*自订栏位-文字                          */
hrczud07    number(15,3),            /*自订栏位-数值                          */
hrczud08    number(15,3),            /*自订栏位-数值                          */
hrczud09    number(15,3),            /*自订栏位-数值                          */
hrczud10    number(10),              /*自订栏位-整数                          */
hrczud11    number(10),              /*自订栏位-整数                          */
hrczud12    number(10),              /*自订栏位-整数                          */
hrczud13    date,                    /*自订栏位-日期                          */
hrczud14    date,                    /*自订栏位-日期                          */
hrczud15    date                     /*自订栏位-日期                          */
);

alter table hrcz_file add  constraint tpc_hrcz_pk primary key  (hrcz01) enable validate;
grant select on hrcz_file to tiptopgp;
grant update on hrcz_file to tiptopgp;
grant delete on hrcz_file to tiptopgp;
grant insert on hrcz_file to tiptopgp;
grant index on hrcz_file to public;
grant select on hrcz_file to ods;
