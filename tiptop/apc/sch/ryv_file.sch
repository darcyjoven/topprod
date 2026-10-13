/*
================================================================================
檔案代號:ryv_file
檔案名稱:公告资料主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ryv_file
(
ryv01       varchar2(20) DEFAULT ' ' NOT NULL, /*公告单号*/
ryv02       varchar2(1) DEFAULT ' ' NOT NULL, /*公告类型1-门店发表公告2-总部*/
ryv03       date,                    /*公告日期                               */
ryv04       varchar2(4000),          /*公告内容                               */
ryv05       varchar2(10),            /*发布营运中心                           */
ryvacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
ryvcond     date,                    /*审核日期                               */
ryvconf     varchar2(1) DEFAULT 'N' NOT NULL, /*审核码Y-已审核N-未确认X-已作 */
ryvcont     varchar2(8),             /*审核时间                               */
ryvconu     varchar2(10),            /*审核人员                               */
ryvcrat     date,                    /*资料创建日                             */
ryvdate     date,                    /*资料更改日                             */
ryvgrup     varchar2(10),            /*资料所有部门                           */
ryvmodu     varchar2(10),            /*资料更改者                             */
ryvorig     varchar2(10),            /*资料建立部门                           */
ryvoriu     varchar2(10),            /*资料建立者                             */
ryvpos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否Y-已传N-未传*/
ryvuser     varchar2(10)             /*资料所有者                             */
);

alter table ryv_file add  constraint ryv_pk primary key  (ryv01) enable validate;
grant select on ryv_file to tiptopgp;
grant update on ryv_file to tiptopgp;
grant delete on ryv_file to tiptopgp;
grant insert on ryv_file to tiptopgp;
grant index on ryv_file to public;
grant select on ryv_file to ods;
