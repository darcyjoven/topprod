/*
================================================================================
檔案代號:ahj_file
檔案名稱:外部销售利润分摊档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ahj_file
(
ahj01       varchar2(10) NOT NULL,   /*成本中心                               */
ahj02       number(5) NOT NULL,      /*年度                                   */
ahj03       number(5) NOT NULL,      /*期别                                   */
ahj04       varchar2(20) NOT NULL,   /*出货单号                               */
ahj05       number(5) NOT NULL,      /*项次                                   */
ahj06       varchar2(40),            /*料号                                   */
ahj061      varchar2(120),           /*品名                                   */
ahj07       number(15,3),            /*数量                                   */
ahj08       number(20,6),            /*成本单价                               */
ahj09       number(20,6),            /*成本金额                               */
ahj10       number(20,6),            /*内部单价                               */
ahj11       number(20,6),            /*内部金额                               */
ahj12       number(20,6),            /*销售单价                               */
ahj13       number(20,6),            /*销售金额                               */
ahj14       number(20,6),            /*内部利润                               */
ahj15       varchar2(10),            /*分摊成本中心                           */
ahj16       number(15,3),            /*分摊比率                               */
ahj17       number(20,6),            /*分摊金额                               */
ahj18       varchar2(30),            /*分录单号                               */
ahj19       varchar2(10)             /*资料来源营运中心                       */
);

alter table ahj_file add  constraint ahj_pk primary key  (ahj01,ahj02,ahj03,ahj04,ahj05) enable validate;
grant select on ahj_file to tiptopgp;
grant update on ahj_file to tiptopgp;
grant delete on ahj_file to tiptopgp;
grant insert on ahj_file to tiptopgp;
grant index on ahj_file to public;
grant select on ahj_file to ods;
