/*
================================================================================
檔案代號:hrbca_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbca_file
(
hrbca00     varchar2(20) NOT NULL,   /*流水号                                 */
hrbca01     number(5) NOT NULL,      /*项次                                   */
hrbca02     date,                    /*年审日期                               */
hrbca03     varchar2(20),            /*年审结果                               */
hrbca04     varchar2(50),            /*备注                                   */
hrbcaacti   varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrbcauser   varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrbcagrup   varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrbcamodu   varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrbcadate   date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrbcaoriu   varchar2(10),            /*资料建立者                             */
hrbcaorig   varchar2(10)             /*资料建立部门                           */
);

alter table hrbca_file add  constraint tpc_hrbca_pk primary key  (hrbca00,hrbca01) enable validate;
grant select on hrbca_file to tiptopgp;
grant update on hrbca_file to tiptopgp;
grant delete on hrbca_file to tiptopgp;
grant insert on hrbca_file to tiptopgp;
grant index on hrbca_file to public;
grant select on hrbca_file to ods;
