/*
================================================================================
檔案代號:rvh_file
檔案名稱:退货单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvh_file
(
rvh01       varchar2(20) NOT NULL,   /*退货单号                               */
rvh02       number(5) NOT NULL,      /*退货单项次                             */
rvh03       number(5),               /*验收单项次                             */
rvh04       varchar2(40),            /*料件编号                               */
rvh05       number(15,3),            /*退货补货数量                           */
rvh06       varchar2(10),            /*理由                                   */
rvh07       number(15,3),            /*退货扣款数量                           */
rvh071      number(20,6),            /*退货扣款单价                           */
rvh072      number(15,3),            /*退货扣款已转应付系统待抵退             */
rvh08       varchar2(10),            /*理由                                   */
rvh09       varchar2(24),            /*检验批号                               */
rvh10       number(15,3),            /*检验数量                               */
rvh11       varchar2(10),            /*仓库编号                               */
rvh12       varchar2(10),            /*库位                                   */
rvh13       varchar2(24),            /*批号                                   */
rvh14       varchar2(10),            /*库存等级                               */
rvh15       number(15,3),            /*退货数量                               */
rvh16       varchar2(4),             /*退货单位                               */
rvh16_fac   number(20,8),            /*退货单位/库存单位转换率                */
rvh17       varchar2(20),            /*退货补货采购单号                       */
rvh18       number(5),               /*退货补货采购单项次                     */
rvh19       varchar2(1),             /*是否已生成退货补货采购单               */
rvh20       varchar2(24),            /*借方会计科目                           */
rvh21       varchar2(1),             /*保税过帐否                             */
                                     /*post to abx system flag                */
                                     /*'Y':確認                               */
                                     /*'N':未確認                             */
rvh22       varchar2(1),             /*No Use                                 */
rvh23       number(5),               /*No Use                                 */
rvh24       number(5),               /*No Use                                 */
rvh25       number(13,3),            /*No Use                                 */
rvhplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rvhlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table rvh_file add  constraint rvh_pk primary key  (rvh01,rvh02) enable validate;
grant select on rvh_file to tiptopgp;
grant update on rvh_file to tiptopgp;
grant delete on rvh_file to tiptopgp;
grant insert on rvh_file to tiptopgp;
grant index on rvh_file to public;
grant select on rvh_file to ods;
