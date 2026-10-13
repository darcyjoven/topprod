/*
================================================================================
檔案代號:hraw_file
檔案名稱:员工兼职
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hraw_file
(
hraw01      varchar2(50) NOT NULL,   /*员工ID                                 */
hraw02      varchar2(40) NOT NULL,   /*兼职部门编号                           */
hraw03      varchar2(40) NOT NULL,   /*兼职职位编号                           */
hraw04      date,                    /*生效日期                               */
hraw05      date,                    /*失效日期                               */
hraw06      varchar2(255),           /*备注                                   */
hrawud01    varchar2(255),           /*自订栏位-Textedit                      */
hrawud02    varchar2(40),            /*自订栏位-文字                          */
hrawud03    varchar2(40),            /*自订栏位-文字                          */
hrawud04    varchar2(40),            /*自订栏位-文字                          */
hrawud05    varchar2(40),            /*自订栏位-文字                          */
hrawud06    varchar2(40),            /*自订栏位-文字                          */
hrawud07    number(15,3),            /*自订栏位-数值                          */
hrawud08    number(15,3),            /*自订栏位-数值                          */
hrawud09    number(15,3),            /*自订栏位-数值                          */
hrawud10    number(10),              /*自订栏位-整数                          */
hrawud11    number(10),              /*自订栏位-整数                          */
hrawud12    number(10),              /*自订栏位-整数                          */
hrawud13    date,                    /*自订栏位-日期		                            */
hrawud14    date,                    /*自订栏位-日期                          */
hrawud15    date,                    /*自订栏位-日期                          */
hrawacti    varchar2(1),             /*有效否                                 */
hrawuser    varchar2(10),            /*资料所有者                             */
hrawgrup    varchar2(10),            /*资料所有群                             */
hrawmodu    varchar2(10),            /*资料更改者                             */
hrawdate    date,                    /*最近修改日                             */
hraworiu    varchar2(10),            /*资料建立部门                           */
hraworig    varchar2(10)             /*资料建立者                             */
);

alter table hraw_file add  constraint tpc_hraw_pk primary key  (hraw01,hraw02,hraw03) enable validate;
grant select on hraw_file to tiptopgp;
grant update on hraw_file to tiptopgp;
grant delete on hraw_file to tiptopgp;
grant insert on hraw_file to tiptopgp;
grant index on hraw_file to public;
grant select on hraw_file to ods;
