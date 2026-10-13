/*
================================================================================
檔案代號:vzx_file
檔案名稱:aps cp手调器排程控制档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vzx_file
(
vzx00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
vzx01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
vzx02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
vzx03       number(1) DEFAULT '0' NOT NULL, /*是否可排程*/
vzx04       date DEFAULT sysdate NOT NULL /*更改日期*/
);

alter table vzx_file add  constraint vzx_pk primary key  (vzx00,vzx01,vzx02,vzx03,vzx04) enable validate;
grant select on vzx_file to tiptopgp;
grant update on vzx_file to tiptopgp;
grant delete on vzx_file to tiptopgp;
grant insert on vzx_file to tiptopgp;
grant index on vzx_file to public;
grant select on vzx_file to ods;
