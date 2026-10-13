/*
================================================================================
檔案代號:hrbhb_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbhb_file
(
hrbhb01     number(5) NOT NULL,      /*项次                                   */
hrbhb02     varchar2(50) NOT NULL,   /*员工ID                                 */
hrbhb03     varchar2(50),            /*面谈人员                               */
hrbhb04     date,                    /*面谈日期                               */
hrbhb05     varchar2(255),           /*面谈记录                               */
hrbhb06     varchar2(1),             /*建议回聘否                             */
hrbhb07     varchar2(255),           /*员工建议                               */
hrbhb08     varchar2(255)            /*简短理由                               */
);

alter table hrbhb_file add  constraint tpc_hrbhb_pk primary key  (hrbhb01) enable validate;
grant select on hrbhb_file to tiptopgp;
grant update on hrbhb_file to tiptopgp;
grant delete on hrbhb_file to tiptopgp;
grant insert on hrbhb_file to tiptopgp;
grant index on hrbhb_file to public;
grant select on hrbhb_file to ods;
