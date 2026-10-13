/*
================================================================================
檔案代號:rym_file
檔案名稱:采购类型变更资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rym_file
(
rym01       varchar2(20) DEFAULT ' ' NOT NULL, /*采购类型变更单单号*/
rym02       date,                    /*单据日期                               */
rym03       varchar2(255),           /*备注                                   */
rymcond     date,                    /*审核日期                               */
rymconf     varchar2(1),             /*确认码                                 */
                                     /*Revision Release Code Y-Confirm N-Un_confirm*/
rymconu     varchar2(10),            /*审核人员                               */
rymcrat     date,                    /*资料创建日                             */
rymdate     date,                    /*最近更改日                             */
rymgrup     varchar2(10),            /*资料所有部门                           */
rymlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rymmodu     varchar2(10),            /*资料更改者                             */
rymplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rymuser     varchar2(10),            /*资料所有者                             */
rymoriu     varchar2(10),            /*资料建立者                             */
rymorig     varchar2(10),            /*资料建立部门                           */
rym900      varchar2(1) DEFAULT ' ' NOT NULL /*状况码*/
);

alter table rym_file add  constraint rym_pk primary key  (rym01) enable validate;
grant select on rym_file to tiptopgp;
grant update on rym_file to tiptopgp;
grant delete on rym_file to tiptopgp;
grant insert on rym_file to tiptopgp;
grant index on rym_file to public;
grant select on rym_file to ods;
