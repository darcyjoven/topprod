/*
================================================================================
檔案代號:rml_file
檔案名稱:RMA转销退单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rml_file
(
rml01       varchar2(20) NOT NULL,   /*RMA单号                                */
                                     /*RMA單號                                */
rml02       date,                    /*单据日期                               */
                                     /*單據日期                               */
rml03       number(5) NOT NULL,      /*RMA单号转销退批号--系统维护            */
                                     /*RMA單號轉銷退批號--系統維護            */
rml04       varchar2(20),            /*销退单号                               */
                                     /*銷退單號                  by payton 養生*/
rmlconf     varchar2(1),             /*审核否                                 */
                                     /*確認否 (Y/N)                           */
rmlpost     varchar2(1),             /*过帐否                                 */
                                     /*過帳否 (Y/N)                           */
rmlvoid     varchar2(1),             /*有效否                                 */
                                     /*有效否 (Y/N)                           */
rmluser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
rmlgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
rmlmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
rmldate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
rmlud01     varchar2(255),           /*自订字段-Textedit                      */
rmlud02     varchar2(40),            /*自订字段-文字                          */
rmlud03     varchar2(40),            /*自订字段-文字                          */
rmlud04     varchar2(40),            /*自订字段-文字                          */
rmlud05     varchar2(40),            /*自订字段-文字                          */
rmlud06     varchar2(40),            /*自订字段-文字                          */
rmlud07     number(15,3),            /*自订字段-数值                          */
rmlud08     number(15,3),            /*自订字段-数值                          */
rmlud09     number(15,3),            /*自订字段-数值                          */
rmlud10     number(10),              /*自订字段-整数                          */
rmlud11     number(10),              /*自订字段-整数                          */
rmlud12     number(10),              /*自订字段-整数                          */
rmlud13     date,                    /*自订字段-日期                          */
rmlud14     date,                    /*自订字段-日期                          */
rmlud15     date,                    /*自订字段-日期                          */
rmlplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rmllegal    varchar2(10) NOT NULL,   /*所属法人                               */
rmloriu     varchar2(10),            /*资料建立者                             */
rmlorig     varchar2(10)             /*资料建立部门                           */
);

alter table rml_file add  constraint rml_pk primary key  (rml01,rml03) enable validate;
grant select on rml_file to tiptopgp;
grant update on rml_file to tiptopgp;
grant delete on rml_file to tiptopgp;
grant insert on rml_file to tiptopgp;
grant index on rml_file to public;
grant select on rml_file to ods;
