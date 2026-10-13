/*
================================================================================
檔案代號:smz_file
檔案名稱:单别限定仓库库位明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table smz_file
(
smz01       varchar2(5) NOT NULL,    /*单    别                               */
                                     /*單    別                               */
smz02       varchar2(10) NOT NULL,   /*设限仓库                               */
                                     /*設限倉庫                               */
smz021      varchar2(10),            /*设限仓库                               */
smz03       varchar2(10) NOT NULL,   /*设限库位                               */
                                     /*設限儲位                               */
smz031      varchar2(10)             /*设限库位                               */
);

alter table smz_file add  constraint smz_pk primary key  (smz01,smz02,smz03) enable validate;
grant select on smz_file to tiptopgp;
grant update on smz_file to tiptopgp;
grant delete on smz_file to tiptopgp;
grant insert on smz_file to tiptopgp;
grant index on smz_file to public;
grant select on smz_file to ods;
