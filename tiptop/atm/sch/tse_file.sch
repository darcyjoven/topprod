/*
================================================================================
檔案代號:tse_file
檔案名稱:产品组合拆解单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tse_file
(
tse01       varchar2(20) DEFAULT ' ' NOT NULL, /*拆解单号*/
tse02       date,                    /*拆解日期                               */
tse03       varchar2(40),            /*料号                                   */
tse04       varchar2(4),             /*单位(生产单位)                         */
tse041      number(20,8),            /*单位转换率                             */
tse05       number(15,3),            /*数量                                   */
tse06       varchar2(4),             /*单位一                                 */
tse07       number(20,8),            /*单位一转换率                           */
tse08       number(15,3),            /*单位一数量                             */
tse09       varchar2(4),             /*单位二                                 */
tse10       number(20,8),            /*单位二转换率                           */
tse11       number(15,3),            /*单位二数量                             */
tse12       varchar2(10),            /*出库仓库                               */
tse13       varchar2(10),            /*出库库位                               */
tse14       varchar2(24),            /*出库批号                               */
tse15       varchar2(10),            /*部门                                   */
tse16       varchar2(10),            /*人员                                   */
tse17       varchar2(10),            /*理由码                                 */
tse18       varchar2(255),           /*备注                                   */
tseconf     varchar2(1),             /*确认码                                 */
tsepost     varchar2(1),             /*过帐否                                 */
tseacti     varchar2(1),             /*资料有效码                             */
tseuser     varchar2(10),            /*资料所有者                             */
tsegrup     varchar2(10),            /*资料所有部门                           */
tsemodu     varchar2(10),            /*资料更改者                             */
tsedate     date,                    /*最近更改日                             */
tseud01     varchar2(255),           /*自订字段-Textedit                      */
tseud02     varchar2(40),            /*自订字段-文字                          */
tseud03     varchar2(40),            /*自订字段-文字                          */
tseud04     varchar2(40),            /*自订字段-文字                          */
tseud05     varchar2(40),            /*自订字段-文字                          */
tseud06     varchar2(40),            /*自订字段-文字                          */
tseud07     number(15,3),            /*自订字段-数值                          */
tseud08     number(15,3),            /*自订字段-数值                          */
tseud09     number(15,3),            /*自订字段-数值                          */
tseud10     number(10),              /*自订字段-整数                          */
tseud11     number(10),              /*自订字段-整数                          */
tseud12     number(10),              /*自订字段-整数                          */
tseud13     date,                    /*自订字段-日期                          */
tseud14     date,                    /*自订字段-日期                          */
tseud15     date,                    /*自订字段-日期                          */
tse19       varchar2(20),            /*工单单号                               */
tsecond     date,                    /*审核日期                               */
tsecont     varchar2(8),             /*审核时间                               */
tseconu     varchar2(10),            /*审核人员                               */
tseplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tselegal    varchar2(10) NOT NULL,   /*所属法人                               */
tseorig     varchar2(10),            /*资料建立部门                           */
tseoriu     varchar2(10),            /*资料建立者                             */
tse20       varchar2(20),            /*POS单号                                */
tse21       date                     /*扣帐日期                               */
);

alter table tse_file add  constraint tse_pk primary key  (tse01) enable validate;
grant select on tse_file to tiptopgp;
grant update on tse_file to tiptopgp;
grant delete on tse_file to tiptopgp;
grant insert on tse_file to tiptopgp;
grant index on tse_file to public;
grant select on tse_file to ods;
