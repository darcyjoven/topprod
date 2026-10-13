/*
================================================================================
檔案代號:adk_file
檔案名稱:派车单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table adk_file
(
adk01       varchar2(20) NOT NULL,   /*派车单单号                             */
adk02       date,                    /*单据日期                               */
adk03       varchar2(10),            /*派车原因                               */
adk04       date,                    /*出车日期                               */
adk05       varchar2(5),             /*出车时间                               */
adk06       date,                    /*预计返回日期                           */
adk07       varchar2(5),             /*预计返回时间                           */
adk08       varchar2(10),            /*车辆编号                               */
adk09       varchar2(10),            /*驾驶员                                 */
adk10       varchar2(10),            /*随车人员一                             */
adk11       varchar2(10),            /*随车人员二                             */
adk12       varchar2(10),            /*随车人员三                             */
adk13       varchar2(10),            /*员工编号                               */
adk14       varchar2(10),            /*部门编号                               */
adk15       varchar2(6),             /*运输途径                               */
adk16       varchar2(255),           /*备注                                   */
adk17       varchar2(1),             /*状况码                                 */
adkmksg     varchar2(1),             /*签核否                                 */
adksign     varchar2(4),             /*签核等级                               */
adkdays     number(5),               /*签核完成天数                           */
adkprit     number(5),               /*签核优先等级                           */
adksseq     number(5),               /*已签核顺序                             */
adksmax     number(5),               /*应签核顺序                             */
adkconf     varchar2(1),             /*审核                                   */
adkprsw     number(5),               /*打印次数                               */
adkacti     varchar2(1),             /*资料有效码                             */
adkuser     varchar2(10),            /*资料所有者                             */
adkgrup     varchar2(10),            /*资料所有部门                           */
adkmodu     varchar2(10),            /*资料更改者                             */
adkdate     date,                    /*最近更改日                             */
adkud01     varchar2(255),           /*自订字段-Textedit                      */
adkud02     varchar2(40),            /*自订字段-文字                          */
adkud03     varchar2(40),            /*自订字段-文字                          */
adkud04     varchar2(40),            /*自订字段-文字                          */
adkud05     varchar2(40),            /*自订字段-文字                          */
adkud06     varchar2(40),            /*自订字段-文字                          */
adkud07     number(15,3),            /*自订字段-数值                          */
adkud08     number(15,3),            /*自订字段-数值                          */
adkud09     number(15,3),            /*自订字段-数值                          */
adkud10     number(10),              /*自订字段-整数                          */
adkud11     number(10),              /*自订字段-整数                          */
adkud12     number(10),              /*自订字段-整数                          */
adkud13     date,                    /*自订字段-日期                          */
adkud14     date,                    /*自订字段-日期                          */
adkud15     date,                    /*自订字段-日期                          */
adkcond     date,                    /*审核日期                               */
adkconu     varchar2(10),            /*审核人员                               */
adkplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
adklegal    varchar2(10) NOT NULL,   /*所属法人                               */
adkoriu     varchar2(10),            /*资料建立者                             */
adkorig     varchar2(10)             /*资料建立部门                           */
);

alter table adk_file add  constraint adk_pk primary key  (adk01) enable validate;
grant select on adk_file to tiptopgp;
grant update on adk_file to tiptopgp;
grant delete on adk_file to tiptopgp;
grant insert on adk_file to tiptopgp;
grant index on adk_file to public;
grant select on adk_file to ods;
