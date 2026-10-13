/*
================================================================================
檔案代號:hrcl_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcl_file
(
hrcl01      number(15) NOT NULL,
hrcl02      varchar2(20),
hrcl03      varchar2(20),
hrcl04      varchar2(20),
hrcl05      varchar2(1) NOT NULL,
hrcl06      varchar2(1) NOT NULL,
hrcl07      number(5),
hrcl08      varchar2(1) NOT NULL,
hrcl09      number(5),
hrcl10      varchar2(1) NOT NULL,
hrcl11      number(5) NOT NULL,
hrcl12      varchar2(1) NOT NULL,
hrcl13      number(5),
hrcl14      varchar2(1) NOT NULL,
hrcl15      varchar2(1) NOT NULL,
hrcl16      number(5),
hrcl17      varchar2(1) NOT NULL,
hrcl18      number(5),
hrcl19      number(5),
hrcl20      number(5),
hrcl21      varchar2(1) NOT NULL,
hrcl22      varchar2(1) NOT NULL,
hrcl23      varchar2(1) NOT NULL,
hrcl24      varchar2(1) NOT NULL,
hrcl25      varchar2(1) NOT NULL,
hrcl26      varchar2(255),
hrcl27      varchar2(1) NOT NULL,
hrclud01    varchar2(255),
hrclud02    varchar2(40),
hrclud03    varchar2(40),
hrclud04    varchar2(40),
hrclud05    varchar2(40),
hrclud06    varchar2(40),
hrclud07    number(15,3),
hrclud08    number(15,3),
hrclud09    number(15,3),
hrclud10    number(10),
hrclud11    number(10),
hrclud12    number(10),
hrclud13    date,
hrclud14    date,
hrclud15    date,
hrcluser    varchar2(10),
hrclgrup    varchar2(10),
hrclmodu    varchar2(10),
hrcldate    date,
hrclorig    varchar2(10),
hrcloriu    varchar2(10)
);

alter table hrcl_file add  constraint tpc_hrcl_pk primary key  (hrcl01) enable validate;
grant select on hrcl_file to tiptopgp;
grant update on hrcl_file to tiptopgp;
grant delete on hrcl_file to tiptopgp;
grant insert on hrcl_file to tiptopgp;
grant index on hrcl_file to public;
grant select on hrcl_file to ods;
