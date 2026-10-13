/*
================================================================================
檔案代號:hrbo_file
檔案名稱:班次信息表
檔案目的:记录班次信息
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbo_file
(
hrbo01      varchar2(20) NOT NULL,   /*公司编号                               */
hrbo02      varchar2(20) NOT NULL,   /*班次编号                               */
hrbo03      varchar2(20) NOT NULL,   /*班次名称                               */
hrbo04      varchar2(5) NOT NULL,    /*开始时间                               */
hrbo05      varchar2(5) NOT NULL,    /*结束时间                               */
hrbo06      varchar2(1) NOT NULL,    /*休息班次                               */
hrbo07      varchar2(1) NOT NULL,    /*跨天班次                               */
hrbo08      varchar2(3) NOT NULL,    /*额定工作/分钟                          */
hrbo09      varchar2(3) NOT NULL,    /*实际考勤/分钟                          */
hrbo10      varchar2(1) NOT NULL,    /*依刷卡加班                             */
hrbo11      varchar2(1) NOT NULL,    /*弹性班次                               */
hrbo12      varchar2(3) NOT NULL,    /*最大弹性/分钟                          */
hrbo13      varchar2(3) NOT NULL,    /*弹性核算/分钟                          */
hrbo14      varchar2(255),           /*备注                                   */
hrboud01    varchar2(255),           /*自订栏位-Textedit                      */
hrboud02    varchar2(40),            /*自订栏位-文字                          */
hrboud03    varchar2(40),            /*自订栏位-文字                          */
hrboud04    varchar2(40),            /*自订栏位-文字                          */
hrboud05    varchar2(40),            /*自订栏位-文字                          */
hrboud06    varchar2(40),            /*自订栏位-文字                          */
hrboud07    number(15,3),            /*自订栏位-数值                          */
hrboud08    number(15,3),            /*自订栏位-数值                          */
hrboud09    number(15,3),            /*自订栏位-数值                          */
hrboud10    number(10),              /*自订栏位-整数                          */
hrboud11    number(10),              /*自订栏位-整数                          */
hrboud12    number(10),              /*自订栏位-整数                          */
hrboud13    date,                    /*自订栏位-日期                          */
hrboud14    date,                    /*自订栏位-日期                          */
hrboud15    date,                    /*自订栏位-日期                          */
hrbouser    varchar2(10),            /*资料所有者                             */
hrbogrup    varchar2(10),            /*资料所有群                             */
hrbomodu    varchar2(10),            /*资料更改者                             */
hrbodate    date,                    /*最近修改日                             */
hrboorig    varchar2(10),            /*资料建立部门                           */
hrbooriu    varchar2(10),            /*资料建立者                             */
hrbo15      varchar2(255)            /*额定时间                               */
);

alter table hrbo_file add  constraint tpc_hrbo_pk primary key  (hrbo02) enable validate;
grant select on hrbo_file to tiptopgp;
grant update on hrbo_file to tiptopgp;
grant delete on hrbo_file to tiptopgp;
grant insert on hrbo_file to tiptopgp;
grant index on hrbo_file to public;
grant select on hrbo_file to ods;
