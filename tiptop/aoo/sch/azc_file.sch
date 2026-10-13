/*
================================================================================
檔案代號:azc_file
檔案名稱:签核等级档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table azc_file
(
azc01       varchar2(4) NOT NULL,    /*签核等级                               */
                                     /*簽核等級                               */
azc02       number(5) NOT NULL,      /*顺序                                   */
                                     /*順序                                   */
azc03       varchar2(10),            /*人员代码                               */
                                     /*人員代碼                               */
azc04       varchar2(255)            /*备注                                   */
                                     /*備註                                   */
);

alter table azc_file add  constraint azc_pk primary key  (azc01,azc02) enable validate;
grant select on azc_file to tiptopgp;
grant update on azc_file to tiptopgp;
grant delete on azc_file to tiptopgp;
grant insert on azc_file to tiptopgp;
grant index on azc_file to public;
grant select on azc_file to ods;
