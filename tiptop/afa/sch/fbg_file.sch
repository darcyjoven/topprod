/*
================================================================================
檔案代號:fbg_file
檔案名稱:资产报废/销账单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fbg_file
(
fbg00       varchar2(1),             /*类型                                   */
fbg01       varchar2(20) NOT NULL,   /*报废/销帐单号                          */
fbg02       date,                    /*报废/销帐日期                          */
fbg03       varchar2(10),            /*申请人员                               */
fbg04       varchar2(10),            /*申请部门                               */
fbg05       date,                    /*申请日期                               */
fbg06       varchar2(1),             /*No Use                                 */
fbg07       varchar2(1),             /*No Use                                 */
fbg08       varchar2(20),            /*凭证编号                               */
fbg09       date,                    /*凭证日期                               */
fbgconf     varchar2(1),             /*确认码                                 */
fbgpost     varchar2(1),             /*过帐码                                 */
fbgpost2    varchar2(1),             /*过帐码                                 */
fbgprsw     number(5),               /*打印次数                               */
fbguser     varchar2(10),            /*资料所有者                             */
fbggrup     varchar2(10),            /*资料所有群                             */
fbgmodu     varchar2(10),            /*资料更改者                             */
fbgdate     date,                    /*最近更改日                             */
fbg10       varchar2(1),             /*状况码                                 */
fbgmksg     varchar2(1),             /*签核否？                               */
fbgud01     varchar2(255),           /*自订字段-Textedit                      */
fbgud02     varchar2(40),            /*自订字段-文字                          */
fbgud03     varchar2(40),            /*自订字段-文字                          */
fbgud04     varchar2(40),            /*自订字段-文字                          */
fbgud05     varchar2(40),            /*自订字段-文字                          */
fbgud06     varchar2(40),            /*自订字段-文字                          */
fbgud07     number(15,3),            /*自订字段-数值                          */
fbgud08     number(15,3),            /*自订字段-数值                          */
fbgud09     number(15,3),            /*自订字段-数值                          */
fbgud10     number(10),              /*自订字段-整数                          */
fbgud11     number(10),              /*自订字段-整数                          */
fbgud12     number(10),              /*自订字段-整数                          */
fbgud13     date,                    /*自订字段-日期                          */
fbgud14     date,                    /*自订字段-日期                          */
fbgud15     date,                    /*自订字段-日期                          */
fbglegal    varchar2(10) NOT NULL,   /*所属法人                               */
fbgoriu     varchar2(10),            /*资料建立者                             */
fbgorig     varchar2(10),            /*资料建立部门                           */
fbg082      varchar2(20),            /*传票编号(财签二)                       */
fbg092      date                     /*传票日期(财签二)                       */
);

create        index fbg_02 on fbg_file (fbg08);
alter table fbg_file add  constraint fbg_pk primary key  (fbg01) enable validate;
grant select on fbg_file to tiptopgp;
grant update on fbg_file to tiptopgp;
grant delete on fbg_file to tiptopgp;
grant insert on fbg_file to tiptopgp;
grant index on fbg_file to public;
grant select on fbg_file to ods;
