/*
================================================================================
檔案代號:mea_file
檔案名稱:BOM 替代料资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table mea_file
(
mea01       number(5) NOT NULL,      /*流用编号                               */
mea02       varchar2(40) NOT NULL,   /*料件编号                               */
mea03       date,                    /*生效日期范围                           */
mea04       date,                    /*失效日期范围                           */
mea05       varchar2(30),            /*核准文号范围                           */
mea06       date                     /*核准日期范围                           */
);

create unique index mea_02 on mea_file (mea02);
alter table mea_file add  constraint mea_pk primary key  (mea01,mea02) enable validate;
grant select on mea_file to tiptopgp;
grant update on mea_file to tiptopgp;
grant delete on mea_file to tiptopgp;
grant insert on mea_file to tiptopgp;
grant index on mea_file to public;
grant select on mea_file to ods;
