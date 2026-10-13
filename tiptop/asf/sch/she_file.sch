/*
================================================================================
檔案代號:she_file
檔案名稱:工单序号档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table she_file
(
she01       varchar2(20) NOT NULL,   /*工单编号                               */
                                     /*工單編號                               */
she02       varchar2(15) NOT NULL,   /*序号                                   */
                                     /*序號                                   */
sheplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
shelegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table she_file add  constraint she_pk primary key  (she01,she02) enable validate;
grant select on she_file to tiptopgp;
grant update on she_file to tiptopgp;
grant delete on she_file to tiptopgp;
grant insert on she_file to tiptopgp;
grant index on she_file to public;
grant select on she_file to ods;
