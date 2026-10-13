/*
================================================================================
檔案代號:axq_file
檔案名稱:公司科目余额暂存资料(非TIPTOP公司)
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table axq_file
(
axq00       varchar2(5) NOT NULL,    /*帐套编号                               */
axq01       varchar2(10) NOT NULL,   /*集团代号                               */
axq02       varchar2(10) NOT NULL,   /*上层公司编号                           */
axq03       varchar2(5) NOT NULL,    /*上层帐套                               */
axq04       varchar2(10) NOT NULL,   /*子公司编号                             */
axq041      varchar2(5) NOT NULL,    /*子公司账套                             */
axq05       varchar2(24) NOT NULL,   /*科目编号                               */
axq06       number(5) NOT NULL,      /*会计年度                               */
axq07       number(5) NOT NULL,      /*期别                                   */
axq08       number(20,6),            /*借方金额                               */
axq09       number(20,6),            /*贷方金额                               */
axq10       number(10),              /*借方笔数                               */
axq11       number(10),              /*贷方笔数                               */
axq12       varchar2(4) NOT NULL,    /*币种                                   */
axq13       varchar2(10) NOT NULL,   /*关系人编号                             */
axqconf     varchar2(1),             /*审核否                                 */
axqpost     varchar2(1),             /*更新否                                 */
axqacti     varchar2(1),             /*有效否                                 */
axquser     varchar2(10),            /*资料所有者                             */
axqgrup     varchar2(10),            /*资料所有群                             */
axqmodu     varchar2(10),            /*资料更改者                             */
axqdate     date,                    /*最近更改日                             */
axq051      varchar2(255),           /*来源科目名称                           */
axqlegal    varchar2(10) NOT NULL,   /*所属法人                               */
axqorig     varchar2(10),            /*资料建立部门                           */
axqoriu     varchar2(10),            /*资料建立者                             */
axq14       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项5值*/
axq15       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项6值*/
axq16       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项7值*/
axq17       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项8值*/
axq18       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
axq19       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
axq20       varchar2(4),             /*no use                                 */
axq21       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
axq22       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
axq23       varchar2(4),             /*no use                                 */
axq24       varchar2(10) DEFAULT ' ' NOT NULL, /*no use*/
axq29       varchar2(10)
);

alter table axq_file add  constraint axq_pk primary key  (axq01,axq02,axq03,axq04,axq041,axq05,axq06,axq07,axq00,axq12,axq13,axq14,axq15,axq16,axq17) enable validate;
grant select on axq_file to tiptopgp;
grant update on axq_file to tiptopgp;
grant delete on axq_file to tiptopgp;
grant insert on axq_file to tiptopgp;
grant index on axq_file to public;
grant select on axq_file to ods;
