/*
================================================================================
檔案代號:hrbz_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbz_file
(
hrbz01      varchar2(20) NOT NULL,   /*公司编号                               */
hrbz02      varchar2(20) NOT NULL,   /*群组编号                               */
hrbz03      varchar2(60) NOT NULL,   /*群组名称                               */
hrbz04      varchar2(255),           /*备注                                   */
hrbzud01    varchar2(255),           /*自订栏位-Textedit                      */
hrbzud02    varchar2(40),            /*自订栏位-文字                          */
hrbzud03    varchar2(40),            /*自订栏位-文字                          */
hrbzud04    varchar2(40),            /*自订栏位-文字                          */
hrbzud05    varchar2(40),            /*自订栏位-文字                          */
hrbzud06    varchar2(40),            /*自订栏位-文字                          */
hrbzud07    number(15,3),            /*自订栏位-数值                          */
hrbzud08    number(15,3),            /*自订栏位-数值                          */
hrbzud09    number(15,3),            /*自订栏位-数值                          */
hrbzud10    number(10),              /*自订栏位-整数                          */
hrbzud11    number(10),              /*自订栏位-整数                          */
hrbzud12    number(10),              /*自订栏位-整数                          */
hrbzud13    date,                    /*自订栏位-日期                          */
hrbzud14    date,                    /*自订栏位-日期                          */
hrbzud15    date,                    /*自订栏位-日期                          */
hrbzuser    varchar2(10),            /*资料所有者                             */
hrbzgrup    varchar2(10),            /*资料所有群                             */
hrbzmodu    varchar2(10),            /*资料更改者                             */
hrbzdate    date,                    /*最近修改日                             */
hrbzorig    varchar2(10),            /*资料建立部门                           */
hrbzoriu    varchar2(10)             /*资料建立者                             */
);

alter table hrbz_file add  constraint tpc_hrbz_pk primary key  (hrbz02) enable validate;
grant select on hrbz_file to tiptopgp;
grant update on hrbz_file to tiptopgp;
grant delete on hrbz_file to tiptopgp;
grant insert on hrbz_file to tiptopgp;
grant index on hrbz_file to public;
grant select on hrbz_file to ods;
