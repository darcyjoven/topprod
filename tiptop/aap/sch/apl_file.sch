/*
================================================================================
檔案代號:apl_file
檔案名稱:杂项厂商全名地址档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table apl_file
(
apl01       varchar2(20) NOT NULL,   /*杂项厂商 (MISC) 营利事业税号           */
                                     /*雜項廠商 (MISC) 營利事業統一編號       */
                                     /*         (apl01 = apa21)               */
apl02       varchar2(80),            /*帐款对象全名一                         */
                                     /*帳款對象全名一  char(40)-> char(36)    */
apl021      varchar2(80),            /*帐款对象全名二                         */
                                     /*帳款對象全名二  add  01/12/27          */
apl03       varchar2(255)            /*帐款对象地址                           */
                                     /*帳款對象地址                           */
);

alter table apl_file add  constraint apl_pk primary key  (apl01) enable validate;
grant select on apl_file to tiptopgp;
grant update on apl_file to tiptopgp;
grant delete on apl_file to tiptopgp;
grant insert on apl_file to tiptopgp;
grant index on apl_file to public;
grant select on apl_file to ods;
