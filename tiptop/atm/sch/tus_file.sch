/*
================================================================================
檔案代號:tus_file
檔案名稱:客户库存调整单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tus_file
(
tus01       varchar2(20) NOT NULL,   /*库存调整单号                           */
tus02       date,                    /*异动日期                               */
tus03       varchar2(10),            /*客户编号                               */
tus04       varchar2(10),            /*员工编号                               */
tus05       varchar2(10),            /*部门编号                               */
tus06       varchar2(255),           /*备注                                   */
tus07       varchar2(1),             /*状况码                                 */
tusmksg     varchar2(1),             /*是否签核                               */
tussign     varchar2(4),             /*签核等级                               */
tusdays     number(5),               /*签核完成天数                           */
tusprit     number(5),               /*签核优先等级                           */
tussseq     number(5),               /*已签核顺序                             */
tussmax     number(5),               /*应签核顺序                             */
tusconf     varchar2(1),             /*审核                                   */
tuspost     varchar2(1),             /*过帐否                                 */
tusprsw     number(5),               /*打印次数                               */
tusacti     varchar2(1),             /*有效否                                 */
tususer     varchar2(10),            /*建档人员                               */
tusgrup     varchar2(10),            /*建档部门                               */
tusmodu     varchar2(10),            /*最后更改人员                           */
tusdate     date,                    /*最后更改日期                           */
tus08       varchar2(1),             /*库存类型                               */
                                     /*1=Customer Inventory                   */
                                     /*2=Consign Inventory                    */
tus09       varchar2(10),            /*送货客户                               */
tus10       varchar2(20),            /*原始单号                               */
tus11       number(5),               /*更改版本                               */
tus12       varchar2(1),             /*抛转出货单否                           */
tus13       varchar2(16),            /*No Use                                 */
tus14       varchar2(1),             /*No Use                                 */
tus15       varchar2(1),             /*nosus                                  */
tus16       varchar2(1),             /*No Use                                 */
tusud01     varchar2(255),           /*自订字段-Textedit                      */
tusud02     varchar2(40),            /*自订字段-文字                          */
tusud03     varchar2(40),            /*自订字段-文字                          */
tusud04     varchar2(40),            /*自订字段-文字                          */
tusud05     varchar2(40),            /*自订字段-文字                          */
tusud06     varchar2(40),            /*自订字段-文字                          */
tusud07     number(15,3),            /*自订字段-数值                          */
tusud08     number(15,3),            /*自订字段-数值                          */
tusud09     number(15,3),            /*自订字段-数值                          */
tusud10     number(10),              /*自订字段-整数                          */
tusud11     number(10),              /*自订字段-整数                          */
tusud12     number(10),              /*自订字段-整数                          */
tusud13     date,                    /*自订字段-日期                          */
tusud14     date,                    /*自订字段-日期                          */
tusud15     date,                    /*自订字段-日期                          */
tusplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tuslegal    varchar2(10) NOT NULL,   /*所属法人                               */
tusoriu     varchar2(10),            /*资料建立者                             */
tusorig     varchar2(10)             /*资料建立部门                           */
);

alter table tus_file add  constraint tus_pk primary key  (tus01) enable validate;
grant select on tus_file to tiptopgp;
grant update on tus_file to tiptopgp;
grant delete on tus_file to tiptopgp;
grant insert on tus_file to tiptopgp;
grant index on tus_file to public;
grant select on tus_file to ods;
