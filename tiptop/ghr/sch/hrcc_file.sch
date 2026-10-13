/*
================================================================================
檔案代號:hrcc_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcc_file
(
hrcc01      number(5) NOT NULL,      /*特殊假编号                             */
hrcc02      varchar2(20) NOT NULL,   /*假勤项目编号                           */
hrcc03      number(5,2) NOT NULL,    /*累计给休                               */
hrcc04      date NOT NULL,           /*生效日期                               */
hrcc05      date,                    /*失效日期                               */
hrcc06      varchar2(1) NOT NULL,    /*单次体完                               */
hrcc07      varchar2(60) NOT NULL,   /*员工ID                                 */
hrcc08      number(5,2) NOT NULL,    /*已休                                   */
hrcc09      number(5,2) NOT NULL,    /*未休                                   */
hrcc10      varchar2(20) NOT NULL,   /*单位                                   */
hrcc11      varchar2(255),           /*备注                                   */
hrccud01    varchar2(255),           /*自订栏位-Textedit                      */
hrccud02    varchar2(40),            /*自订栏位-文字                          */
hrccud03    varchar2(40),            /*自订栏位-文字                          */
hrccud04    varchar2(40),            /*自订栏位-文字                          */
hrccud05    varchar2(40),            /*自订栏位-文字                          */
hrccud06    varchar2(40),            /*自订栏位-文字                          */
hrccud07    number(15,3),            /*自订栏位-数值                          */
hrccud08    number(15,3),            /*自订栏位-数值                          */
hrccud09    number(15,3),            /*自订栏位-数值                          */
hrccud10    number(10),              /*自订栏位-整数                          */
hrccud11    number(10),              /*自订栏位-整数                          */
hrccud12    number(10),              /*自订栏位-整数                          */
hrccud13    date,                    /*自订栏位-日期                          */
hrccud14    date,                    /*自订栏位-日期                          */
hrccud15    date,                    /*自订栏位-日期                          */
hrccuser    varchar2(10),            /*资料所有者                             */
hrccgrup    varchar2(10),            /*资料所有群                             */
hrccmodu    varchar2(10),            /*资料更改者                             */
hrccdate    date,                    /*最近修改日                             */
hrccorig    varchar2(10),            /*资料建立部门                           */
hrccoriu    varchar2(10)             /*资料建立者                             */
);

alter table hrcc_file add  constraint tpc_hrcc_pk primary key  (hrcc02,hrcc04,hrcc07) enable validate;
grant select on hrcc_file to tiptopgp;
grant update on hrcc_file to tiptopgp;
grant delete on hrcc_file to tiptopgp;
grant insert on hrcc_file to tiptopgp;
grant index on hrcc_file to public;
grant select on hrcc_file to ods;
