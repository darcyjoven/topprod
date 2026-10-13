/*
================================================================================
檔案代號:fbl_file
檔案名稱:固定资产存放位置异动单
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fbl_file
(
fbl01       varchar2(20) NOT NULL,   /*异动单号                               */
fbl02       date,                    /*异动日期                               */
fbl03       varchar2(10),            /*申请人员                               */
fbl04       varchar2(10),            /*申请部门                               */
fbl05       date,                    /*申请日期                               */
fbl06       varchar2(10),            /*原因码                                 */
fblconf     varchar2(1),             /*审核否                                 */
fblpost     varchar2(1),             /*过帐否                                 */
fblprsw     number(5),               /*打印次数                               */
fbluser     varchar2(10),            /*资料所有者                             */
fblgrup     varchar2(10),            /*资料所有部门                           */
fblmodu     varchar2(10),            /*资料更改者                             */
fbldate     date,                    /*最近更改日                             */
fbl07       varchar2(1),             /*状况码                                 */
fblmksg     varchar2(1),             /*签核否？                               */
fblud01     varchar2(255),           /*自订字段-Textedit                      */
fblud02     varchar2(40),            /*自订字段-文字                          */
fblud03     varchar2(40),            /*自订字段-文字                          */
fblud04     varchar2(40),            /*自订字段-文字                          */
fblud05     varchar2(40),            /*自订字段-文字                          */
fblud06     varchar2(40),            /*自订字段-文字                          */
fblud07     number(15,3),            /*自订字段-数值                          */
fblud08     number(15,3),            /*自订字段-数值                          */
fblud09     number(15,3),            /*自订字段-数值                          */
fblud10     number(10),              /*自订字段-整数                          */
fblud11     number(10),              /*自订字段-整数                          */
fblud12     number(10),              /*自订字段-整数                          */
fblud13     date,                    /*自订字段-日期                          */
fblud14     date,                    /*自订字段-日期                          */
fblud15     date,                    /*自订字段-日期                          */
fbllegal    varchar2(10) NOT NULL,   /*所属法人                               */
fbloriu     varchar2(10),            /*资料建立者                             */
fblorig     varchar2(10)             /*资料建立部门                           */
);

alter table fbl_file add  constraint fbl_pk primary key  (fbl01) enable validate;
grant select on fbl_file to tiptopgp;
grant update on fbl_file to tiptopgp;
grant delete on fbl_file to tiptopgp;
grant insert on fbl_file to tiptopgp;
grant index on fbl_file to public;
grant select on fbl_file to ods;
