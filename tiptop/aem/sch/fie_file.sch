/*
================================================================================
檔案代號:fie_file
檔案名稱:作业资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fie_file
(
fie01       varchar2(10) NOT NULL,   /*作业编号                               */
fie02       number(5) NOT NULL,      /*步骤                                   */
fie03       varchar2(80)             /*内容                                   */
);

alter table fie_file add  constraint fie_pk primary key  (fie01,fie02) enable validate;
grant select on fie_file to tiptopgp;
grant update on fie_file to tiptopgp;
grant delete on fie_file to tiptopgp;
grant insert on fie_file to tiptopgp;
grant index on fie_file to public;
grant select on fie_file to ods;
