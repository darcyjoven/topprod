/*
================================================================================
檔案代號:hrcy_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcy_file
(
hrcy01      varchar2(20) NOT NULL,
hrcy02      varchar2(50),
hrcy03      date,
hrcy04      date,
hrcy05      varchar2(20),
hrcy06      varchar2(1),
hrcy07      varchar2(255),
hrcyacti    varchar2(1),
hrcyud01    varchar2(255),
hrcyud02    varchar2(40),
hrcyud03    varchar2(40),
hrcyud04    varchar2(40),
hrcyud05    varchar2(40),
hrcyud06    varchar2(40),
hrcyud07    number(15,3),
hrcyud08    number(15,3),
hrcyud09    number(15,3),
hrcyud10    number(10),
hrcyud11    number(10),
hrcyud12    number(10),
hrcyud13    date,
hrcyud14    date,
hrcyud15    date,
hrcyuser    varchar2(10),
hrcygrup    varchar2(10),
hrcymodu    varchar2(10),
hrcydate    date,
hrcyoriu    varchar2(10),
hrcyorig    varchar2(10)
);

create unique index hrcy_01 on hrcy_file (hrcy01);
alter table hrcy_file add  constraint tpc_hrcy_pk primary key  (hrcy01) enable validate;
grant select on hrcy_file to tiptopgp;
grant update on hrcy_file to tiptopgp;
grant delete on hrcy_file to tiptopgp;
grant insert on hrcy_file to tiptopgp;
grant index on hrcy_file to public;
grant select on hrcy_file to ods;
