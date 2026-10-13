/*
================================================================================
檔案代號:smb_file
檔案名稱:行业别资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table smb_file
(
smb01       varchar2(5) NOT NULL,    /*收件者名称                             */
smb02       varchar2(1) NOT NULL,    /*E-MAIL ADDRESS                         */
smb03       varchar2(80),            /*行业名称                               */
smb04       varchar2(5) DEFAULT ' ', /*no use                                 */
smb05       varchar2(1) DEFAULT ' '  /*no use                                 */
);

alter table smb_file add  constraint smb_pk primary key  (smb01,smb02) enable validate;
grant select on smb_file to tiptopgp;
grant update on smb_file to tiptopgp;
grant delete on smb_file to tiptopgp;
grant insert on smb_file to tiptopgp;
grant index on smb_file to public;
grant select on smb_file to ods;
