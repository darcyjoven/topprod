/*
================================================================================
檔案代號:lqd_file
檔案名稱:券发放记录单头
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lqd_file
(
lqd00       varchar2(10),            /*门店编号                               */
lqd01       varchar2(20) DEFAULT ' ' NOT NULL, /*券发放单号*/
lqd02       varchar2(20),            /*摊位编号                               */
lqd03       varchar2(20),            /*合同编号                               */
lqd04       varchar2(10),            /*商户编号                               */
lqd05       varchar2(10),            /*主品牌                                 */
lqd06       date,                    /*券发放日期                             */
lqd07       varchar2(20),            /*促销单编号                             */
lqd08       number(20,6),            /*可返券交款金额                         */
lqd09       varchar2(20),            /*返券类型                               */
lqd10       number(20,6),            /*返券金额                               */
lqd11       varchar2(1),             /*促销哦类型                             */
lqd12       varchar2(1),             /*审核码                                 */
lqd13       varchar2(10),            /*审核人                                 */
lqd14       date,                    /*审核日期                               */
lqd15       varchar2(80),            /*备注                                   */
lqd16       number(20,6),            /*合同总金额                             */
lqd17       varchar2(10),            /*楼栋                                   */
lqd18       varchar2(10),            /*楼层                                   */
lqd19       varchar2(10),            /*经营大类                               */
lqd20       varchar2(10),            /*经营中类                               */
lqd21       varchar2(10),            /*经营小类                               */
lqdcrat     date,                    /*资料创建日                             */
lqddate     varchar2(10),            /*最近更改日                             */
lqdgrup     varchar2(10),            /*资料所有群                             */
lqdlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lqdmodu     varchar2(10),            /*资料更改者                             */
lqdplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lqduser     varchar2(10),            /*资料所有者                             */
lqdoriu     varchar2(10),            /*资料建立者                             */
lqdorig     varchar2(10)             /*资料建立部门                           */
);

alter table lqd_file add  constraint lqd_pk primary key  (lqd01) enable validate;
grant select on lqd_file to tiptopgp;
grant update on lqd_file to tiptopgp;
grant delete on lqd_file to tiptopgp;
grant insert on lqd_file to tiptopgp;
grant index on lqd_file to public;
grant select on lqd_file to ods;
