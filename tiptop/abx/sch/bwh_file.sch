/*
================================================================================
檔案代號:bwh_file
檔案名稱:年度保税原料结算资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table bwh_file
(
bwh01       number(5) NOT NULL,      /*年度                                   */
bwh02       varchar2(40) NOT NULL,   /*料件编号                               */
bwh03       number(15,3),            /*期初保税结存数                         */
bwh04       number(15,3),            /*期初非保税结存数                       */
bwh05       number(15,3),            /*本期保税进货数                         */
bwh06       number(15,3),            /*本期非保税进货数                       */
bwh07       number(15,3),            /*本期外销使用数                         */
bwh08       number(15,3),            /*本期内销使用数                         */
bwh09       number(15,3),            /*本期外运数                             */
                                     /*本期外運數                             */
bwh10       number(15,3),            /*本期报废数                             */
                                     /*本期報廢數                             */
bwh11       number(15,3),            /*本期盘存数                             */
bwh12       number(15,3),            /*本期盘盈亏数                           */
bwh13       number(15,3),            /*盘差容许数量                           */
bwh14       number(15,3),            /*本期盘差补税数                         */
bwh15       number(15,3),            /*期末应结转下期保税数                   */
bwh16       number(15,3),            /*期末应结转下期非保税数                 */
bwhplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bwhlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table bwh_file add  constraint bwh_pk primary key  (bwh01,bwh02) enable validate;
grant select on bwh_file to tiptopgp;
grant update on bwh_file to tiptopgp;
grant delete on bwh_file to tiptopgp;
grant insert on bwh_file to tiptopgp;
grant index on bwh_file to public;
grant select on bwh_file to ods;
