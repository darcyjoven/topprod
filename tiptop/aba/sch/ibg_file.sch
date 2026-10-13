/*
================================================================================
檔案代號:ibg_file
檔案名稱:交接单单身档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ibg_file
(
ibg01       varchar2(20) DEFAULT ' ' NOT NULL,
ibg02       number(5) DEFAULT '0' NOT NULL,
ibg03       varchar2(10),
ibg04       varchar2(80),
ibg05       number(15,3) DEFAULT '0' NOT NULL,
ibglegal    varchar2(10) DEFAULT ' ' NOT NULL,
ibgplant    varchar2(10) DEFAULT ' ' NOT NULL,
ibgud01     varchar2(255),
ibgud02     varchar2(40),
ibgud03     varchar2(40),
ibgud04     varchar2(40),
ibgud05     varchar2(40),
ibgud06     varchar2(40),
ibgud07     number(15,3),
ibgud08     number(15,3),
ibgud09     number(15,3),
ibgud10     number(10),
ibgud11     number(10),
ibgud12     number(10),
ibgud13     date,
ibgud14     date,
ibgud15     date
);

alter table ibg_file add  constraint ibg_pk primary key  (ibg01,ibg02) enable validate;
grant select on ibg_file to tiptopgp;
grant update on ibg_file to tiptopgp;
grant delete on ibg_file to tiptopgp;
grant insert on ibg_file to tiptopgp;
grant index on ibg_file to public;
grant select on ibg_file to ods;
