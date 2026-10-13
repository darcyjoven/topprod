/*
================================================================================
檔案代號:hrcr_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcr_file
(
hrcr01      varchar2(10) NOT NULL,   /* 补刷卡序号                            */
hrcr02      varchar2(50) NOT NULL,   /* 员工ID                                */
hrcr03      date,                    /* 刷卡日期                              */
hrcr04      date,                    /* 操作日期                              */
hrcr05      varchar2(50),            /* 操作人                                */
hrcr06      varchar2(10),            /* 刷卡时间1                             */
hrcr07      varchar2(10),            /* 刷卡时间2                             */
hrcr08      varchar2(10),            /* 刷卡时间3                             */
hrcr09      varchar2(10),            /* 刷卡时间4                             */
hrcr10      varchar2(10),            /* 刷卡时间5                             */
hrcr11      varchar2(10),            /* 刷卡时间6                             */
hrcr12      varchar2(10),            /* 补刷卡原因                            */
hrcr13      varchar2(255),           /* 备注                                  */
hrcrconf    varchar2(1),             /* 审核状态                              */
hrcrud01    varchar2(255),           /*自订栏位-Textedit                      */
hrcrud02    varchar2(40),            /*自订栏位-文字                          */
hrcrud03    varchar2(40),            /*自订栏位-文字                          */
hrcrud04    varchar2(40),            /*自订栏位-文字                          */
hrcrud05    varchar2(40),            /*自订栏位-文字                          */
hrcrud06    varchar2(40),            /*自订栏位-文字                          */
hrcrud07    number(15,3),            /*自订栏位-数值                          */
hrcrud08    number(15,3),            /*自订栏位-数值                          */
hrcrud09    number(15,3),            /*自订栏位-数值                          */
hrcrud10    number(10),              /*自订栏位-整数                          */
hrcrud11    number(10),              /*自订栏位-整数                          */
hrcrud12    number(10),              /*自订栏位-整数                          */
hrcrud13    date,                    /*自订栏位-日期                          */
hrcrud14    date,                    /*自订栏位-日期                          */
hrcrud15    date,                    /*自订栏位-日期                          */
hrcruser    varchar2(10),            /*  资料所有者                           */
hrcrgrup    varchar2(10),            /*  资料所有群                           */
hrcrmodu    varchar2(10),            /*  资料更改者                           */
hrcrdate    date,                    /*  最近修改日                           */
hrcrorig    varchar2(10),            /*  资料建立部门                         */
hrcroriu    varchar2(10),            /*  资料建立者                           */
hrcr14      varchar2(1),
hrcr15      varchar2(1),
hrcr16      varchar2(1),
hrcr17      varchar2(1),
hrcr18      varchar2(1),
hrcr19      varchar2(1)
);

alter table hrcr_file add  constraint tpc_hrcr_pk primary key  (hrcr01,hrcr02) enable validate;
grant select on hrcr_file to tiptopgp;
grant update on hrcr_file to tiptopgp;
grant delete on hrcr_file to tiptopgp;
grant insert on hrcr_file to tiptopgp;
grant index on hrcr_file to public;
grant select on hrcr_file to ods;
