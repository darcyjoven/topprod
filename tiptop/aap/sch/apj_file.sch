/*
================================================================================
檔案代號:apj_file
檔案名稱:应付账款系统凭证分录额外摘要档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table apj_file
(
apj01       varchar2(20) NOT NULL,   /*帐款/付款/开状/赎单单号                */
apj011      number(5) NOT NULL,      /*分录开立部门                           */
                                     /*分錄開立部門 (1.會計 2.財務)           */
apj012      number(5) NOT NULL,      /*开状更改项次                           */
                                     /*開狀修改項次 (0 表開狀 1 以上表修改)   */
apj02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
apj03       number(5) NOT NULL,      /*行序                                   */
apj04       varchar2(255),           /*额外摘要                               */
                                     /*額外摘要                               */
apjlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table apj_file add  constraint apj_pk primary key  (apj01,apj011,apj012,apj02,apj03) enable validate;
grant select on apj_file to tiptopgp;
grant update on apj_file to tiptopgp;
grant delete on apj_file to tiptopgp;
grant insert on apj_file to tiptopgp;
grant index on apj_file to public;
grant select on apj_file to ods;
