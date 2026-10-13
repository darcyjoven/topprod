/*
================================================================================
檔案代號:hrdl_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdl_file
(
hrdl01      varchar2(20) NOT NULL,   /*薪资类别编码                           */
hrdl02      varchar2(50),            /*薪资类别名称                           */
hrdl03      varchar2(20),            /*个税参照表                             */
hrdl04      varchar2(20),            /*币种                                   */
hrdl05      varchar2(20),            /*扣税方式                               */
hrdl06      varchar2(20),            /*扣零方式                               */
hrdl07      number(15,2),            /*个税起征值                             */
hrdl08      varchar2(1),             /*将负数结果置为零                       */
hrdl09      varchar2(1),             /*置零后负值是否计入下月薪资             */
hrdl10      varchar2(255),           /*备注                                   */
hrdl11      varchar2(4000),          /*存储过程-1                             */
hrdl12      varchar2(4000),          /*存储过程-2                             */
hrdl13      varchar2(4000),          /*存储过程-3                             */
hrdl14      varchar2(4000),          /*存储过程-4                             */
hrdl15      varchar2(4000),          /*存储过程-5                             */
hrdl16      varchar2(4000),          /*存储过程-6                             */
hrdl17      varchar2(4000),          /*存储过程-7                             */
hrdl18      varchar2(4000),          /*存储过程-8                             */
hrdl19      varchar2(4000),          /*存储过程-9                             */
hrdl20      varchar2(4000),          /*存储过程-10                            */
hrdlacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrdluser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrdlgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrdlmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrdldate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrdloriu    varchar2(10),            /*资料建立者                             */
hrdlorig    varchar2(10),            /*资料建立部门                           */
hrdlud01    varchar2(255),           /*自订栏位-Textedit                      */
hrdlud02    varchar2(40),            /*自订栏位-文字                          */
hrdlud03    varchar2(40),            /*自订栏位-文字                          */
hrdlud04    varchar2(40),            /*自订栏位-文字                          */
hrdlud05    varchar2(40),            /*自订栏位-文字                          */
hrdlud06    varchar2(40),            /*自订栏位-文字                          */
hrdlud07    number(15,3),            /*自订栏位-数值                          */
hrdlud08    number(15,3),            /*自订栏位-数值                          */
hrdlud09    number(15,3),            /*自订栏位-数值                          */
hrdlud10    number(10),              /*自订栏位-整数                          */
hrdlud11    number(10),              /*自订栏位-整数                          */
hrdlud12    number(10),              /*自订栏位-整数                          */
hrdlud13    date,                    /*自订栏位-日期                          */
hrdlud14    date,                    /*自订栏位-日期                          */
hrdlud15    date,                    /*自订栏位-日期                          */
hrdl21      clob,
hrdl22      varchar2(4000)
);

alter table hrdl_file add  constraint tpc_hrdl_pk primary key  (hrdl01) enable validate;
grant select on hrdl_file to tiptopgp;
grant update on hrdl_file to tiptopgp;
grant delete on hrdl_file to tiptopgp;
grant insert on hrdl_file to tiptopgp;
grant index on hrdl_file to public;
grant select on hrdl_file to ods;
