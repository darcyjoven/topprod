/*
================================================================================
檔案代號:ibf_file
檔案名稱:交接单单头档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ibf_file
(
ibf01       varchar2(20) DEFAULT ' ' NOT NULL,
ibf02       varchar2(1) DEFAULT ' ' NOT NULL,
ibf03       varchar2(10),
ibf04       date,
ibf05       varchar2(20),
ibf06       varchar2(20),
ibf07       varchar2(40),
ibf08       number(10),
ibfacti     varchar2(1) DEFAULT ' ' NOT NULL,
ibfdate     date,
ibfgrup     varchar2(10),
ibflegal    varchar2(10) DEFAULT ' ' NOT NULL,
ibfmodu     varchar2(10),
ibforig     varchar2(10),
ibforiu     varchar2(10),
ibfplant    varchar2(10) DEFAULT ' ' NOT NULL,
ibfud01     varchar2(255),
ibfud02     varchar2(40),
ibfud03     varchar2(40),
ibfud04     varchar2(40),
ibfud05     varchar2(40),
ibfud06     varchar2(40),
ibfud07     number(15,3),
ibfud08     number(15,3),
ibfud09     number(15,3),
ibfud10     number(10),
ibfud11     number(10),
ibfud12     number(10),
ibfud13     date,
ibfud14     date,
ibfud15     date,
ibfuser     varchar2(10)
);

alter table ibf_file add  constraint ibf_pk primary key  (ibf01) enable validate;
grant select on ibf_file to tiptopgp;
grant update on ibf_file to tiptopgp;
grant delete on ibf_file to tiptopgp;
grant insert on ibf_file to tiptopgp;
grant index on ibf_file to public;
grant select on ibf_file to ods;
