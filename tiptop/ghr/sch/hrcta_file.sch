/*
================================================================================
檔案代號:hrcta_file
檔案名稱:发薪表
檔案目的:
上游檔案:hrct_file
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcta_file
(
hrcta01     varchar2(20) NOT NULL,   /*薪资年度                               */
hrcta02     varchar2(20) NOT NULL,   /*薪资期间                               */
hrcta03     varchar2(20) NOT NULL,   /*所属公司                               */
hrcta04     number(5) NOT NULL,      /*发薪次数                               */
hrcta05     varchar2(1),             /*是否参加区间检查                       */
hrcta06     date,                    /*开始日期                               */
hrcta07     date,                    /*结束日期                               */
hrcta08     varchar2(255)            /*备注                                   */
);

alter table hrcta_file add  constraint tpc_hrcta_pk primary key  (hrcta01,hrcta02,hrcta03,hrcta04) enable validate;
grant select on hrcta_file to tiptopgp;
grant update on hrcta_file to tiptopgp;
grant delete on hrcta_file to tiptopgp;
grant insert on hrcta_file to tiptopgp;
grant index on hrcta_file to public;
grant select on hrcta_file to ods;
