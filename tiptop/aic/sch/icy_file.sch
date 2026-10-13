/*
================================================================================
檔案代號:icy_file
檔案名稱:ICD出通单库存指定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table icy_file
(
icy01       varchar2(20) DEFAULT ' ' NOT NULL, /*出货通知单号*/
icy02       number(5) DEFAULT '0' NOT NULL, /*项次*/
icy03       number(5) DEFAULT '0' NOT NULL, /*序号*/
icy04       varchar2(1),             /*勾选                                   */
icy05       varchar2(40),            /*料号                                   */
icy06       varchar2(10),            /*仓库                                   */
icy07       varchar2(10),            /*库位                                   */
icy08       varchar2(24),            /*批号                                   */
icy09       varchar2(20),            /*Tape Reel                              */
icy10       number(15,3),            /*库存量                                 */
icy11       number(15,3),            /*待出货量                               */
icy12       number(15,3),            /*出货量                                 */
icy13       number(5),               /*暂存出通项次                           */
icy14       varchar2(1),             /*nouse                                  */
icyplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
icylegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table icy_file add  constraint icy_pk primary key  (icy01,icy02,icy03) enable validate;
grant select on icy_file to tiptopgp;
grant update on icy_file to tiptopgp;
grant delete on icy_file to tiptopgp;
grant insert on icy_file to tiptopgp;
grant index on icy_file to public;
grant select on icy_file to ods;
