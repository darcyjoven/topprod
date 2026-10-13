/*
================================================================================
檔案代號:hrdv_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdv_file
(
hrdv00      varchar2(10) NOT NULL,   /*流水码                                 */
hrdv01      varchar2(10),            /*员工ID                                 */
hrdv02      varchar2(20),            /*统筹体系ID                             */
hrdv03      varchar2(20),            /*补缴标志ID                             */
hrdv04      varchar2(100),           /*补缴薪资月                             */
hrdv05      varchar2(100),           /*补缴起薪资月                           */
hrdv06      varchar2(100),           /*补缴止薪资月                           */
hrdv07      varchar2(20),            /*统筹参数ID                             */
hrdv08      varchar2(20),            /*统筹类型ID                             */
hrdv09      number(20,6),            /*公司定额基数                           */
hrdv10      number(20,6),            /*公司比例                               */
hrdv11      number(20,6),            /*个人定额基数                           */
hrdv12      number(20,6),            /*个人比例                               */
hrdv13      varchar2(255),           /*备注                                   */
hrdvacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrdvuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrdvgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrdvmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrdvdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrdvoriu    varchar2(10),            /*资料建立者                             */
hrdvorig    varchar2(10),            /*资料建立部门                           */
hrdvud01    varchar2(255),           /*自订栏位-Textedit                      */
hrdvud02    varchar2(40),            /*自订栏位-文字                          */
hrdvud03    varchar2(40),            /*自订栏位-文字                          */
hrdvud04    varchar2(40),            /*自订栏位-文字                          */
hrdvud05    varchar2(40),            /*自订栏位-文字                          */
hrdvud06    varchar2(40),            /*自订栏位-文字                          */
hrdvud07    number(15,3),            /*自订栏位-数值                          */
hrdvud08    number(15,3),            /*自订栏位-数值                          */
hrdvud09    number(15,3),            /*自订栏位-数值                          */
hrdvud10    number(10),              /*自订栏位-整数                          */
hrdvud11    number(10),              /*自订栏位-整数                          */
hrdvud12    number(10),              /*自订栏位-整数                          */
hrdvud13    date,                    /*自订栏位-日期                          */
hrdvud14    date,                    /*自订栏位-日期                          */
hrdvud15    date                     /*自订栏位-日期                          */
);

alter table hrdv_file add  constraint tpc_hrdv_pk primary key  (hrdv00) enable validate;
grant select on hrdv_file to tiptopgp;
grant update on hrdv_file to tiptopgp;
grant delete on hrdv_file to tiptopgp;
grant insert on hrdv_file to tiptopgp;
grant index on hrdv_file to public;
grant select on hrdv_file to ods;
