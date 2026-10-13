/*
================================================================================
檔案代號:axw_file
檔案名稱:合并报表关系人递延项摊销资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table axw_file
(
axw01       number(5) NOT NULL,      /*年度                                   */
axw02       number(5) NOT NULL,      /*期别                                   */
axw03       varchar2(10) NOT NULL,   /*集团代号                               */
axw04       number(5) NOT NULL,      /*项次                                   */
axw05       varchar2(1),             /*交易性质                               */
axw06       varchar2(1),             /*交易类型                               */
axw07       varchar2(10),            /*来源公司                               */
axw08       varchar2(10),            /*交易公司                               */
axw09       varchar2(24),            /*no use                                 */
axw10       varchar2(24),            /*no use                                 */
axw11       varchar2(4) NOT NULL,    /*来源币种                               */
axw12       number(20,6),            /*no use                                 */
axw13       number(20,6),            /*no use                                 */
axw14       number(20,6),            /*no use                                 */
axw15       number(15,3),            /*no use                                 */
axw16       number(20,6),            /*分配未实现利益                         */
axw17       number(5),               /*摊销总期数                             */
axw18       number(5),               /*已摊销期数                             */
axw19       number(20,6),            /*已摊销金额                             */
axw20       varchar2(1),             /*结案否                                 */
axw031      varchar2(10) NOT NULL,   /*母公司                                 */
axwlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table axw_file add  constraint axw_pk primary key  (axw01,axw02,axw03,axw031,axw04,axw11) enable validate;
grant select on axw_file to tiptopgp;
grant update on axw_file to tiptopgp;
grant delete on axw_file to tiptopgp;
grant insert on axw_file to tiptopgp;
grant index on axw_file to public;
grant select on axw_file to ods;
