/*
================================================================================
檔案代號:axv_file
檔案名稱:合并报表关系人交易资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table axv_file
(
axv01       number(5) NOT NULL,      /*年度                                   */
axv02       number(5) NOT NULL,      /*期别                                   */
axv03       varchar2(10) NOT NULL,   /*集团代号                               */
axv04       number(5) NOT NULL,      /*项次                                   */
axv05       varchar2(1),             /*交易性质                               */
axv06       varchar2(1),             /*交易类型                               */
axv07       varchar2(10),            /*来源公司                               */
axv08       varchar2(10),            /*交易公司                               */
axv09       varchar2(24),            /*帐列科目                               */
axv10       varchar2(24),            /*交易科目                               */
axv11       varchar2(4) NOT NULL,    /*来源币种                               */
axv12       number(20,6),            /*交易金额                               */
axv13       number(20,6),            /*交易损益                               */
axv14       number(20,6),            /*未实现利益                             */
axv15       number(15,3),            /*持股比率                               */
axv16       number(20,6),            /*分配未实现利益                         */
axv031      varchar2(10) NOT NULL,   /*母公司                                 */
axv131      number(20,6),            /*已实现损益                             */
axv17       varchar2(20),            /*来源单号                               */
axvlegal    varchar2(10) NOT NULL,   /*所属法人                               */
axv18       varchar2(20)             /*调整单号                               */
);

alter table axv_file add  constraint axv_pk primary key  (axv01,axv02,axv03,axv031,axv04,axv11) enable validate;
grant select on axv_file to tiptopgp;
grant update on axv_file to tiptopgp;
grant delete on axv_file to tiptopgp;
grant insert on axv_file to tiptopgp;
grant index on axv_file to public;
grant select on axv_file to ods;
