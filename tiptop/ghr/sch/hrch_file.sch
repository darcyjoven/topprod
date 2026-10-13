/*
================================================================================
檔案代號:hrch_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrch_file
(
hrch01      varchar2(20) NOT NULL,   /*公司编号                               */
hrch02      number(4) NOT NULL,      /*年度                                   */
hrch03      varchar2(60) NOT NULL,   /*员工Id                                 */
hrch04      number(2) NOT NULL,      /*结余可休/天                            */
hrch05      number(2) NOT NULL,      /*结余已休/天                            */
hrch06      number(2) NOT NULL,      /*结余未休/天                            */
hrch07      date,                    /*结余截止日期                           */
hrch08      number(5,3),             /*工龄/年                                */
hrch09      number(2) NOT NULL,      /*本年额定可休/天                        */
hrch10      number(2) NOT NULL,      /*本年福利可休/天                        */
hrch11      number(4) NOT NULL,      /*本年调整可休/天                        */
hrch12      number(2) NOT NULL,      /*本年新增可休/天                        */
hrch13      date,                    /*生效日期                               */
hrch14      date,                    /*失效日期                               */
hrch15      number(2) NOT NULL,      /*合计可休/天                            */
hrch16      number(2) NOT NULL,      /*合计已休/天                            */
hrch17      number(2) NOT NULL,      /*合计未休/天                            */
hrch18      varchar2(255),           /*备注                                   */
hrch19      number(15) NOT NULL,     /*年假计划编号                           */
hrchud01    varchar2(255),           /*自订栏位-Textedit                      */
hrchud02    varchar2(40),            /*自订栏位-文字                          */
hrchud03    varchar2(40),            /*自订栏位-文字                          */
hrchud04    varchar2(40),            /*自订栏位-文字                          */
hrchud05    varchar2(40),            /*自订栏位-文字                          */
hrchud06    varchar2(40),            /*自订栏位-文字                          */
hrchud07    number(15,3),            /*自订栏位-数值                          */
hrchud08    number(15,3),            /*自订栏位-数值                          */
hrchud09    number(15,3),            /*自订栏位-数值                          */
hrchud10    number(10),              /*自订栏位-整数                          */
hrchud11    number(10),              /*自订栏位-整数                          */
hrchud12    number(10),              /*自订栏位-整数                          */
hrchud13    date,                    /*自订栏位-日期                          */
hrchud14    date,                    /*自订栏位-日期                          */
hrchud15    date,                    /*自订栏位-日期                          */
hrchuser    varchar2(10),            /*  资料所有者                           */
hrchgrup    varchar2(10),            /*  资料所有群                           */
hrchmodu    varchar2(10),            /*  资料更改者                           */
hrchdate    date,                    /*  最近修改日                           */
hrchorig    varchar2(10),            /*  资料建立部门                         */
hrchoriu    varchar2(10),            /*  资料建立者                           */
hrch20      number(2),               /*额定未休                               */
hrch21      number(2),               /*福利未休                               */
hrch22      number(2)                /*调整未休                               */
);

alter table hrch_file add  constraint tpc_hrch_pk primary key  (hrch01,hrch02,hrch03) enable validate;
grant select on hrch_file to tiptopgp;
grant update on hrch_file to tiptopgp;
grant delete on hrch_file to tiptopgp;
grant insert on hrch_file to tiptopgp;
grant index on hrch_file to public;
grant select on hrch_file to ods;
