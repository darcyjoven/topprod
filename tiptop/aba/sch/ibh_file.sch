/*
================================================================================
檔案代號:ibh_file
檔案名稱:包装关系单头档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ibh_file
(
ibh01       varchar2(80) DEFAULT ' ' NOT NULL,
ibh02       varchar2(1) DEFAULT ' ' NOT NULL,
ibhacti     varchar2(1) DEFAULT ' ' NOT NULL,
ibhdate     date,
ibhgrup     varchar2(10),
ibhmodu     varchar2(10),
ibhorig     varchar2(10),
ibhoriu     varchar2(10),
ibhud01     varchar2(255),
ibhud02     varchar2(40),
ibhud03     varchar2(40),
ibhud04     varchar2(40),
ibhud05     varchar2(40),
ibhud06     varchar2(40),
ibhud07     number(15,3),
ibhud08     number(15,3),
ibhud09     number(15,3),
ibhud10     number(10),
ibhud11     number(10),
ibhud12     number(10),
ibhud13     date,
ibhud14     date,
ibhud15     date,
ibhuser     varchar2(10)
);

alter table ibh_file add  constraint ibh_pk primary key  (ibh01) enable validate;
grant select on ibh_file to tiptopgp;
grant update on ibh_file to tiptopgp;
grant delete on ibh_file to tiptopgp;
grant insert on ibh_file to tiptopgp;
grant index on ibh_file to public;
grant select on ibh_file to ods;
