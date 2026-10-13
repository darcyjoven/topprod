/*
================================================================================
檔案代號:fci_file
檔案名稱:固定资产免税单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fci_file
(
fci01       varchar2(20) NOT NULL,   /*申请编号                               */
fci02       number(5),               /*项次                                   */
fci03       varchar2(10) NOT NULL,   /*财产编号                               */
fci031      varchar2(4) NOT NULL,    /*附号                                   */
fci04       varchar2(80),            /*中文名称                               */
fci05       varchar2(80),            /*英文名称                               */
fci06       varchar2(30),            /*规格型号                               */
fci07       varchar2(10),            /*合并财产编号                           */
fci071      varchar2(4),             /*合并附号                               */
fci08       varchar2(10),            /*厂商                                   */
fci09       number(5),               /*数量                                   */
fci10       varchar2(4),             /*单位                                   */
fci11       varchar2(20),            /*发票号码                               */
fci12       varchar2(10),            /*进口编号                               */
fci13       varchar2(20),            /*采购单号                               */
fci14       varchar2(30),            /*进口报单                               */
fci15       number(20,6),            /*本币成本                               */
fci16       varchar2(40),            /*用途                                   */
fci17       date,                    /*购进日期                               */
fci18       varchar2(1),             /*类型                                   */
fci19       varchar2(1),             /*核准状态                               */
fci20       number(5),               /*合并前数量                             */
fci21       varchar2(4),             /*合并前单位                             */
fci22       number(20,6),            /*合并前本币成本                         */
fciud01     varchar2(255),           /*自订字段-Textedit                      */
fciud02     varchar2(40),            /*自订字段-文字                          */
fciud03     varchar2(40),            /*自订字段-文字                          */
fciud04     varchar2(40),            /*自订字段-文字                          */
fciud05     varchar2(40),            /*自订字段-文字                          */
fciud06     varchar2(40),            /*自订字段-文字                          */
fciud07     number(15,3),            /*自订字段-数值                          */
fciud08     number(15,3),            /*自订字段-数值                          */
fciud09     number(15,3),            /*自订字段-数值                          */
fciud10     number(10),              /*自订字段-整数                          */
fciud11     number(10),              /*自订字段-整数                          */
fciud12     number(10),              /*自订字段-整数                          */
fciud13     date,                    /*自订字段-日期                          */
fciud14     date,                    /*自订字段-日期                          */
fciud15     date,                    /*自订字段-日期                          */
fcilegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table fci_file add  constraint fci_pk primary key  (fci01,fci03,fci031) enable validate;
grant select on fci_file to tiptopgp;
grant update on fci_file to tiptopgp;
grant delete on fci_file to tiptopgp;
grant insert on fci_file to tiptopgp;
grant index on fci_file to public;
grant select on fci_file to ods;
