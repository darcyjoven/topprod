/*
================================================================================
檔案代號:hrdi_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdi_file
(
hrdi01      varchar2(20) NOT NULL,   /*字段名称                               */
hrdi02      varchar2(20),            /*字段类型                               */
hrdi03      varchar2(50),            /*字段长度                               */
hrdi04      varchar2(1),             /*是否允许为空                           */
hrdi05      varchar2(100),           /*字段说明                               */
hrdi06      varchar2(1),             /*与薪资关联                             */
hrdiacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrdiuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrdigrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrdimodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrdidate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrdioriu    varchar2(10),            /*资料建立者                             */
hrdiorig    varchar2(10),            /*资料建立部门                           */
hrdiud01    varchar2(255),           /*自订栏位-Textedit                      */
hrdiud02    varchar2(40),            /*自订栏位-文字                          */
hrdiud03    varchar2(40),            /*自订栏位-文字                          */
hrdiud04    varchar2(40),            /*自订栏位-文字                          */
hrdiud05    varchar2(40),            /*自订栏位-文字                          */
hrdiud06    varchar2(40),            /*自订栏位-文字                          */
hrdiud07    number(15,3),            /*自订栏位-数值                          */
hrdiud08    number(15,3),            /*自订栏位-数值                          */
hrdiud09    number(15,3),            /*自订栏位-数值                          */
hrdiud10    number(10),              /*自订栏位-整数                          */
hrdiud11    number(10),              /*自订栏位-整数                          */
hrdiud12    number(10),              /*自订栏位-整数                          */
hrdiud13    date,                    /*自订栏位-日期                          */
hrdiud14    date,                    /*自订栏位-日期                          */
hrdiud15    date,                    /*自订栏位-日期                          */
hrdi07      varchar2(1),
hrdi08      varchar2(4000)
);

alter table hrdi_file add  constraint tpc_hrdi_pk primary key  (hrdi01) enable validate;
grant select on hrdi_file to tiptopgp;
grant update on hrdi_file to tiptopgp;
grant delete on hrdi_file to tiptopgp;
grant insert on hrdi_file to tiptopgp;
grant index on hrdi_file to public;
grant select on hrdi_file to ods;
