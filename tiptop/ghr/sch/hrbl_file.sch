/*
================================================================================
檔案代號:hrbl_file
檔案名稱:考勤区间单头
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbl_file
(
hrbl01      varchar2(10) NOT NULL,   /*公司编号                               */
hrbl02      number(10) NOT NULL,     /*考勤区间编号                           */
hrbl03      varchar2(60),            /*考勤区间名称                           */
hrbl04      number(5) NOT NULL,      /*年度                                   */
hrbl05      number(5),               /*月度                                   */
hrbl06      date,                    /*开始日期                               */
hrbl07      date,                    /*结束日期                               */
hrbl08      varchar2(1),             /*已关帐                                 */
hrbl09      varchar2(255),           /*备注                                   */
hrblud01    varchar2(255),           /*自订栏位-Textedit                      */
hrblud02    varchar2(40),            /*自订栏位-文字                          */
hrblud03    varchar2(40),            /*自订栏位-文字                          */
hrblud04    varchar2(40),            /*自订栏位-文字                          */
hrblud05    varchar2(40),            /*自订栏位-文字                          */
hrblud06    varchar2(40),            /*自订栏位-文字                          */
hrblud07    number(15,3),            /*自订栏位-数值                          */
hrblud08    number(15,3),            /*自订栏位-数值                          */
hrblud09    number(15,3),            /*自订栏位-数值                          */
hrblud10    number(10),              /*自订栏位-整数                          */
hrblud11    number(10),              /*自订栏位-整数                          */
hrblud12    number(10),              /*自订栏位-整数                          */
hrblud13    date,                    /*自订栏位-日期                          */
hrblud14    date,                    /*自订栏位-日期                          */
hrblud15    date,                    /*自订栏位-日期                          */
hrbluser    varchar2(10),            /*资料所有者                             */
hrblgrup    varchar2(10),            /*资料所有群                             */
hrblmodu    varchar2(10),            /*资料更改者                             */
hrbldate    date,                    /*最近修改日                             */
hrbloriu    varchar2(10),            /*资料建立者                             */
hrblorig    varchar2(10),            /*资料建立部门                           */
hrblacti    varchar2(1)              /*资料有效否                             */
);

create        index hrbl_01 on hrbl_file (hrbl01,hrbl04,hrbl05);
alter table hrbl_file add  constraint tpc_hrbl_pk primary key  (hrbl02) enable validate;
grant select on hrbl_file to tiptopgp;
grant update on hrbl_file to tiptopgp;
grant delete on hrbl_file to tiptopgp;
grant insert on hrbl_file to tiptopgp;
grant index on hrbl_file to public;
grant select on hrbl_file to ods;
