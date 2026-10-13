/*
================================================================================
檔案代號:loe_file
檔案名稱:合同变更优惠标准信息档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table loe_file
(
loe01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同编号*/
loe02       varchar2(20) DEFAULT ' ' NOT NULL, /*合同版本号*/
loe03       varchar2(10),            /*费用明细编号                           */
loe04       number(6,2),             /*折扣率                                 */
loe05       number(10),              /*减免月数                               */
loe06       varchar2(1) DEFAULT ' ' NOT NULL, /*连锁状态*/
loe07       number(10),              /*本店内连锁达数量                       */
loe071      number(10),              /*本店所属区域连锁达数量                 */
loe072      number(10),              /*其它区域连锁达数量                     */
loe08       number(6,2),             /*本店内连锁达折扣率                     */
loe081      number(6,2),             /*本店所属区域连锁达折扣率               */
loe082      number(6,2),             /*其它区域连锁达折扣率                   */
loe09       number(6,2),             /*本店内连锁取                           */
loe091      number(6,2),             /*本店所属区域取                         */
loe092      number(6,2),             /*其它区域取                             */
loe10       number(6,2),             /*本店内连锁达最终折扣                   */
loe101      number(6,2),             /*本店所属区域连锁达最终折扣             */
loe102      number(6,2),             /*其它区域连锁达最终折扣                 */
loelegal    varchar2(10) NOT NULL,   /*所属法人                               */
loeplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table loe_file add  constraint loe_pk primary key  (loe01,loe02) enable validate;
grant select on loe_file to tiptopgp;
grant update on loe_file to tiptopgp;
grant delete on loe_file to tiptopgp;
grant insert on loe_file to tiptopgp;
grant index on loe_file to public;
grant select on loe_file to ods;
