/*
================================================================================
檔案代號:hrcn_file
檔案名稱:加班结果信息表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcn_file
(
hrcn01      varchar2(20),            /*计划编号                               */
hrcn02      number(15) NOT NULL,     /*结果编号                               */
hrcn03      varchar2(60) NOT NULL,   /*人员ID                                 */
hrcn04      date NOT NULL,           /*开始日期                               */
hrcn05      varchar2(8) NOT NULL,    /*开始时间                               */
hrcn06      date NOT NULL,           /*结束日期                               */
hrcn07      varchar2(8) NOT NULL,    /*结束时间                               */
hrcn08      number(5) NOT NULL,      /*加班时长                               */
hrcn09      varchar2(20) NOT NULL,   /*加班类型                               */
hrcn10      varchar2(1) NOT NULL,    /*手工录入                               */
hrcn11      varchar2(255),           /*备注                                   */
hrcnconf    varchar2(1),             /* 审核状态                              */
hrcnacti    varchar2(1),             /* 资料有效否                            */
hrcnud01    varchar2(255),           /*自订栏位-Textedit                      */
hrcnud02    varchar2(40),            /*自订栏位-文字                          */
hrcnud03    varchar2(40),            /*自订栏位-文字                          */
hrcnud04    varchar2(40),            /*自订栏位-文字                          */
hrcnud05    varchar2(40),            /*自订栏位-文字                          */
hrcnud06    varchar2(40),            /*自订栏位-文字                          */
hrcnud07    number(15,3),            /*自订栏位-数值                          */
hrcnud08    number(15,3),            /*自订栏位-数值                          */
hrcnud09    number(15,3),            /*自订栏位-数值                          */
hrcnud10    number(10),              /*自订栏位-整数                          */
hrcnud11    number(10),              /*自订栏位-整数                          */
hrcnud12    number(10),              /*自订栏位-整数                          */
hrcnud13    date,                    /*自订栏位-日期                          */
hrcnud14    date,                    /*自订栏位-日期                          */
hrcnud15    date,                    /*自订栏位-日期                          */
hrcnuser    varchar2(10),            /*  资料所有者                           */
hrcngrup    varchar2(10),            /*  资料所有群                           */
hrcnmodu    varchar2(10),            /*  资料更改者                           */
hrcndate    date,                    /*  最近修改日                           */
hrcnorig    varchar2(10),            /*  资料建立部门                         */
hrcnoriu    varchar2(10),            /*  资料建立者                           */
hrcn12      number(5),               /*早退时间/分钟                          */
hrcn13      number(5),               /*迟到时间/分钟                          */
hrcn14      date                     /*加班归属日期                           */
);

alter table hrcn_file add  constraint tpc_hrcn_pk primary key  (hrcn02) enable validate;
grant select on hrcn_file to tiptopgp;
grant update on hrcn_file to tiptopgp;
grant delete on hrcn_file to tiptopgp;
grant insert on hrcn_file to tiptopgp;
grant index on hrcn_file to public;
grant select on hrcn_file to ods;
