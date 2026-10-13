/*
================================================================================
檔案代號:hrct_file
檔案名稱:薪资发放周期
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrct_file
(
hrct01      varchar2(20) NOT NULL,   /*薪资年度                               */
hrct02      varchar2(20) NOT NULL,   /*薪资期间                               */
hrct03      varchar2(20) NOT NULL,   /*所属公司                               */
hrct04      varchar2(20),            /*所属财年                               */
hrct05      varchar2(20),            /*所属财月                               */
hrct06      varchar2(1),             /*是否关账                               */
hrct07      date,                    /*开始日期                               */
hrct08      date,                    /*结束日期                               */
hrct09      varchar2(1),             /*是否集团级                             */
hrct10      varchar2(1),             /*是否历史                               */
hrct11      varchar2(255),           /*名称                                   */
hrct12      varchar2(255),           /*备注                                   */
hrctacti    varchar2(1),             /*资料有效码                             */
hrctuser    varchar2(10),            /*资料所有者                             */
hrctgrup    varchar2(10),            /*资料所有群                             */
hrctmodu    varchar2(10),            /*资料修改者                             */
hrctdate    date,                    /*最近修改日                             */
hrctoriu    varchar2(10),            /*资料建立者                             */
hrctorig    varchar2(10),            /*资料建立部门                           */
hrctud01    varchar2(255),           /*自订栏位-Textedit                      */
hrctud02    varchar2(40),            /*自订栏位-文字                          */
hrctud03    varchar2(40),            /*自订栏位-文字                          */
hrctud04    varchar2(40),            /*自订栏位-文字                          */
hrctud05    varchar2(40),            /*自订栏位-文字                          */
hrctud06    varchar2(40),            /*自订栏位-文字                          */
hrctud07    number(15,3),            /*自订栏位-数值                          */
hrctud08    number(15,3),            /*自订栏位-数值                          */
hrctud09    number(15,3),            /*自订栏位-数值                          */
hrctud10    number(10),              /*自订栏位-整数                          */
hrctud11    number(10),              /*自订栏位-整数                          */
hrctud12    number(10),              /*自订栏位-整数                          */
hrctud13    date,                    /*自订栏位-日期                          */
hrctud14    date,                    /*自订栏位-日期                          */
hrctud15    date                     /*自订栏位-日期                          */
);

alter table hrct_file add  constraint tpc_hrct_pk primary key  (hrct01,hrct02,hrct03) enable validate;
grant select on hrct_file to tiptopgp;
grant update on hrct_file to tiptopgp;
grant delete on hrct_file to tiptopgp;
grant insert on hrct_file to tiptopgp;
grant index on hrct_file to public;
grant select on hrct_file to ods;
