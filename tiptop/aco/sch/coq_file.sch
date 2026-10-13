/*
================================================================================
檔案代號:coq_file
檔案名稱:产品折合原料明细资料档 (A046)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table coq_file
(
coq00       varchar2(1) NOT NULL,    /*资料类型                               */
coq01       varchar2(40) NOT NULL,   /*原料料号                               */
coq02       varchar2(40) NOT NULL,   /*半成品/成品料号/工单单号               */
coq03       varchar2(10) NOT NULL,   /*仓库                                   */
coq04       varchar2(10) NOT NULL,   /*库位                                   */
coq05       varchar2(24) NOT NULL,   /*批号                                   */
coq06       varchar2(4),             /*单位                                   */
coq07       number(15,3),            /*原料库存数量/成品/半成品数             */
coq08       number(16,8),            /*组成用量                               */
coq09       varchar2(4),             /*生产单位                               */
coq10       number(15,3),            /*下阶料数量                             */
coq11       varchar2(40),            /*生产料号                               */
coq12       number(15,3),            /*预计生产量                             */
coq13       number(15,3),            /*完工入库量                             */
coq14       number(15,3),            /*已发数量                               */
coq15       number(15,3),            /*入库转出量                             */
coq16       varchar2(4),             /*发料单位                               */
coq17       number(15,3),            /*在制量                                 */
coq18       varchar2(1),             /*No Use                                 */
coqplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
coqlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table coq_file add  constraint coq_pk primary key  (coq00,coq01,coq02,coq03,coq04,coq05) enable validate;
grant select on coq_file to tiptopgp;
grant update on coq_file to tiptopgp;
grant delete on coq_file to tiptopgp;
grant insert on coq_file to tiptopgp;
grant index on coq_file to public;
grant select on coq_file to ods;
