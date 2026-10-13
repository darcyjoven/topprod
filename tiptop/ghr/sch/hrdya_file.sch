/*
================================================================================
檔案代號:hrdya_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdya_file
(
hrdya01     varchar2(20) NOT NULL,   /*员工ID                                 */
hrdya02     varchar2(20) NOT NULL,   /*所属财年                               */
hrdya03     number(5) NOT NULL,      /*项次                                   */
hrdya04     varchar2(100),           /*发放薪资月                             */
hrdya05     number(15,2),            /*本次发放金额                           */
hrdya06     varchar2(255)            /* 备注                                  */
);

alter table hrdya_file add  constraint tpc_hrdya_pk primary key  (hrdya01,hrdya02,hrdya03) enable validate;
grant select on hrdya_file to tiptopgp;
grant update on hrdya_file to tiptopgp;
grant delete on hrdya_file to tiptopgp;
grant insert on hrdya_file to tiptopgp;
grant index on hrdya_file to public;
grant select on hrdya_file to ods;
