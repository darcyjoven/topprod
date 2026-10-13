/*
================================================================================
檔案代號:rmi_file
檔案名稱:不良品分析单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rmi_file
(
rmi01       varchar2(20) NOT NULL,   /*不良品分析单号                         */
                                     /*不良品分析單號                         */
rmi02       date,                    /*单据日期                               */
                                     /*單據日期                               */
rmi03       varchar2(10),            /*检查人员                               */
                                     /*檢查人員#No:6517                       */
rmi04       date,                    /*检查日期                               */
                                     /*檢查日期                               */
rmi05       varchar2(10),            /*检查部门                               */
                                     /*檢查部門                               */
rmiconf     varchar2(1),             /*审核否                                 */
                                     /*確認否 (Y/N)                           */
rmivoid     varchar2(1),             /*有效否                                 */
                                     /*有效否 (Y/N)   Y:有效  N:作廢          */
rmiuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
rmigrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
rmimodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
rmidate     date,                    /*最近更改者                             */
                                     /*最近修改者                             */
rmiud01     varchar2(255),           /*自订字段-Textedit                      */
rmiud02     varchar2(40),            /*自订字段-文字                          */
rmiud03     varchar2(40),            /*自订字段-文字                          */
rmiud04     varchar2(40),            /*自订字段-文字                          */
rmiud05     varchar2(40),            /*自订字段-文字                          */
rmiud06     varchar2(40),            /*自订字段-文字                          */
rmiud07     number(15,3),            /*自订字段-数值                          */
rmiud08     number(15,3),            /*自订字段-数值                          */
rmiud09     number(15,3),            /*自订字段-数值                          */
rmiud10     number(10),              /*自订字段-整数                          */
rmiud11     number(10),              /*自订字段-整数                          */
rmiud12     number(10),              /*自订字段-整数                          */
rmiud13     date,                    /*自订字段-日期                          */
rmiud14     date,                    /*自订字段-日期                          */
rmiud15     date,                    /*自订字段-日期                          */
rmiplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rmilegal    varchar2(10) NOT NULL,   /*所属法人                               */
rmioriu     varchar2(10),            /*资料建立者                             */
rmiorig     varchar2(10)             /*资料建立部门                           */
);

alter table rmi_file add  constraint rmi_pk primary key  (rmi01) enable validate;
grant select on rmi_file to tiptopgp;
grant update on rmi_file to tiptopgp;
grant delete on rmi_file to tiptopgp;
grant insert on rmi_file to tiptopgp;
grant index on rmi_file to public;
grant select on rmi_file to ods;
