/*
================================================================================
檔案代號:occm_file
檔案名稱:杂项客户主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table occm_file
(
occm01      varchar2(20) NOT NULL,   /*订单编号                               */
occm02      varchar2(20),            /*税号                                   */
occm03      varchar2(80),            /*公司全名一                             */
occm031     varchar2(80),            /*公司全名二                             */
                                     /*公司全名二  add 01/12/27               */
occm04      varchar2(255),           /*发票地址                               */
occm05      varchar2(255),           /*发票地址                               */
occm06      varchar2(255),           /*发票地址                               */
occm07      varchar2(255),           /*发票地址-4                             */
occm08      varchar2(255)            /*发票地址-5                             */
);

create        index occm_02 on occm_file (occm02);
alter table occm_file add  constraint occm_pk primary key  (occm01) enable validate;
grant select on occm_file to tiptopgp;
grant update on occm_file to tiptopgp;
grant delete on occm_file to tiptopgp;
grant insert on occm_file to tiptopgp;
grant index on occm_file to public;
grant select on occm_file to ods;
