/*
================================================================================
檔案代號:hrds_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrds_file
(
hrds01      varchar2(10) NOT NULL,   /*统筹参数编码                           */
hrds02      varchar2(50),            /*统筹参数名称                           */
hrds03      varchar2(255),           /*备注                                   */
hrdsacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrdsuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrdsgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrdsmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrdsdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrdsoriu    varchar2(10),            /*资料建立者                             */
hrdsorig    varchar2(10),            /*资料建立部门                           */
hrdsud01    varchar2(255),           /*自订栏位-Textedit                      */
hrdsud02    varchar2(40),            /*自订栏位-文字                          */
hrdsud03    varchar2(40),            /*自订栏位-文字                          */
hrdsud04    varchar2(40),            /*自订栏位-文字                          */
hrdsud05    varchar2(40),            /*自订栏位-文字                          */
hrdsud06    varchar2(40),            /*自订栏位-文字                          */
hrdsud07    number(15,3),            /*自订栏位-数值                          */
hrdsud08    number(15,3),            /*自订栏位-数值                          */
hrdsud09    number(15,3),            /*自订栏位-数值                          */
hrdsud10    number(10),              /*自订栏位-整数                          */
hrdsud11    number(10),              /*自订栏位-整数                          */
hrdsud12    number(10),              /*自订栏位-整数                          */
hrdsud13    date,                    /*自订栏位-日期                          */
hrdsud14    date,                    /*自订栏位-日期                          */
hrdsud15    date                     /*自订栏位-日期                          */
);

alter table hrds_file add  constraint tpc_hrds_pk primary key  (hrds01) enable validate;
grant select on hrds_file to tiptopgp;
grant update on hrds_file to tiptopgp;
grant delete on hrds_file to tiptopgp;
grant insert on hrds_file to tiptopgp;
grant index on hrds_file to public;
grant select on hrds_file to ods;
