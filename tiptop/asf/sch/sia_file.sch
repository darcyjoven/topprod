/*
================================================================================
檔案代號:sia_file
檔案名稱:工单备置单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sia_file
(
sia01       varchar2(20) DEFAULT ' ' NOT NULL, /*備置單號*/
sia02       date DEFAULT sysdate NOT NULL, /*录入日期*/
sia03       date,                    /*审核日期                               */
sia04       varchar2(1) DEFAULT ' ' NOT NULL,
sia05       varchar2(1) DEFAULT ' ' NOT NULL, /*備置方式*/
sia06       varchar2(10),            /*部门编号                               */
sia07       varchar2(24),
sia08       varchar2(255),           /*备注                                   */
sia09       varchar2(20),            /*来源单号                               */
siaacti     varchar2(1) DEFAULT ' ' NOT NULL, /*有效否(y/n)*/
siaconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核码*/
siadate     date,                    /*最近更改日期                           */
siagrup     varchar2(10),            /*资料建立者部门                         */
sialegal    varchar2(10) NOT NULL,   /*所属法人                               */
siamodu     varchar2(10),            /*最近更改者                             */
siaorig     varchar2(10),            /*资料建立部门                           */
siaoriu     varchar2(10),            /*资料建立者                             */
siaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
siauser     varchar2(10)             /*资料所有者                             */
);

alter table sia_file add  constraint sia_pk primary key  (sia01) enable validate;
grant select on sia_file to tiptopgp;
grant update on sia_file to tiptopgp;
grant delete on sia_file to tiptopgp;
grant insert on sia_file to tiptopgp;
grant index on sia_file to public;
grant select on sia_file to ods;
