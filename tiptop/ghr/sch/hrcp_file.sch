/*
================================================================================
檔案代號:hrcp_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcp_file
(
hrcp01      number(15) NOT NULL,     /*结果编号                               */
hrcp02      varchar2(60) NOT NULL,   /*人员ID                                 */
hrcp03      date NOT NULL,           /*日期                                   */
hrcp04      varchar2(20) NOT NULL,   /*班次                                   */
hrcp05      varchar2(50) NOT NULL,   /*额定时间                               */
hrcp06      varchar2(50),            /*补充时间                               */
hrcp07      varchar2(1),             /*手工调整                               */
hrcp08      varchar2(20),            /*出勤情况                               */
hrcp09      number(5,2),             /*工作时间                               */
hrcp10      varchar2(20),            /*项目1                                  */
hrcp11      number(5,2),             /*时间1                                  */
hrcp12      varchar2(20),            /*项目2                                  */
hrcp13      number(5,2),             /*时间2                                  */
hrcp14      varchar2(20),            /*项目3                                  */
hrcp15      number(5,2),             /*时间3                                  */
hrcp16      varchar2(20),            /*项目4                                  */
hrcp17      number(5,2),             /*时间4                                  */
hrcp18      varchar2(20),            /*项目5                                  */
hrcp19      number(5,2),             /*时间5                                  */
hrcp20      varchar2(20),            /*项目6                                  */
hrcp21      number(5,2),             /*时间6                                  */
hrcp22      varchar2(5),             /*进1                                    */
hrcp23      varchar2(5),             /*出1                                    */
hrcp24      varchar2(5),             /*进2                                    */
hrcp25      varchar2(5),             /*出2                                    */
hrcp26      varchar2(5),             /*进3                                    */
hrcp27      varchar2(5),             /*出3                                    */
hrcp28      varchar2(5),             /*进4                                    */
hrcp29      varchar2(5),             /*出4                                    */
hrcp30      varchar2(5),             /*进5                                    */
hrcp31      varchar2(5),             /*出5                                    */
hrcp32      varchar2(5),             /*进6                                    */
hrcp33      varchar2(5),             /*出6                                    */
hrcp34      varchar2(255),           /*备注                                   */
hrcp35      varchar2(1),             /*已处理                                 */
hrcp36      varchar2(1),             /*智能配班                               */
hrcpconf    varchar2(1),             /* 审核状态                              */
hrcpacti    varchar2(1),             /* 资料有效否                            */
hrcpud01    varchar2(255),           /*自订栏位-Textedit                      */
hrcpud02    varchar2(40),            /*自订栏位-文字                          */
hrcpud03    varchar2(40),            /*自订栏位-文字                          */
hrcpud04    varchar2(40),            /*自订栏位-文字                          */
hrcpud05    varchar2(40),            /*自订栏位-文字                          */
hrcpud06    varchar2(40),            /*自订栏位-文字                          */
hrcpud07    number(15,3),            /*自订栏位-数值                          */
hrcpud08    number(15,3),            /*自订栏位-数值                          */
hrcpud09    number(15,3),            /*自订栏位-数值                          */
hrcpud10    number(10),              /*自订栏位-整数                          */
hrcpud11    number(10),              /*自订栏位-整数                          */
hrcpud12    number(10),              /*自订栏位-整数                          */
hrcpud13    date,                    /*自订栏位-日期                          */
hrcpud14    date,                    /*自订栏位-日期                          */
hrcpud15    date,                    /*自订栏位-日期                          */
hrcpuser    varchar2(10),            /*资料所有者                             */
hrcpgrup    varchar2(10),            /*资料所有群                             */
hrcpmodu    varchar2(10),            /*资料更改者                             */
hrcpdate    date,                    /*最近修改日                             */
hrcporig    varchar2(10),            /*资料建立部门                           */
hrcporiu    varchar2(10)             /*资料建立者                             */
);

alter table hrcp_file add  constraint tpc_hrcp_pk primary key  (hrcp01) enable validate;
grant select on hrcp_file to tiptopgp;
grant update on hrcp_file to tiptopgp;
grant delete on hrcp_file to tiptopgp;
grant insert on hrcp_file to tiptopgp;
grant index on hrcp_file to public;
grant select on hrcp_file to ods;
