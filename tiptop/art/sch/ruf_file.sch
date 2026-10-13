/*
================================================================================
檔案代號:ruf_file
檔案名稱:铺货单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ruf_file
(
ruf01       varchar2(20) DEFAULT ' ' NOT NULL, /*补货单号*/
ruf02       date,                    /*单据日期                               */
ruf03       varchar2(255),           /*补货原因                               */
rufacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
rufcond     date,                    /*审核日期                               */
rufconf     varchar2(1),             /*确认码                                 */
rufcont     varchar2(8),             /*审核时间                               */
rufconu     varchar2(10),            /*审核人员                               */
rufcrat     date,                    /*资料创建日                             */
rufdate     date,                    /*最近更改日                             */
rufgrup     varchar2(10),            /*资料所有部门                           */
ruflegal    varchar2(10) NOT NULL,   /*法人别                                 */
rufmodu     varchar2(10),            /*资料更改者                             */
rufplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rufuser     varchar2(10),            /*资料所有者                             */
ruforiu     varchar2(10),            /*资料建立者                             */
ruforig     varchar2(10)             /*资料建立部门                           */
);

alter table ruf_file add  constraint ruf_pk primary key  (ruf01) enable validate;
grant select on ruf_file to tiptopgp;
grant update on ruf_file to tiptopgp;
grant delete on ruf_file to tiptopgp;
grant insert on ruf_file to tiptopgp;
grant index on ruf_file to public;
grant select on ruf_file to ods;
