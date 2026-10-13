/*
================================================================================
檔案代號:omg_file
檔案名稱:开票档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table omg_file
(
omg00       varchar2(20) DEFAULT ' ' NOT NULL, /*单别*/
omg01       varchar2(20) DEFAULT ' ',
omg02       varchar2(20) DEFAULT ' ',
omg03       date,
omg04       varchar2(10),
omg041      varchar2(40),
omg05       varchar2(4),
omg051      number(9,4),
omg06       varchar2(4),
omg07       number(20,10),
omg08       varchar2(1) DEFAULT ' ' NOT NULL,
omg09       number(5) DEFAULT '0' NOT NULL,
omg10       varchar2(1) DEFAULT ' ' NOT NULL,
omg11       varchar2(20),
omg12       varchar2(20) DEFAULT ' ' NOT NULL,
omg13       number(5) DEFAULT '0' NOT NULL,
omg14       varchar2(40),
omg15       varchar2(120),
omg16       varchar2(120),
omg17       number(15,3) DEFAULT '0' NOT NULL,
omg18       varchar2(4),
omg19       number(20,6) DEFAULT '0' NOT NULL,
omg20       number(20,6) DEFAULT '0' NOT NULL,
omg20t      number(20,6) DEFAULT '0' NOT NULL,
omg20x      number(20,6) DEFAULT '0' NOT NULL,
omg21       number(20,6) DEFAULT '0' NOT NULL,
omg22       number(20,6) DEFAULT '0' NOT NULL,
omg22t      number(20,6) DEFAULT '0' NOT NULL,
omg22x      number(20,6) DEFAULT '0' NOT NULL,
omg23       number(5) DEFAULT '0' NOT NULL,
omgdate     date,
omggrup     varchar2(10),
omgmodu     varchar2(10),
omgorig     varchar2(10),
omgoriu     varchar2(10),
omguser     varchar2(10)
);

alter table omg_file add  constraint omg_pk primary key  (omg00,omg09) enable validate;
grant select on omg_file to tiptopgp;
grant update on omg_file to tiptopgp;
grant delete on omg_file to tiptopgp;
grant insert on omg_file to tiptopgp;
grant index on omg_file to public;
grant select on omg_file to ods;
