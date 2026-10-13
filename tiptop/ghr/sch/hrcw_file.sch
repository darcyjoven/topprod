/*
================================================================================
檔案代號:hrcw_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcw_file
(
hrcw01      varchar2(20) NOT NULL,   /*文档ID                                 */
hrcw02      varchar2(100),           /*文档标题                               */
hrcw03      varchar2(50),            /*关键字                                 */
hrcw04      varchar2(50),            /*来自                                   */
hrcw05      varchar2(20),            /*文档类别                               */
hrcw06      date,                    /*生效日期                               */
hrcw07      date,                    /*失效日期                               */
hrcw08      varchar2(1),             /*是否ESS发布                            */
hrcw09      varchar2(4000),          /*备注                                   */
hrcwacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrcwuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrcwgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrcwmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrcwdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrcworiu    varchar2(10),            /*资料建立者                             */
hrcworig    varchar2(10),            /*资料建立部门                           */
hrcwud01    varchar2(255),           /*自订栏位-Textedit                      */
hrcwud02    varchar2(40),            /*自订栏位-文字                          */
hrcwud03    varchar2(40),            /*自订栏位-文字                          */
hrcwud04    varchar2(40),            /*自订栏位-文字                          */
hrcwud05    varchar2(40),            /*自订栏位-文字                          */
hrcwud06    varchar2(40),            /*自订栏位-文字                          */
hrcwud07    number(15,3),            /*自订栏位-数值                          */
hrcwud08    number(15,3),            /*自订栏位-数值                          */
hrcwud09    number(15,3),            /*自订栏位-数值                          */
hrcwud10    number(10),              /*自订栏位-整数                          */
hrcwud11    number(10),              /*自订栏位-整数                          */
hrcwud12    number(10),              /*自订栏位-整数                          */
hrcwud13    date,                    /*自订栏位-日期                          */
hrcwud14    date,                    /*自订栏位-日期                          */
hrcwud15    date                     /*自订栏位-日期                          */
);

alter table hrcw_file add  constraint tpc_hrcw_pk primary key  (hrcw01) enable validate;
grant select on hrcw_file to tiptopgp;
grant update on hrcw_file to tiptopgp;
grant delete on hrcw_file to tiptopgp;
grant insert on hrcw_file to tiptopgp;
grant index on hrcw_file to public;
grant select on hrcw_file to ods;
