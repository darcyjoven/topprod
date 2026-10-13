/*
================================================================================
檔案代號:shj_file
檔案名稱:生产日报表工单转出维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table shj_file
(
shj01       varchar2(20) NOT NULL,   /*移转单号                               */
shj02       varchar2(20),            /*退料单号                               */
shj03       varchar2(20),            /*发料单号                               */
shj04       varchar2(10),            /*一般仓库                               */
shj05       varchar2(10),            /*库位                                   */
shj06       varchar2(24),            /*批号                                   */
shj07       varchar2(10),            /*wip仓库                                */
shj08       varchar2(10),            /*库位                                   */
shj09       varchar2(24),            /*批号                                   */
shj10       number(5) NOT NULL,      /*项次                                   */
shj11       varchar2(20),            /*转入工单                               */
shj12       number(15,3),            /*转入数量                               */
shj13       date,                    /*单据日期                               */
shjconf     varchar2(1),             /*确认码                                 */
shjplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
shjlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table shj_file add  constraint shj_pk primary key  (shj01,shj10) enable validate;
grant select on shj_file to tiptopgp;
grant update on shj_file to tiptopgp;
grant delete on shj_file to tiptopgp;
grant insert on shj_file to tiptopgp;
grant index on shj_file to public;
grant select on shj_file to ods;
