/*
================================================================================
檔案代號:hrdo_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdo_file
(
hrdo01      varchar2(10) NOT NULL,   /*流水码                                 */
hrdo02      varchar2(20),            /*员工ID                                 */
hrdo03      date,                    /*设置日期                               */
hrdo04      varchar2(50),            /*开始薪资月                             */
hrdo05      varchar2(50),            /*失效薪资月                             */
hrdo06      varchar2(255),           /*备注                                   */
hrdoacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrdouser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrdogrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrdomodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrdodate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrdooriu    varchar2(10),            /*资料建立者                             */
hrdoorig    varchar2(10),            /*资料建立部门                           */
hrdoud01    varchar2(255),           /*自订栏位-Textedit                      */
hrdoud02    varchar2(40),            /*自订栏位-文字                          */
hrdoud03    varchar2(40),            /*自订栏位-文字                          */
hrdoud04    varchar2(40),            /*自订栏位-文字                          */
hrdoud05    varchar2(40),            /*自订栏位-文字                          */
hrdoud06    varchar2(40),            /*自订栏位-文字                          */
hrdoud07    number(15,3),            /*自订栏位-数值                          */
hrdoud08    number(15,3),            /*自订栏位-数值                          */
hrdoud09    number(15,3),            /*自订栏位-数值                          */
hrdoud10    number(10),              /*自订栏位-整数                          */
hrdoud11    number(10),              /*自订栏位-整数                          */
hrdoud12    number(10),              /*自订栏位-整数                          */
hrdoud13    date,                    /*自订栏位-日期                          */
hrdoud14    date,                    /*自订栏位-日期                          */
hrdoud15    date                     /*自订栏位-日期                          */
);

alter table hrdo_file add  constraint tpc_hrdo_pk primary key  (hrdo01) enable validate;
grant select on hrdo_file to tiptopgp;
grant update on hrdo_file to tiptopgp;
grant delete on hrdo_file to tiptopgp;
grant insert on hrdo_file to tiptopgp;
grant index on hrdo_file to public;
grant select on hrdo_file to ods;
