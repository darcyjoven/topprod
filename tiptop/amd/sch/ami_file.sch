/*
================================================================================
檔案代號:ami_file
檔案名稱:促销条码设定单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ami_file
(
ami01       varchar2(10) DEFAULT ' ' NOT NULL, /*客户编号*/
ami02       date DEFAULT sysdate NOT NULL, /*生效日期*/
ami03       date DEFAULT sysdate,    /*失效日期                               */
ami04       varchar2(40) DEFAULT ' ' NOT NULL, /*促销条码*/
ami05       varchar2(255),           /*备注                                   */
amiacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
amidate     date,                    /*最近更改日期                           */
amigrup     varchar2(10),            /*用户部门                               */
amimodu     varchar2(10),            /*最后资料更改者                         */
amiorig     varchar2(10),            /*资料建立部门                           */
amioriu     varchar2(10),            /*资料建立者                             */
amiuser     varchar2(10)             /*原始资料建立者                         */
);

alter table ami_file add  constraint ami_pk primary key  (ami01,ami02,ami04) enable validate;
grant select on ami_file to tiptopgp;
grant update on ami_file to tiptopgp;
grant delete on ami_file to tiptopgp;
grant insert on ami_file to tiptopgp;
grant index on ami_file to public;
grant select on ami_file to ods;
