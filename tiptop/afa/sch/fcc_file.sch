/*
================================================================================
檔案代號:fcc_file
檔案名稱:固定资产投资抵减单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fcc_file
(
fcc01       varchar2(20) NOT NULL,   /*申请编号                               */
fcc02       number(5),               /*项次                                   */
fcc03       varchar2(10) NOT NULL,   /*财产编号                               */
fcc031      varchar2(4) NOT NULL,    /*附号                                   */
fcc04       varchar2(1),             /*合并码                                 */
fcc05       varchar2(80),            /*中文名称                               */
fcc06       varchar2(80),            /*英文名称                               */
fcc07       varchar2(40),            /*规格型号                               */
fcc08       varchar2(80),            /*厂商名称                               */
fcc09       number(5),               /*数量                                   */
fcc10       varchar2(4),             /*单位                                   */
fcc11       varchar2(80),            /*用途                                   */
fcc12       varchar2(255),           /*备注                                   */
fcc13       number(20,6),            /*原币成本                               */
fcc14       varchar2(4),             /*原币币种                               */
fcc15       number(5),               /*抵减率                                 */
fcc16       number(20,6),            /*本币成本                               */
fcc17       date,                    /*契约日期                               */
fcc18       date,                    /*I/L 日期                               */
fcc19       date,                    /*交货日期                               */
fcc191      date,                    /*安装日期                               */
fcc20       varchar2(1),             /*抵减状态                               */
fcc21       number(5),               /*合并后数量                             */
fcc22       varchar2(4),             /*合并后单位                             */
fcc23       number(20,6),            /*合并后原币成本                         */
fcc24       number(20,6),            /*合并后本币成本                         */
fcc25       number(15,2),            /*No Use                                 */
fcc26       varchar2(40),            /*设备或技术来源                         */
fcc27       date,                    /*No Use                                 */
fccud01     varchar2(255),           /*自订字段-Textedit                      */
fccud02     varchar2(40),            /*自订字段-文字                          */
fccud03     varchar2(40),            /*自订字段-文字                          */
fccud04     varchar2(40),            /*自订字段-文字                          */
fccud05     varchar2(40),            /*自订字段-文字                          */
fccud06     varchar2(40),            /*自订字段-文字                          */
fccud07     number(15,3),            /*自订字段-数值                          */
fccud08     number(15,3),            /*自订字段-数值                          */
fccud09     number(15,3),            /*自订字段-数值                          */
fccud10     number(10),              /*自订字段-整数                          */
fccud11     number(10),              /*自订字段-整数                          */
fccud12     number(10),              /*自订字段-整数                          */
fccud13     date,                    /*自订字段-日期                          */
fccud14     date,                    /*自订字段-日期                          */
fccud15     date,                    /*自订字段-日期                          */
fcclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table fcc_file add  constraint fcc_pk primary key  (fcc01,fcc03,fcc031) enable validate;
grant select on fcc_file to tiptopgp;
grant update on fcc_file to tiptopgp;
grant delete on fcc_file to tiptopgp;
grant insert on fcc_file to tiptopgp;
grant index on fcc_file to public;
grant select on fcc_file to ods;
