/*
================================================================================
檔案代號:tsc_file
檔案名稱:产品组合单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tsc_file
(
tsc01       varchar2(20) NOT NULL,   /*组合单号                               */
tsc02       date,                    /*组合日期                               */
tsc03       varchar2(40),            /*料号                                   */
tsc04       varchar2(4),             /*单位(生产单位)                         */
tsc041      number(20,8),            /*单位转换率                             */
tsc05       number(15,3),            /*数量                                   */
tsc06       varchar2(4),             /*单位一                                 */
tsc07       number(20,8),            /*单位一转换率                           */
tsc08       number(15,3),            /*单位一数量                             */
tsc09       varchar2(4),             /*单位二                                 */
tsc10       number(20,8),            /*单位二转换率                           */
tsc11       number(15,3),            /*单位二数量                             */
tsc12       varchar2(10),            /*入库仓库                               */
tsc13       varchar2(10),            /*入库库位                               */
tsc14       varchar2(24),            /*入库批号                               */
tsc15       varchar2(10),            /*部门                                   */
tsc16       varchar2(10),            /*人员                                   */
tsc17       varchar2(10),            /*理由码                                 */
tsc18       varchar2(255),           /*备注                                   */
tscconf     varchar2(1),             /*确认码                                 */
tscpost     varchar2(1),             /*过帐否                                 */
tscacti     varchar2(1),             /*资料有效码                             */
tscuser     varchar2(10),            /*资料所有者                             */
tscgrup     varchar2(10),            /*资料所有部门                           */
tscmodu     varchar2(10),            /*资料更改者                             */
tscdate     date,                    /*最近更改日                             */
tscud01     varchar2(255),           /*自订字段-Textedit                      */
tscud02     varchar2(40),            /*移转单号                               */
tscud03     varchar2(40),            /*自订字段-文字                          */
tscud04     varchar2(40),            /*自订字段-文字                          */
tscud05     varchar2(40),            /*自订字段-文字                          */
tscud06     varchar2(40),            /*自订字段-文字                          */
tscud07     number(15,3),            /*自订字段-数值                          */
tscud08     number(15,3),            /*自订字段-数值                          */
tscud09     number(15,3),            /*自订字段-数值                          */
tscud10     number(10),              /*自订字段-整数                          */
tscud11     number(10),              /*自订字段-整数                          */
tscud12     number(10),              /*自订字段-整数                          */
tscud13     date,                    /*自订字段-日期                          */
tscud14     date,                    /*自订字段-日期                          */
tscud15     date,                    /*自订字段-日期                          */
tsc19       varchar2(20),            /*工单单号                               */
tsccond     date,                    /*审核日期                               */
tsccont     varchar2(8),             /*审核时间                               */
tscconu     varchar2(10),            /*审核人员                               */
tscplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tsclegal    varchar2(10) NOT NULL,   /*所属法人                               */
tscorig     varchar2(10),            /*资料建立部门                           */
tscoriu     varchar2(10),            /*资料建立者                             */
tsc20       varchar2(20),            /*POS单号                                */
tsc21       date                     /*扣帐日期                               */
);

alter table tsc_file add  constraint tsc_pk primary key  (tsc01) enable validate;
grant select on tsc_file to tiptopgp;
grant update on tsc_file to tiptopgp;
grant delete on tsc_file to tiptopgp;
grant insert on tsc_file to tiptopgp;
grant index on tsc_file to public;
grant select on tsc_file to ods;
