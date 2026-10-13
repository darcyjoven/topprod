/*
================================================================================
檔案代號:hrcf_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcf_file
(
hrcf01      varchar2(20) NOT NULL,   /*公司编号                               */
hrcf02      varchar2(20) NOT NULL,   /*部门编号                               */
hrcf03      varchar2(20) NOT NULL,   /*起算开始日期                           */
hrcf04      varchar2(1),             /*折算到每月1日                          */
hrcf05      varchar2(1) NOT NULL,    /*统一按次月处理                         */
hrcf06      number(2) NOT NULL,      /*按固定日期分段                         */
hrcf07      varchar2(1) NOT NULL,    /*累加其他企业工作工龄                   */
hrcf08      number(2) NOT NULL,      /*当年事假超过/天                        */
hrcf09      varchar2(20),            /*已经享受特殊假                         */
hrcf10      number(2) NOT NULL,      /*工龄小于/年                            */
hrcf11      number(3) NOT NULL,      /*当年病假超过/天                        */
hrcf12      number(2) NOT NULL,      /*工龄小于/年                            */
hrcf13      number(3) NOT NULL,      /*当年病假超过/天                        */
hrcf14      number(2) NOT NULL,      /*工龄大于等于/年                        */
hrcf15      number(3) NOT NULL,      /*当年病假超过/天                        */
hrcf16      varchar2(1) NOT NULL,    /*首次休假天数折算                       */
hrcf17      varchar2(1) NOT NULL,    /*年假天数变更折算                       */
hrcf18      varchar2(20) NOT NULL,   /*折算依据                               */
hrcf19      number(5,3),             /*核算量/天                              */
hrcf20      varchar2(20) NOT NULL,   /*进位方式                               */
hrcf21      varchar2(1) NOT NULL,    /*福利年假不折算                         */
hrcf22      varchar2(1) NOT NULL,    /*福利年假独立折算                       */
hrcf23      varchar2(1) NOT NULL,    /*优先休法定年假                         */
hrcf24      varchar2(1) NOT NULL,    /*依个人周期休假                         */
hrcf25      varchar2(1) NOT NULL,    /*检查起休日                             */
hrcf26      varchar2(1) NOT NULL,    /*须要单次休完                           */
hrcf27      varchar2(1) NOT NULL,    /*未休年假结转                           */
hrcf28      varchar2(1) NOT NULL,    /*福利年假一并结转                       */
hrcf29      varchar2(20) NOT NULL,   /*结余年假可休周期                       */
hrcfud01    varchar2(255),           /*自订栏位-Textedit                      */
hrcfud02    varchar2(40),            /*自订栏位-文字                          */
hrcfud03    varchar2(40),            /*自订栏位-文字                          */
hrcfud04    varchar2(40),            /*自订栏位-文字                          */
hrcfud05    varchar2(40),            /*自订栏位-文字                          */
hrcfud06    varchar2(40),            /*自订栏位-文字                          */
hrcfud07    number(15,3),            /*自订栏位-数值                          */
hrcfud08    number(15,3),            /*自订栏位-数值                          */
hrcfud09    number(15,3),            /*自订栏位-数值                          */
hrcfud10    number(10),              /*自订栏位-整数                          */
hrcfud11    number(10),              /*自订栏位-整数                          */
hrcfud12    number(10),              /*自订栏位-整数                          */
hrcfud13    date,                    /*自订栏位-日期                          */
hrcfud14    date,                    /*自订栏位-日期                          */
hrcfud15    date,                    /*自订栏位-日期                          */
hrcfuser    varchar2(10),            /*资料所有者                             */
hrcfgrup    varchar2(10),            /*资料所有群                             */
hrcfmodu    varchar2(10),            /*资料更改者                             */
hrcfdate    date,                    /*最近修改日                             */
hrcforig    varchar2(10),            /*资料建立部门                           */
hrcforiu    varchar2(10)             /*资料建立者                             */
);

alter table hrcf_file add  constraint tpc_hrcf_pk primary key  (hrcf01,hrcf02) enable validate;
grant select on hrcf_file to tiptopgp;
grant update on hrcf_file to tiptopgp;
grant delete on hrcf_file to tiptopgp;
grant insert on hrcf_file to tiptopgp;
grant index on hrcf_file to public;
grant select on hrcf_file to ods;
