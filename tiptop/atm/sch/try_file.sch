/*
================================================================================
檔案代號:try_file
檔案名稱:订单物返未达成记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table try_file
(
try01       varchar2(20) DEFAULT ' ' NOT NULL, /*订单单号 物返未达成的来源订*/
try02       number(5) DEFAULT '0' NOT NULL, /*订单项次 物返未达成的来源订*/
try03       varchar2(40),            /*搭赠料号                               */
try04       number(15,3),            /*需补返数量                             */
try05       varchar2(4),             /*销售单位                               */
try06       varchar2(1),             /*结案,y/n                               */
try07       varchar2(20),            /*物返来源合同号码                       */
try08       number(5),               /*物返来源合同项次                       */
try09       varchar2(10),            /*理由码                                 */
try10       number(15,3),            /*已补返数量                             */
tryplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
trylegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table try_file add  constraint try_pk primary key  (try01,try02) enable validate;
grant select on try_file to tiptopgp;
grant update on try_file to tiptopgp;
grant delete on try_file to tiptopgp;
grant insert on try_file to tiptopgp;
grant index on try_file to public;
grant select on try_file to ods;
