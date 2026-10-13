/*
================================================================================
檔案代號:vie_file
檔案名稱:视图基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table vie_file
(
vie01       varchar2(20) NOT NULL,   /*视图名称                               */
vie02       varchar2(40),            /*查询id                                 */
vie03       varchar2(1500),          /*查询语句                               */
vie04       varchar2(1500),          /*别名                                   */
vie05       varchar2(1) DEFAULT '0' NOT NULL, /*当前库or所有库*/
vie06       varchar2(40),            /*库名                                   */
vie07       varchar2(1) DEFAULT 'y' NOT NULL, /*是否替换*/
vie08       varchar2(1) DEFAULT 'n' NOT NULL, /*是否建立*/
vie09       varchar2(1) DEFAULT 'n' NOT NULL, /*是否同步*/
vieacti     varchar2(1) DEFAULT 'y' NOT NULL, /*有效否*/
viedate     date,                    /*最近更改日期                           */
viegrup     varchar2(20),            /*所属群组                               */
viemodu     varchar2(20),            /*最近更改人                             */
vieuser     varchar2(20),            /*资料所有者                             */
vieoriu     varchar2(10),            /*资料建立者                             */
vieorig     varchar2(10)             /*资料建立部门                           */
);

alter table vie_file add  constraint vie_pk primary key  (vie01) enable validate;
grant select on vie_file to tiptopgp;
grant update on vie_file to tiptopgp;
grant delete on vie_file to tiptopgp;
grant insert on vie_file to tiptopgp;
grant index on vie_file to public;
grant select on vie_file to ods;
