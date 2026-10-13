/*
================================================================================
檔案代號:hrcq_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcq_file
(
hrcq01      number(15) NOT NULL,     /*结果编号                               */
hrcq02      varchar2(60) NOT NULL,   /*人员ID                                 */
hrcq03      date NOT NULL,           /*日期                                   */
hrcq04      varchar2(20) NOT NULL,   /*班次                                   */
hrcq05      varchar2(20) NOT NULL,   /*津贴类型                               */
hrcq06      varchar2(20) NOT NULL,   /*核算量                                 */
hrcq07      varchar2(255),           /*备注                                   */
hrcq08      varchar2(1),             /*手工数据                               */
hrcqconf    varchar2(1),             /*审核状态                               */
hrcqacti    varchar2(1),             /*资料有效否                             */
hrcqud01    varchar2(255),           /*自订栏位-Textedit                      */
hrcqud02    varchar2(40),            /*自订栏位-文字                          */
hrcqud03    varchar2(40),            /*自订栏位-文字                          */
hrcqud04    varchar2(40),            /*自订栏位-文字                          */
hrcqud05    varchar2(40),            /*自订栏位-文字                          */
hrcqud06    varchar2(40),            /*自订栏位-文字                          */
hrcqud07    number(15,3),            /*自订栏位-数值                          */
hrcqud08    number(15,3),            /*自订栏位-数值                          */
hrcqud09    number(15,3),            /*自订栏位-数值                          */
hrcqud10    number(10),              /*自订栏位-整数                          */
hrcqud11    number(10),              /*自订栏位-整数                          */
hrcqud12    number(10),              /*自订栏位-整数                          */
hrcqud13    date,                    /*自订栏位-日期                          */
hrcqud14    date,                    /*自订栏位-日期                          */
hrcqud15    date,                    /*自订栏位-日期                          */
hrcquser    varchar2(10),            /*资料所有者                             */
hrcqgrup    varchar2(10),            /*资料所有群                             */
hrcqmodu    varchar2(10),            /*资料更改者                             */
hrcqdate    date,                    /*最近修改日                             */
hrcqorig    varchar2(10),            /*资料建立部门                           */
hrcqoriu    varchar2(10)             /*资料建立者                             */
);

alter table hrcq_file add  constraint tpc_hrcq_pk primary key  (hrcq01) enable validate;
grant select on hrcq_file to tiptopgp;
grant update on hrcq_file to tiptopgp;
grant delete on hrcq_file to tiptopgp;
grant insert on hrcq_file to tiptopgp;
grant index on hrcq_file to public;
grant select on hrcq_file to ods;
