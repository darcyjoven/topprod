/*
================================================================================
檔案代號:toq_file
檔案名稱:县级市编号维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table toq_file
(
toq01       varchar2(10) NOT NULL,   /*县级市编号                             */
toq02       varchar2(80),            /*县级市名称                             */
toq03       varchar2(10),            /*地级市编号                             */
toqacti     varchar2(1)              /*有效否                                 */
);

alter table toq_file add  constraint toq_pk primary key  (toq01) enable validate;
grant select on toq_file to tiptopgp;
grant update on toq_file to tiptopgp;
grant delete on toq_file to tiptopgp;
grant insert on toq_file to tiptopgp;
grant index on toq_file to public;
grant select on toq_file to ods;
