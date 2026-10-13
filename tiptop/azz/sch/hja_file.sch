/*
================================================================================
檔案代號:hja_file
檔案名稱:Fourjs License使用数量记录表
檔案目的:Fourjs License使用数量记录表
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table hja_file
(
hja01       number(5) NOT NULL,
hja02       date NOT NULL,
hja03       number(5),
hja04       number(5),
hja05       number(5),
hja06       number(5),
hja07       number(5),
hja08       number(5),
hja09       number(5),
hja10       number(5),
hja11       number(5),
hja12       number(5),
hja13       number(5),
hja14       number(5),
hja15       number(5),
hja16       number(5),
hja17       number(5),
hja18       number(5),
hja19       varchar2(255),
hja20       number(5),
hja21       number(5),
hja22       number(5),
hja23       number(5)
);

alter table hja_file add  constraint hja_pk primary key  (hja01) enable validate;
grant select on hja_file to tiptopgp;
grant update on hja_file to tiptopgp;
grant delete on hja_file to tiptopgp;
grant insert on hja_file to tiptopgp;
grant index on hja_file to public;
grant select on hja_file to ods;
