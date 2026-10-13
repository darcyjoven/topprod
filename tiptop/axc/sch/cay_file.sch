/*
================================================================================
檔案代號:cay_file
檔案名稱:成本分摊比例档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cay_file
(
cay00       varchar2(1) NOT NULL,    /*分摊类型 (1:人工 2:制费)               */
cay01       number(5) NOT NULL,      /*年度                                   */
cay02       number(5) NOT NULL,      /*月份                                   */
cay03       varchar2(10) NOT NULL,   /*部门编号                               */
cay04       varchar2(10) NOT NULL,   /*成本中心                               */
cay05       number(15,3),            /*分摊权数                               */
cay06       varchar2(24) NOT NULL,   /*会计科目                               */
cay07       varchar2(1),             /*No Use                                 */
cay08       varchar2(1),             /*部门属性                               */
cay09       varchar2(1),             /*分摊比率来源                           */
cay10       varchar2(24),            /*分摊来源科目                           */
cayacti     varchar2(1),             /*有效否                                 */
cayuser     varchar2(10),            /*资料所有者                             */
caygrup     varchar2(10),            /*资料所有部门                           */
caymodu     varchar2(10),            /*资料更改者                             */
caydate     date,                    /*最近更改日                             */
cayorig     varchar2(10),            /*资料建立部门                           */
cayoriu     varchar2(10),            /*资料建立者                             */
cay12       varchar2(1),             /*分摊方式                               */
cay11       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
caylegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cay_file add  constraint cay_pk primary key  (cay00,cay01,cay02,cay03,cay04,cay06,cay11) enable validate;
grant select on cay_file to tiptopgp;
grant update on cay_file to tiptopgp;
grant delete on cay_file to tiptopgp;
grant insert on cay_file to tiptopgp;
grant index on cay_file to public;
grant select on cay_file to ods;
