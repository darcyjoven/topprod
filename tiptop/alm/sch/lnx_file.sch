/*
================================================================================
檔案代號:lnx_file
檔案名稱:合同優惠標準信息檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lnx_file
(
lnx01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同编号*/
lnx02       varchar2(20),            /*合同版本号                             */
lnx03       varchar2(10),            /*费用明细编号                           */
lnx04       number(6,2),             /*折扣率                                 */
lnx05       number(10),              /*减免月数                               */
lnx06       varchar2(1),             /*连锁状态                               */
lnx07       varchar2(10),            /*本店内连锁达数量                       */
lnx071      varchar2(10),            /*本店所属区域连锁达数量                 */
lnx072      varchar2(10),            /*其它区域连锁达数量                     */
lnx08       number(6,2),             /*本店内连锁达折扣率                     */
lnx081      number(6,2),             /*本店所属区域连锁达折扣率               */
lnx082      number(6,2),             /*其它区域连锁达折扣率                   */
lnx09       number(6,2),             /*本店内连锁取                           */
lnx091      number(6,2),             /*本店所属区域取                         */
lnx092      number(6,2),             /*其它区域取                             */
lnx10       number(6,2),             /*本店内连锁达最终折扣                   */
lnx101      number(6,2),             /*本店所属区域连锁达最终折扣             */
lnx102      number(6,2),             /*其它区域连锁达最终折扣                 */
lnxlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lnxplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table lnx_file add  constraint lnx_pk primary key  (lnx01) enable validate;
grant select on lnx_file to tiptopgp;
grant update on lnx_file to tiptopgp;
grant delete on lnx_file to tiptopgp;
grant insert on lnx_file to tiptopgp;
grant index on lnx_file to public;
grant select on lnx_file to ods;
