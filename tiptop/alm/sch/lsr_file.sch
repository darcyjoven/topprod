/*
================================================================================
檔案代號:lsr_file
檔案名稱:积分换券设定单身二档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lsr_file
(
lsr01       varchar2(20) DEFAULT ' ' NOT NULL, /*方案编号*/
lsr02       varchar2(20) DEFAULT ' ' NOT NULL, /*券种编号*/
lsrlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lsrplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lsr03       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
lsr00       varchar2(1) DEFAULT ' ' NOT NULL, /*兑换来源*/
                                     /*0.积分换券, 1.累计消费额换券           */
lsr04       varchar2(20) DEFAULT ' ' NOT NULL /*卡种代号*/
);

alter table lsr_file add  constraint lsr_pk primary key  (lsr00,lsr01,lsr02,lsr03,lsr04,lsrplant) enable validate;
grant select on lsr_file to tiptopgp;
grant update on lsr_file to tiptopgp;
grant delete on lsr_file to tiptopgp;
grant insert on lsr_file to tiptopgp;
grant index on lsr_file to public;
grant select on lsr_file to ods;
