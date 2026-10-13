/*
================================================================================
檔案代號:hrbk_file
檔案名稱:企业行事历
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbk_file
(
hrbk01      varchar2(20) NOT NULL,   /*公司编号                               */
hrbk02      number(5) NOT NULL,      /*年度                                   */
hrbk03      date NOT NULL,           /*日期                                   */
hrbk04      varchar2(10),            /*星期                                   */
hrbk05      varchar2(10),            /*日历类型                               */
hrbk06      varchar2(20),            /*日历名称                               */
hrbk07      varchar2(10),            /*时间类型                               */
hrbk08      varchar2(20),            /*适用人群                               */
hrbk09      varchar2(255),           /*备注                                   */
hrbkud01    varchar2(255),           /*自订栏位-Textedit                      */
hrbkud02    varchar2(40),            /*自订栏位-文字                          */
hrbkud03    varchar2(40),            /*自订栏位-文字                          */
hrbkud04    varchar2(40),            /*自订栏位-文字                          */
hrbkud05    varchar2(40),            /*自订栏位-文字                          */
hrbkud06    varchar2(40),            /*自订栏位-文字                          */
hrbkud07    number(15,3),            /*自订栏位-数值                          */
hrbkud08    number(15,3),            /*自订栏位-数值                          */
hrbkud09    number(15,3),            /*自订栏位-数值                          */
hrbkud10    number(10),              /*自订栏位-整数                          */
hrbkud11    number(10),              /*自订栏位-整数                          */
hrbkud12    number(10),              /*自订栏位-整数                          */
hrbkud13    date,                    /*自订栏位-日期                          */
hrbkud14    date,                    /*自订栏位-日期                          */
hrbkud15    date,                    /*自订栏位-日期                          */
hrbkuser    varchar2(10),            /*资料所有者                             */
hrbkgrup    varchar2(10),            /*资料所有群                             */
hrbkmodu    varchar2(10),            /*资料更改者                             */
hrbkdate    date,                    /*最近修改日                             */
hrbkacti    varchar2(1),             /*资料有效                               */
hrbkoriu    varchar2(10),            /*资料建立者                             */
hrbkorig    varchar2(10),            /*资料建立部门                           */
hrbk10      varchar2(1)
);

alter table hrbk_file add  constraint tpc_hrbk_pk primary key  (hrbk01,hrbk02,hrbk03) enable validate;
grant select on hrbk_file to tiptopgp;
grant update on hrbk_file to tiptopgp;
grant delete on hrbk_file to tiptopgp;
grant insert on hrbk_file to tiptopgp;
grant index on hrbk_file to public;
grant select on hrbk_file to ods;
