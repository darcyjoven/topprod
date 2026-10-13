/*
================================================================================
檔案代號:ta_ccu_file
檔案名稱:每月料件替代配置表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ta_ccu_file
(
ta_ccu01    number(5) NOT NULL,      /*年度                                   */
ta_ccu02    number(5) NOT NULL,      /*期别                                   */
ta_ccu03    varchar2(40) NOT NULL,   /*原料号                                 */
ta_ccu04    varchar2(40)             /*替代料号                               */
);

alter table ta_ccu_file add  constraint tpa_ccu_pk primary key  (ta_ccu01,ta_ccu02,ta_ccu03) enable validate;
grant select on ta_ccu_file to tiptopgp;
grant update on ta_ccu_file to tiptopgp;
grant delete on ta_ccu_file to tiptopgp;
grant insert on ta_ccu_file to tiptopgp;
grant index on ta_ccu_file to public;
grant select on ta_ccu_file to ods;
