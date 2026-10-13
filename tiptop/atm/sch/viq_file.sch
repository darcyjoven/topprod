/*
================================================================================
檔案代號:viq_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table viq_file
(
viq01       varchar2(20) NOT NULL,   /*VIP卡号                                */
viq02       date,                    /*消费日期                               */
viq03       varchar2(10),            /*消费地点                               */
viq04       number(20,6),            /*消费金额                               */
viq05       number(10),              /*消费积分                               */
viqplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
viqlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index viq_01 on viq_file (viq01);
grant select on viq_file to tiptopgp;
grant update on viq_file to tiptopgp;
grant delete on viq_file to tiptopgp;
grant insert on viq_file to tiptopgp;
grant index on viq_file to public;
grant select on viq_file to ods;
