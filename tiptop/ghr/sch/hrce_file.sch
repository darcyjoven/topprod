/*
================================================================================
檔案代號:hrce_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrce_file
(
hrce01      number(15) NOT NULL,
hrce02      varchar2(20) NOT NULL,
hrce03      date NOT NULL,
hrce04      varchar2(5),
hrce05      date NOT NULL,
hrce06      varchar2(5),
hrce07      number(5,2) NOT NULL,
hrce08      varchar2(20) NOT NULL,
hrce09      number(15,2),
hrce10      varchar2(20) NOT NULL,
hrce11      varchar2(255),
hrce12      number(15,2),
hrce13      varchar2(255),
hrceconf    varchar2(1),
hrceacti    varchar2(1) NOT NULL,
hrceud01    varchar2(255),
hrceud02    varchar2(40),
hrceud03    varchar2(40),
hrceud04    varchar2(40),
hrceud05    varchar2(40),
hrceud06    varchar2(40),
hrceud07    number(15,3),
hrceud08    number(15,3),
hrceud09    number(15,3),
hrceud10    number(10),
hrceud11    number(10),
hrceud12    number(10),
hrceud13    date,
hrceud14    date,
hrceud15    date,
hrceuser    varchar2(10),
hrcegrup    varchar2(10),
hrcemodu    varchar2(10),
hrcedate    date,
hrceorig    varchar2(10),
hrceoriu    varchar2(10)
);

alter table hrce_file add  constraint tpc_hrce_pk primary key  (hrce01) enable validate;
grant select on hrce_file to tiptopgp;
grant update on hrce_file to tiptopgp;
grant delete on hrce_file to tiptopgp;
grant insert on hrce_file to tiptopgp;
grant index on hrce_file to public;
grant select on hrce_file to ods;
