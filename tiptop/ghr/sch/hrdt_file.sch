/*
================================================================================
檔案代號:hrdt_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdt_file
(
hrdt01      varchar2(10) NOT NULL,   /*统筹体系编码                           */
hrdt02      varchar2(50),            /*统筹体系名称                           */
hrdt03      varchar2(20),            /*统筹区域                               */
hrdt04      varchar2(255),           /*备注                                   */
hrdtacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrdtuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrdtgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrdtmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrdtdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrdtoriu    varchar2(10),            /*资料建立者                             */
hrdtorig    varchar2(10),            /*资料建立部门                           */
hrdtud01    varchar2(255),           /*自订栏位-Textedit                      */
hrdtud02    varchar2(40),            /*自订栏位-文字                          */
hrdtud03    varchar2(40),            /*自订栏位-文字                          */
hrdtud04    varchar2(40),            /*自订栏位-文字                          */
hrdtud05    varchar2(40),            /*自订栏位-文字                          */
hrdtud06    varchar2(40),            /*自订栏位-文字                          */
hrdtud07    number(15,3),            /*自订栏位-数值                          */
hrdtud08    number(15,3),            /*自订栏位-数值                          */
hrdtud09    number(15,3),            /*自订栏位-数值                          */
hrdtud10    number(10),              /*自订栏位-整数                          */
hrdtud11    number(10),              /*自订栏位-整数                          */
hrdtud12    number(10),              /*自订栏位-整数                          */
hrdtud13    date,                    /*自订栏位-日期                          */
hrdtud14    date,                    /*自订栏位-日期                          */
hrdtud15    date                     /*自订栏位-日期                          */
);

alter table hrdt_file add  constraint tpc_hrdt_pk primary key  (hrdt01) enable validate;
grant select on hrdt_file to tiptopgp;
grant update on hrdt_file to tiptopgp;
grant delete on hrdt_file to tiptopgp;
grant insert on hrdt_file to tiptopgp;
grant index on hrdt_file to public;
grant select on hrdt_file to ods;
