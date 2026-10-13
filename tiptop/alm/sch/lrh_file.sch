/*
================================================================================
檔案代號:lrh_file
檔案名稱:赠品发放记录单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lrh_file
(
lrh00       varchar2(10),            /*no use                                 */
lrh01       varchar2(20) DEFAULT ' ' NOT NULL, /*赠品发放单号*/
lrh02       varchar2(20),            /*摊位编号                               */
lrh03       varchar2(20),            /*合同编号                               */
lrh04       varchar2(10),            /*商户号                                 */
lrh05       varchar2(10),            /*主品牌                                 */
lrh06       date,                    /*赠品发放日期                           */
lrh07       varchar2(20),            /*促销单编号                             */
lrh08       number(20,2) DEFAULT '0' NOT NULL, /*交款总金额*/
lrh09       varchar2(20),            /*赠送赠品编号                           */
lrh10       number(20,2) DEFAULT '0' NOT NULL, /*赠品价格*/
lrh11       varchar2(1) DEFAULT ' ' NOT NULL, /*赠品回收否*/
lrh12       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lrh13       varchar2(10),            /*审核人                                 */
lrh14       date,                    /*审核日期                               */
lrh15       varchar2(50),            /*备注                                   */
lrh16       number(20,2) DEFAULT '0' NOT NULL, /*合同总金额*/
lrh17       varchar2(10),            /*楼栋编号                               */
lrh18       varchar2(10),            /*楼层编号                               */
lrh19       varchar2(10),            /*大类编号                               */
lrh20       varchar2(10),            /*中类编号                               */
lrh21       varchar2(10),            /*小类编号                               */
lrhcrat     date,                    /*资料创建日                             */
lrhdate     date,                    /*最近更改日                             */
lrhgrup     varchar2(10),            /*资料所有群                             */
lrhlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lrhmodu     varchar2(10),            /*资料更改者                             */
lrhplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lrhuser     varchar2(10),            /*资料所有者                             */
lrhoriu     varchar2(10),            /*资料建立者                             */
lrhorig     varchar2(10)             /*资料建立部门                           */
);

alter table lrh_file add  constraint lrh_pk primary key  (lrh01) enable validate;
grant select on lrh_file to tiptopgp;
grant update on lrh_file to tiptopgp;
grant delete on lrh_file to tiptopgp;
grant insert on lrh_file to tiptopgp;
grant index on lrh_file to public;
grant select on lrh_file to ods;
