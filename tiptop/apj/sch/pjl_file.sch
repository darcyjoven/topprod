/*
================================================================================
檔案代號:pjl_file
檔案名稱:网络活动关系基本资料设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjl_file
(
pjl01       varchar2(10) NOT NULL,   /*网络代号                               */
pjl02       varchar2(4) NOT NULL,    /*前活动代号                             */
pjl03       varchar2(4) NOT NULL,    /*活动编号                               */
pjl04       varchar2(1),             /*关系类型                               */
pjl05       number(15,3),            /*松弛时间                               */
pjldate     date,                    /*最近更改日期                           */
pjlgrup     varchar2(10),            /*资料所有部门                           */
pjlmodu     varchar2(10),            /*资料更改者                             */
pjluser     varchar2(10),            /*资料所有者                             */
pjlorig     varchar2(10),            /*资料建立部门                           */
pjloriu     varchar2(10)             /*资料建立者                             */
);

alter table pjl_file add  constraint pjl_pk primary key  (pjl01,pjl02,pjl03) enable validate;
grant select on pjl_file to tiptopgp;
grant update on pjl_file to tiptopgp;
grant delete on pjl_file to tiptopgp;
grant insert on pjl_file to tiptopgp;
grant index on pjl_file to public;
grant select on pjl_file to ods;
